//
//  WebService.swift
//  networkFetchWithCombine
//
//  Created by 양승현 on 2022/11/16.
//

import Foundation
import Combine

struct Post: Codable {
    let title: String
    let body: String
}

struct WebService {
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { fatalError()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
}
