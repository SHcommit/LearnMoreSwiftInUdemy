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
        //useURLSessionApplyCodable()
        getDataUsingAlamoFire()
    }
}

extension ViewController {

    func useURLSessionNotApplyCodable() {
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        guard var request = try? URLRequest(url: url) else {
            print("Can't get URLRequest instance")
            return
        }
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, error == nil else {
                return
            }
            print("data : \(_data)")
            guard let json = try? JSONSerialization.jsonObject(with: _data, options: []) as? [String:Any] else{
                print("can't parsing as NSDictionary")
                return
            }
            print(json)
        }
        task.resume()
    }
    func useURLSessionApplyCodable(){
        guard let url = URL(string: urlStr) else {
            return
        }
        
        guard var request = try? URLRequest(url: url) else {
            print("Can't get URLRequest instance")
            return
        }
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, error == nil else {
                return
            }
            //1. decode 할 객체 선언
            var res: APIResponse?
            
            do{
                res = try? JSONDecoder().decode(APIResponse.self, from: _data)
                
            }catch{
                print("Failed to decode with error: \(error.localizedDescription)")
            }
            
            guard let _res = res else{
                return
            }
            print(_res.results)
        }
        task.resume()

    }

    func getDataUsingAlamoFire(){
        let call = AF.request(urlStr, method: .get, encoding: JSONEncoding.default)
        
        call.responseDecodable(of: APIResponse.self){ response in
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
    let sunrise: String
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
