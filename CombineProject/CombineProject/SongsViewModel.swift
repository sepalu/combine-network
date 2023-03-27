//
//  SongsViewModel.swift
//  CombineProject
//
//  Created by Serena on 25/03/23.
//

// CLIENT SECRET
// -qKecFbhZU9vIHSoFRZCVipnH_zucMz_kr4ERBTq63snR12UM7cOTrPyjAjHq6ReLA5YaI0_KE5gDMTVs0QRNA

// CLIENT ID
// JW2t9YAkZJr1JrsagJLezNKIX1y534o5f0bKzCjv0pvbKFTYKvfFM-OJ0SCjyK08

// ACCESS TOKEN
// S-yVusLeYb37vqb-Kac3V9hcpxfYrfc3h9tRnQKIsYXFLZIpYqlZ_VG7_uHW30jO

import Foundation
import Combine

final class SongsViewModel: ObservableObject {
    private let token = "S-yVusLeYb37vqb-Kac3V9hcpxfYrfc3h9tRnQKIsYXFLZIpYqlZ_VG7_uHW30jO"
    var urlComponents = URLComponents()
    
    @Published var searchQuery = ""
    @Published var searchResponse: SearchResponse?
    @Published var songs: [Hit] = []
    
    var decoder = JSONDecoder()
    
    private var bag = Set<AnyCancellable>() // MARK: ??
    
    private var cancellable : AnyCancellable?
    
    init() {
        cancellable = $searchQuery
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main) //only run once the text has been static for 1 second
            .sink { (newSearch) in
                self.getSongs(queryItems: [URLQueryItem(name: "q", value: newSearch)])
            }
    }
    
    func getSongs(queryItems: [URLQueryItem]? = nil) {
        // build the url
        urlComponents.scheme = "https"
        urlComponents.host = "api.genius.com"
        urlComponents.path = "/search"
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else { return }

        // create the request
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main) // receive the changes from the background threads to the main one
            .map { $0.data } //
            .decode(type: SearchResponse.self, decoder: decoder)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Request finished successfully")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            } receiveValue: { [weak self] searchResponse in
                self?.searchResponse = searchResponse
                self?.songs.removeAll()
                for hit in searchResponse.response.hits {
                    self?.songs.append(hit)
                }
            }
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
            
            for item in response.response.hits {
                songs.append(item)
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
}
