//
//  ViewController.swift
//  ResourcesInCombine
//
//  Created by 양승현 on 2022/11/17.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var data: Data? {
        didSet {
            print(data)
            //여기서 이제 이미지 등으로 바꾸는 거 한 다음에 tableView.reloadData처리 해도되
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        understandingTheProblem()
    }


}

extension ViewController {
    
    func understandingTheProblem() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { fatalError()
        }
        
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
//            guard let data = data else { return }
//            self.data = data
//        }
//        task.resume()
                                              
        let requestPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .print()
            .share()

        let subscription = requestPublisher.sink( receiveCompletion: {_ in} ) {
            print($0)
        }
        
        let subscription2 = requestPublisher.sink( receiveCompletion: {_ in} ) {
            print($0)
        }
        
    }
}

