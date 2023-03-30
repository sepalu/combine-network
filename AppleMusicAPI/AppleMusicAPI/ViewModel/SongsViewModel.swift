//
//  SongsViewModel.swift
//  CombineProject
//
//  Created by Serena on 25/03/23.
//

import Foundation
import Combine

final class SongsViewModel: ObservableObject {
    var urlComponents = URLComponents()
    
    @Published var searchQuery = ""
    @Published var songs: [SearchResponseDatum] = []
    @Published var albums: [AlbumDatum] = []
    
    var decoder = JSONDecoder()
    
    private var bag = Set<AnyCancellable>() // keeps track of all the subscriptions created by Combine
    private var cancellable : AnyCancellable? // we use it to cancel a subscription to a publisher
    
    init() {
        cancellable = $searchQuery
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main) // runs each 200ms
            .sink { (newSearch) in
                // a new search is performed using new query items
                self.getSongs(queryItems: [URLQueryItem(name: "term", value: newSearch)])
            }
        /// `sink` operator performs an action whenever the publisher emits a new value
    }
    
    func getSongs(queryItems: [URLQueryItem]? = nil) {
        // build the url
        urlComponents.scheme = "https"
        urlComponents.host = "api.music.apple.com"
        urlComponents.path = "/v1/catalog/us/search"
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
//        urlComponents.queryItems?.append(URLQueryItem(name: "type", value: "songs"))
        guard let url = urlComponents.url else { return }
        
        // create the request
        var request = URLRequest(url: url)
        request.addValue("Bearer \(appleToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared
            .dataTaskPublisher(for: request) // create a data task publisher for URLRequest
            .receive(on: DispatchQueue.main) // receive the changes from the background threads to the main one
            .map { $0.data } // extract the data (type Data)
            .decode(type: SearchResponse.self, decoder: decoder)
            .flatMap { [weak self] searchResponse -> AnyPublisher<Void, Error> in
                self?.songs.removeAll()
                self?.albums.removeAll()
                for song in searchResponse.results.songs.data {
                    self?.songs.append(song)
                }
                let artistIds = searchResponse.results.artists.data.map { $0.id }
                return Publishers.Sequence(sequence: artistIds)
                    .flatMap { artistId -> AnyPublisher<Void, Error> in
                        // create a new publisher for each song ID
                        guard let self = self else { return Empty().eraseToAnyPublisher() }
                        let url = URL(string: "https://api.music.apple.com/v1/catalog/us/artists/\(artistId)/albums")!
                        var request = URLRequest(url: url)
                        request.addValue("Bearer \(appleToken)", forHTTPHeaderField: "Authorization")
                        return URLSession.shared
                            .dataTaskPublisher(for: request)
                            .receive(on: DispatchQueue.main) // receive the changes from the background threads to the main one
                            .map { $0.data }
                            .tryMap { data -> Void in
                                // handle the data and do something with it
                                do {
                                    let result = try self.decoder.decode(AlbumResponse.self, from: data)
                                    for album in result.data {
                                        self.albums.append(album)
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                                return ()
                            }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { completion in // handle completion of the task
                // it uses the enum Subscribers.Completion that only has two values (.finished and .failure)
                switch completion {
                case .finished:
                    print("Request finished successfully")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            } receiveValue: { _ in }
            .store(in: &bag)
    }
    
    // async function to get songs without using Combine
    func getSongsOld(queryItems: [URLQueryItem]? = nil) async {
        // build the url
        urlComponents.scheme = "https"
        urlComponents.host = "api.genius.com"
        urlComponents.path = "/search"
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else { return }
        
        // create the request
        var request = URLRequest(url: url.absoluteURL)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try decoder.decode(SearchResponse.self, from: data)
            print(response)
            
            for item in response.results.songs.data {
                songs.append(item)
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
}
