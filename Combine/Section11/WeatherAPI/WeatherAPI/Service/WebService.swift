//
//  WebService.swift
//  WeatherAPI
//
//  Created by 양승현 on 2022/11/17.
//

import Foundation
import Combine


struct WebService {
    
    static func fetchWeather(city: String) -> AnyPublisher<WeatherModel,Error> {
        guard let url = URL(string: Constants.URLs.weather) else { fatalError() }
        
        return  URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponseModel.self, decoder: JSONDecoder())
            .map { $0.main }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
}
