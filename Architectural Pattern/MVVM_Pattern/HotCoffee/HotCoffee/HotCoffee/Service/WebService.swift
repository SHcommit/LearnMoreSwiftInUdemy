//
//  WebService.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/03.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case decodingError
    //URL 실제로 없을경우
    case domainError
    case urlError
}
struct Resource<T: Codable> {
    let url       : URL
    var httpMethod: HTTPMethod = .get
    var body      : Data?
}

class Webservice {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let call = AF.request("https://warp-wiry-rugby.glitch.me/orders",method: resource.httpMethod, parameters: nil)
        
//        call.responseJSON{ response in
//            switch response.result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    if let JSON = response.value {
//                        do{
//                           let dataJson = try JSONSerialization.data(withJSONObject: JSON, options: [])
//                            let getInstanceData = try JSONDecoder().decode(T.self, from: dataJson)
//                            print(getInstanceData)
//                            completion(.success(getInstanceData))
//
//                        }catch{
//                            print(error)
//                        }
//                    }
//                }
//            case .failure(_):
//
//                break
//            }
//        }
        call.responseData{ res in
            switch res.result{
            case .success(_):
                guard let data = res.value else {print("not found data");return}
                let str = String(decoding: data, as: UTF8.self)
                print(str) // data is good
                let decoder = JSONDecoder()
                do{
                    let orders = try decoder.decode([Order].self, from: data)
                    //completion(.success(orders))
                    orders.forEach{
                        print("\($0.type!)\n\($0.name!)\n\($0.email)")
                    }
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(_):
                print("fail")
            }
         
        }
    }
        
}

