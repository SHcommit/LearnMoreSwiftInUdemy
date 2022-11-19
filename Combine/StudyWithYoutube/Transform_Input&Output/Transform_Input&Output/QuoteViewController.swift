//
//  ViewController.swift
//  Transform_Input&Output
//
//  Created by 양승현 on 2022/11/19.
//

import UIKit
import Combine

class QuoteViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    private let vm = QuoteViewModel()
    private let input: PassthroughSubject<QuoteViewModel.Input,Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //즉 input은 vc가 vm한테 값을 요청한다
        input.send(.viewDidAppear)
        
    }
    
    private func bind() {
        let output = vm.transform(withInput: input.eraseToAnyPublisher())
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .fetchQuoteDidFail(let error):
                    print("Error:\(error.localizedDescription)")
                case .fetchQuoteDidSucceed(let quote):
                    self?.quoteLabel.text =  quote.content
                case .toggleButtoN(let isEnabled):
                    self?.refreshButton.isEnabled = isEnabled
                }
            }.store(in: &cancellables)
    }

    @IBAction func didTappedRefreshButton(_ sender: Any) {
        input.send(.refreshButtonDidTap)
    }
}

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

/*
    VC로부터 값을 capture해서 apicall input값에 넣는다.
    그래서 quote service인 webservice의 reference가 있어야한다.
 
     vm에서 해야할 것은 무엇인가?
     input, output을 정해야한다.
     input의 경우 vm에서 얻는거
     output의 경우 viewModel로부터 특정 VC가 얻는 것
 */
class QuoteViewModel {
    //뷰 모델이 무엇을 얻어야하는가?
    //vc로부터 온다.
    //이 두 경우에 vm이 작동한다.
    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }
    
    // VM에서 fetch로 데이터 파싱을 한 후의 결과가 아웃풋의 한 case가 된다.
    // 그리고 VCㅇ서 enable, disable됬는지의 여부도 필요하다
    enum Output {
        case fetchQuoteDidFail(error: Error)
        case fetchQuoteDidSucceed(quote: Quote)
        case toggleButtoN(isEnabled: Bool)
    }
    
    //왜 protocol을 사용하는가? 클래스 대신?
    // unit test할 때 좋음
    // 이를 depencency injection(주입)
    // quote viewmodel이 반드시 initialize를 해야한다. 기본적인 property.. 즉 quoteVM이 살아있어야만 쓸수있음
    private let quoteServiceType: WebServiceType
    private let output: PassthroughSubject<Output,Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(quoteServiceType: WebServiceType = WebService()) {
        self.quoteServiceType = quoteServiceType
    }
    
    //input이 주어지면 output으로 전환하는 작업
    //여기서 output의 경우 event작업을 반환하는 것이기 때문에 never
    func transform(withInput input: AnyPublisher<Input,Never>) -> AnyPublisher<Output,Never> {
        input.sink {[weak self] event in
            switch event {
            case .viewDidAppear , .refreshButtonDidTap:
                self?.getQuote()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getQuote() {
        Task() {
            do {
                let quote = try await quoteServiceType.fetchRandomQuote()
                print("data: \(quote)")
                output.send(.fetchQuoteDidSucceed(quote: quote))
            }catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
}

struct Quote: Decodable {
    let content: String
    let author: String
}
