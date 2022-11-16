//
//  ViewController.swift
//  switchToLatest
//
//  Created by 양승현 on 2022/11/16.
//

import UIKit
import Combine


class ViewController: UIViewController {
    let images = ["1","2","3"]
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //studySwitchToLatest()
        
        //studyMergeComgineOperator()
        studyCombineLatestCombineOperator()
    }
    

}


extension ViewController {
    func studySwitchToLatest() {
        
        // 탭을 누르 때마다 이미지를 다운로드한다.
        
        let taps = PassthroughSubject<Void,Never>()
        _ = taps.map { _ in self.getImage() }
            .switchToLatest()
            .print()
            .sink {
                print($0)
            }
        taps.send()
        //taps.send()를 호출 할 때
        //위에서 taps.map{}의 sink를 통해 subscription을 반환하면서 published된 value를 sink의 클로저로 반환받는다.
        //근데 sink전에 output stream을 Future를 통해 image를 보낸다.
        //Future는 publisher의 output값인 것 같다. publisher의 output을 Future에 담아서 published한다.
        //그렇다면 sink를 통해 publisher로부터 observed된 received value로 Feture<UIImage,Never>가 온다.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.index += 1
            taps.send()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.7) {
            self.index += 1
            taps.send()
        }
    }
    
    func getImage() -> AnyPublisher<UIImage?,Never> {
        
        //future로 이미지를 즉시 다운로드한다. 그리고 some time에 평가된다.
        return Future<UIImage?, Never> { promise in
            //여기서 promiss를 통해 성공, error 를 처리한다.
            DispatchQueue.global().asyncAfter(deadline: .now()+3.0) {
                promise(.success(UIImage(named:self.images[self.index])))
            }
        }.map{ $0 }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        // eraseToAnyPublisher()를 씀으로 publisher가 알지 못해도 보낼 수 있다.
    }
}

extension ViewController {
    func studyMergeComgineOperator() {
        let publisher1 = PassthroughSubject<Int,Never>()
        let publisher2 = PassthroughSubject<Int,Never>()
        
        _ = publisher1.merge(with: publisher2).sink {
            print($0)
        }
        
        publisher1.send(19)
    }
    
    func studyCombineLatestCombineOperator() {
        let publisher1 = PassthroughSubject<Int,Never>()
        let publisher2 = PassthroughSubject<String,Never>()
        _ = publisher1.combineLatest(publisher2).sink {
            print("p1: \($0), p2: \( $1)")
        }
        publisher1.send(10)
        publisher2.send("s")
    }
}
