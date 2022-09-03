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
    let url: URL
    
}

class Webservice {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let call = AF.request(resource.url, method: .post)
        call.response{ res in
            guard let jsonObj = try? res.result.get() , res.error == nil else {
                completion(.failure(.domainError))
                return
            }
            let res = try? JSONDecoder().decode(T.self, from: jsonObj)
            if let _res = res {
                //메인큐에서 비동기 처리하는 이유는 서버에서 받은 데이터는 바로 UI에 적용되기 때문. UI에서 뭘 하려면 메인큐 스레드에서 처리되는게 좋음.
                DispatchQueue.main.async {
                    completion(.success(_res))
                }
            }else {
                completion(.failure(.decodingError))
            }
            
            
        }
        
    }
}
