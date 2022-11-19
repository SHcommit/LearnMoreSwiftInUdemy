import UIKit

protocol WebServiceType {
    //일반적인 service
    //func fetchRandomQuote(completion: (Result<Quote, Error) -> Void)
    func fetchRandomQuote() async throws -> Quote
    
}

class WebService: WebServiceType {
    
    enum NetworkError: Error {
        case failToBindingStringToURL
    }
    
    func fetchRandomQuote() async throws -> Quote {
        guard let url = URL(string: PrivateURLs.quotableURL) else { throw NetworkError.failToBindingStringToURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        return quote
    }
}

