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
    let url       : String
    var httpMethod: HTTPMethod = .get
    var body      : Data?
}

class Webservice {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T,NetworkError>) -> Void) {
        let call = AF.request(resource.url,method: .get)
        
        call.responseDecodable(of:T.self){ response in
            guard let data = response.value,response.error == nil else {
                print("responseDecodable has error")
                return
            }
            switch response.result{
            case .success(_):
                completion(.success(data))
            case .failure(_):
                completion(.failure(.decodingError))
            }
        }
//        call.responseData{ res in
//            switch res.result{
//            case .success(_):
//                guard let data = res.value else {print("not found data");return}
//                let str = String(decoding: data, as: UTF8.self)
//                print(str) // data is good
//                let decoder = JSONDecoder()
//                do{
//                    let orders = try decoder.decode([Order].self, from: data)
//                    //completion(.success(orders))
//                    orders.forEach{
//                        print("\($0.type)\n\($0.name)\n\($0.email)")
//                    }
//                }catch{
//                    print(error.localizedDescription)
//                }
//            case .failure(_):
//                print("fail")
//            }
//
//        }
    }
        
}

