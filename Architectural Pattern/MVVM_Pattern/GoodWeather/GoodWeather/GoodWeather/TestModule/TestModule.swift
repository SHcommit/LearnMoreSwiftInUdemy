//
//  TestModule.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/10.
//

import Foundation
import UIKit

class TestModule {
    var testWebservice = TestWebservice()
    var testWeatherResponse = TestWeatherResponse()
    var testWeatherDelegate = TestWeatherDelegate()
    func testStartWebservice() {
        testWebservice.testCombineURL()
        testWebservice.testDataParsing()
    }
    func testStartWeatherResponse() {
        testWeatherResponse.testResponse()
    }
    func testStartWeatherDelegate(segue: UIStoryboardSegue) {
        testWeatherDelegate.testSelectWeatherDelegate(segue: segue)
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

struct TestWeatherDelegate : AddLocalWeatherDelegate {
    func addLocalWeatherDidSave(vm: WeatherViewModel) {
        print("\(vm)")
    }
    
    func testSelectWeatherDelegate(segue: UIStoryboardSegue) {
        guard let vc = segue.destination as? AddLocalWeather else {
            print("Fail")
            return
        }
        
        vc.delegate = self
    }
    
}
