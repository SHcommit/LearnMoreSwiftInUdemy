//
//  ViewController.swift
//  Codable
//
//  Created by 양승현 on 2022/09/04.

//https://www.youtube.com/watch?v=w7xJrAYQoHE

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let urlStr = "https://api.sunrise-sunset.org/json?date=2022-9-1&lng=37.3230&lat=-122.0322&formatted=0"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //useURLSessionNotApplyCodable()
        useURLSessionApplyCodable()
        //useAlamoFireDecodable()
        //useAFData()
    }
}

extension ViewController {

    func useURLSessionNotApplyCodable() {
        // 1. set URLRequest Line-Header-body
        guard let url = URL(string: urlStr) else {
            return
        }
        
        guard var request = try? URLRequest(url: url) else {
            print("Can't get URLRequest instance")
            return
        }
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // 2. url 객체로 구현된 Request를 통한 dataTask HTTP통신
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, error == nil else {
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: _data, options: []) as? NSDictionary else{
                print("can't parse as NSDictionary")
                return
            }
            
            let status = json["status"] as? String ?? ""
            guard let results = json["results"] as? NSDictionary else {
                print("results key value is nil")
                return
            }
            let sunrise = results["sunrise"] as? String ?? ""
            let sunset  = results["sunset"] as? String ?? ""
            let solar_noon = results["solar_noon"] as? String ?? ""
            let day_length = results["day_length"] as? Int ?? -1
            let civil_twilight_begin = results["civil_twilight_begin"] as? String ?? ""
            let civil_twilight_end   = results["civil_twilight_end"] as? String ?? ""
            let nautical_twilight_begin = results["nautical_twilight_begin"] as? String ?? ""
            let nautical_twilight_end   = results["nautical_twilight_end"] as? String ?? ""
            let astronomical_twilight_begin = results["astronomical_twilight_begin"] as? String ?? ""
            let astronomical_twilight_end = results["astronomical_twilight_end"] as? String ?? ""
            
            let _results = WeatherResponseDefault(sunrise: sunrise, sunset: sunset, solar_noon: solar_noon, day_length: day_length, civil_twilight_begin: civil_twilight_begin, civil_twilight_end: civil_twilight_end, nautical_twilight_begin: nautical_twilight_begin, nautical_twilight_end: nautical_twilight_end, astronomical_twilight_begin: astronomical_twilight_begin, astronomical_twilight_end: astronomical_twilight_end)
            
            let weatherInfo = APIResponseDefault(results: _results, status: status)
            
        }
        task.resume()
    }
    func useURLSessionApplyCodable(){
        
        // 1. set URLRequest Line-Header-body
        guard let url = URL(string: urlStr) else {
            return
        }
        
        guard var request = try? URLRequest(url: url) else {
            print("Can't get URLRequest instance")
            return
        }
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // 2. url 객체로 구현된 Request를 통한 dataTask HTTP통신
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _data = data, error == nil else {
                return
            }
            
            guard let res = try? JSONDecoder().decode(APIResponse.self, from: _data) else {
                print("Can't deocde")
                return
            }
            print(res)
        }
        task.resume()

    }

    func useAlamoFireDecodable(){
        //RESIful API에 데이터 요청
        let call = AF.request(urlStr, method: .get, encoding: JSONEncoding.default)
        
        //Decode
        call.responseDecodable(of: APIResponse.self){ response in
            guard response.error == nil else{
                print("에러")
                return
            }
            switch response.result{
            case .success(_):
                guard let _data = response.value else {
                    print("Failed binding response.value")
                    return
                }
                print(_data.results)
                break
            case .failure(_):
                break
            }
        }
    }
    func useAFData() {
        let call = AF.request(urlStr, method: .get, encoding: JSONEncoding.default)
        
        call.responseData{ response in
            guard response.error == nil else{
                print("에러")
                return
            }
            switch response.result {
            case .success(_):
                guard let _data = try? response.result.get() else {
                    print("Faild binding response.result")
                    return
                }
                print(_data)
                
                guard let res = try? JSONDecoder().decode(APIResponse.self, from: _data) else {
                    print("Can't decode")
                    return
                }
                print(res)
                
            case .failure(_):
                break
            }
        }
    }
    
}

/**
 TODO : API Codable로 정확하게 표현해주기
 
 - Param <#ParamNames#> : <#Discription#>
 - Param <#ParamNames#> : <#Discription#>
 
 @REST API
 {
    "results":{
       "sunrise":"2022-09-01T02:45:56+00:00",
       "sunset":"2022-09-01T16:15:33+00:00",
       "solar_noon":"2022-09-01T09:30:45+00:00",
       "day_length":48577,
       "civil_twilight_begin":"2022-09-01T03:23:30+00:00",
       "civil_twilight_end":"2022-09-01T15:37:59+00:00",
       "nautical_twilight_begin":"2022-09-01T04:08:49+00:00",
       "nautical_twilight_end":"2022-09-01T14:52:41+00:00",
       "astronomical_twilight_begin":"2022-09-01T04:54:38+00:00",
       "astronomical_twilight_end":"2022-09-01T14:06:51+00:00"
    },
    "status":"OK"
 }
 
 # Notes: #
 1. 위에서 보이는 JSON에서 Top-Level의 키로 반환하는 것은 results와 status이다.
    간략하고 쉽게 표현하자면
    let dictionary : NSDictionary = ["results" : NSDictionary타입, "status" : "OK"] 이렇게 볼수있다.
 2. 1.에서 파악한 top-level의 키로써 두개의 key를 프로퍼티로 정의해준다.
    이때 results는 날씨정보를 담고있는 딕셔너리이므로 날씨정보를 담고있는 Model을 새로 정의해준다.
 3. REST API에 관련된 모든 JSON 키를 정의했다면 이제 고민해야함.
    482 bytes의 데이터를 어떻게
    만약 JSON에 없는 값이면 ?연산자를 붙이는게 맞는데 다 있으니까 "?", "!" 옵셔널 x
 */
struct APIResponse: Codable{
    let results : WeatherResponse
    let status  : String
}

struct WeatherResponse: Codable{
    var sunrise: String
    let sunset: String
    let solar_noon: String
    let day_length: Int
    let civil_twilight_begin: String
    let civil_twilight_end: String
    let nautical_twilight_begin: String
    let nautical_twilight_end: String
    let astronomical_twilight_begin: String
    let astronomical_twilight_end: String
}


struct APIResponseDefault{
    var results : WeatherResponseDefault
    var status  : String
}

struct WeatherResponseDefault{
    var sunrise: String
    var sunset: String
    var solar_noon: String
    var day_length: Int
    var civil_twilight_begin: String
    var civil_twilight_end: String
    var nautical_twilight_begin: String
    var nautical_twilight_end: String
    var astronomical_twilight_begin: String
    var astronomical_twilight_end: String
    
}
