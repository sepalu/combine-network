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
    @Published var songs: [Hit] = []
    
    var decoder = JSONDecoder()
    
    private var bag = Set<AnyCancellable>() // keeps track of all the subscriptions created by Combine
    private var cancellable : AnyCancellable? // we use it to cancel a subscription to a publisher
    
    init() {
        cancellable = $searchQuery
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main) // runs each 200ms
            .sink { (newSearch) in
                // a new search is performed using new query items
                self.getSongs(queryItems: [URLQueryItem(name: "q", value: newSearch)])
            }
        /// `sink` operator performs an action whenever the publisher emits a new value
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
            .dataTaskPublisher(for: request) // create a data task publisher for URLRequest
            .receive(on: DispatchQueue.main) // receive the changes from the background threads to the main one
            .map { $0.data } // extract the data (type Data)
            .decode(type: SearchResponse.self, decoder: decoder)
            .sink { completion in // handle completion of the task
                // it uses the enum Subscribers.Completion that only has two values (.finished and .failure)
                switch completion {
                case .finished:
                    print("Request finished successfully")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            } receiveValue: { [weak self] searchResponse in // handle the value received from the publisher
                // this code is executed each time the decoder succeeds
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
