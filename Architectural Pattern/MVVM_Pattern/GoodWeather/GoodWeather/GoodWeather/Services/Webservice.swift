//
//  Webservice.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/10.
//

import Foundation
import Alamofire

class HTTPResource {
    var privateKey = PrivateWebservice().apiKey
    var url: String = "https://api.openweathermap.org/data/2.5/weather?lang=kr"
    
    var city: String = ""
    var selectedUnit = (UserDefaults.standard.value(forKey: "unit") as? String ) ?? "imperial"
    var options :String {
        get {
            return "units=" + self.selectedUnit
        }
    }
    var searchCity: String {
        get {
            return city.isEmpty ? "Seoul" : self.city
        }
        set(value) {
            self.city = "q=\(value)"
        }
    }
    func combineURL(city: String) -> String {
        self.searchCity = city
        return "\(url)&\(self.searchCity)&\(options)&\(privateKey)"
    }
}


struct Resource<T> {
    var searchedCity = ""
    var url: String {
        get {
            return HTTPResource().combineURL(city: searchedCity)
        }
        set(value) {
            self.searchedCity = value
        }
    }
    //네트워크 call로부터 데이터를 파싱해서 적절한 타입 T로 반환할 수 있는 클로저
    let parse: (Data) -> T?
    
}
/*
     f
 */
final class Webservice {
    //데이터를 fetch했을때 실행되는 클로저
    func load<T>(resource: Resource<T>, completion: @escaping ((T?)-> ())) {
        let call = AF.request(resource.url,method: .get, headers: ["Content-Type": "application/json"])
        call.responseData{ response in
            guard let data = try? response.result.get() , response.error == nil else {
                print("Failure paresd Data to instance")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                print("Success parsed data = \(data)")
                completion(resource.parse(data))
            }
        }
    }
}
