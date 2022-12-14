//
//  WeatherModel.swift
//  WeatherAPI
//
//  Created by μμΉν on 2022/11/17.
//

import Foundation


struct WeatherResponseModel: Decodable {
    let main: WeatherModel
}

struct WeatherModel: Decodable {
    let temp: Double
    let humidity: Double
    
    static var placeholder: WeatherModel? {
        return nil
    }
}
