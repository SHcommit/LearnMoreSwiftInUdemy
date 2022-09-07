import Foundation
import Alamofire

enum NetworkError: Error {
    case decodingError
    //URL 실제로 없을경우
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

 //요기엔 HTTP메서드의 헤더와 바디(data)가 있음.
struct Resource<T: Codable> {
    let url       : String
    var httpMethod: HTTPMethod = .get
    var body      : Data? = nil
}

extension Resource {
    init(url: String) {
        self.url = url
    }
}

class Webservice<T> where T: Codable{
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T,NetworkError>) -> Void) {
        let call = AF.request(resource.url,method: .get)
        call.responseDecodable(of:T.self){ response in
            guard response.error == nil else {
                print("responseDecodable has error")
                return
            }
            self.loadResult(response: response, completion: completion)
        }
    }
    
    func loadResult<T>(response: DataResponse<T,AFError>,completion: @escaping (Result<T,NetworkError>)->Void){
        switch response.result {
        case .success(_):
            guard let data = response.value else {return}
            completion(.success(data))
        case .failure(_):
            completion(.failure(.decodingError))
        }
    }
}

