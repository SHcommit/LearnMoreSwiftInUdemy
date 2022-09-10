//
//  TestModule.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/10.
//

import Foundation

class TestModule {
    var testWebservice = TestWebservice()
    func start() {
        testWebservice.testCombineURL()
        testWebservice.testDataParsing()
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
