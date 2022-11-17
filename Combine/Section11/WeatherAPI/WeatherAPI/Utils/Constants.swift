//
//  Constants.swift
//  WeatherAPI
//
//  Created by 양승현 on 2022/11/17.
//

import Foundation


struct Constants {
    struct URLs {
        static let weather = "http://api.openweathermap.org/data/2.5/weather?&q=London&units=imperial&\(APIKeys.weatherAPIKey)"
    }
}
