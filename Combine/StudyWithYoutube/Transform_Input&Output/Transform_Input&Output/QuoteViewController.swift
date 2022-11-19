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
