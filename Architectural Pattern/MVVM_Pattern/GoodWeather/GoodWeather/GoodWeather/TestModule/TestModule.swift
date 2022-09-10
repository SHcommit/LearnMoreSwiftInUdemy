//
//  TestModule.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/10.
//

import Foundation

class TestModule {
    var testWebservice = TestWebservice()
    var testWeatherResponse = TestWeatherResponse()
    func start() {
        testWebservice.testCombineURL()
        testWebservice.testDataParsing()
        testWeatherResponse.testResponse()
    }
    
}

class TestWebservice {
    func testCombineURL() {
        print("Success http url combination: \(HTTPResource().combineURL(city: "Daejeon"))")
    }
    func testDataParsing() {
        var resource = Resource(searchedCity: "Daejeon") { _ in
        }
        let weatherResource = Resource<Any>(searchedCity: "Daejeon") { data in
            return data
        }
        Webservice().load(resource: weatherResource) { result in
        }
    }
}

class TestWeatherResponse {
    func testResponse() {
        let resource = Resource<WeatherResponse>(searchedCity: "Daejeon") { data in
            return try? JSONDecoder().decode(WeatherResponse.self, from: data)
        }
        Webservice().load(resource: resource) { weatherResponse in
            guard let _weatherResponse = weatherResponse else {
                print("weatherResponse is nil")
                return
            }
            print("Success decoding :\(_weatherResponse)")
        }
    }
}
