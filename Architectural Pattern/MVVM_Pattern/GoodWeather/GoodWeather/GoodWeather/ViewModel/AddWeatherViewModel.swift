//
//  AddWeatherViewModel.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/11.
//

import Foundation


class AddWeatherViewModel {
    
    func addWeather(for city: String, completion: @escaping (WeatherViewModel) -> Void) {
        let weatherResource = Resource<WeatherResponse>(searchedCity: city) { data in
            return try? JSONDecoder().decode(WeatherResponse.self, from: data)
        }
        
        Webservice().load(resource: weatherResource) { result in 
            guard let weatherResource = result else {
                return
            }
            let vm = WeatherViewModel(weather: weatherResource)
            completion(vm)
        }
    }
}
