//
//  ViewController.swift
//  Section2
//
//  Created by 양승현 on 2022/11/14.
//

import UIKit
import Combine


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //implementingASubscriber()
        subjects()
    }
}

/**
 TODO : Implementing a subscriber
 
 - Param Input : StringSubscriber가 작업할 종류이다.
    -> String. 이유는 pubilsher로부터 subscription된 값들은 String이기 때문이다.
 - Param Failure : Subscriber로 부터 몇 종류의 errors를 expect 할 수 있다.
    -> Never. 절때 실패하지 않을 것이기 때문에 Never  type로 정의
 
 # Notes: #
 1. Subscriber를 통해서 subscribe를 구현할 수 있다. 근데 프로토콜임으로 채택을 해주어야 한다.
    두개의 typealias가 있다.
 
    - receive(subscription:)
        // subscription을 받는 함수
        //subscriber가 subscription을 받을 때!!
    - receive(_:)
        //실제로 값을 얻는 함수
        //  반환 값으로 Subscribers.Demand를 반환 받을 수 있다.
        //backpressure(몇개 받을건지) 를 변경하고 싶니? 많이 받거나 적게 받고 싶니??
        // .none(처음에 subscription할때 사용했던 개수 그대로 받을거에요 , .max(_:) ... , unlimited : 가지고 있는거 다 보내!! -> completion 함수 뜸
    - receive(completion:)
        //completion을 받는 함수
        //publisher가 event를 published했을때 보내는 함수
 */
class StringSubscriber: Subscriber {
    
    typealias Input = String
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        print("DEBUG: Received subscription")
        
        //이때 얼마나 많은 아이템을 받을 수 있는지 또한 request할 수 있다.
        //publisher야 내게 보내지 않을 아이템 중에 3개만 얼렁 보내봐
        //backpressure
        subscription.request(.max(3))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("DEBUG: Received value :\(input)")
        
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("DEBUG: Published completed")
    }
    
}

//MARK: - Implementing a subscriber
extension ViewController {
    
    func implementingASubscriber() {
        let publisher = ["A", "B", "C", "D", "E", "F", "G", "H", "I"].publisher
        
        let subscriber = StringSubscriber()
        publisher.subscribe(subscriber)
    }
}

enum MyError: Error {
    case subscriberError
}

class StringSubscriberForStudySubjects: Subscriber {
    
    typealias Input = String
    typealias Failure = MyError
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print(input)
        return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        print("Completion")
    }
    
}

//MARK: - Subjects
extension ViewController {
    /**
     # Notes: #
     1. Subsctibers는 굉장히 특별하다.
        -  publisher, subscribers 둘다 갖고 있기 때문이다.
     
     # Example #
     ```
     // <#Example code if any#>
     ```
     
     */

    func subjects() {
        
        let subscriber = StringSubscriberForStudySubjects()
        //PassthroughSubject는 demand에 의해 새로운 값을 publish할 수 있게 해준다.
        // 타입은 PassthroughSubject<Any,Failure:Error> 타입이다.
        let subject = PassthroughSubject<String, MyError>()
        subject.subscribe(subscriber)
        
        // 여기서 subject.subscription(subscriber)를 통해서 subscription을 만들수도있지만
        let subscription = subject.sink(receiveCompletion: { completion in
            print("Received completion from sink")
        }) { receiveValue in
            print("Received value from sink")
        }
        
        subject.send("A")
        subject.send("B")
        //이경우 C는 출력하지 않는다. 그이유는 subscribtion.request(.max(2))로 했기 때문이다.
        //최대 request를 2로 설정했기 때문에
        
        subscription.cancel()
        
        subject.send("C")
        subject.send("D")
        subject.send("E")
        
    }
}

//MARK: -
//타입 뒤에 다른 타입을 숨긴다.
extension ViewController {
    func typeEraserStudy() {
        
        // 때때로 우리가 사용한 타입 publisher의 세부 사항을 숨기고 싶은 경우
        // 클라이언트다 타 사용자가 PassthroughSubject로 publisher를 사용하는 경우를 숨기고 싶은 경우
        // .eraseToAnyPublisher() 함수를 사용한다.
        // 실제로 publisher를 지우지는 않고 다른 호출된 publisher뒤에 붙인다.
        // 그럼 AnuPublisher 타입을 반환한다.
        //원래는  PassthroughSubject인데 .eraseToAnyPublisher()로 숨겼기에 AnyPublisher타입이라고 칭해진다.
        // 근데 PassthroughSubject 타입임.
        let publisher = PassthroughSubject<Int, Never>().eraseToAnyPublisher()
        //이렇게 될 경우 PassthroughSubject 타입처럼 사용하지만 작동되지 않는다.
        //사용할 경우 PassthroughSubject 타입으로 캐스팅 한다.
        // 그렇기에 publisher의 세부 title 등을 알지 못한다.
        //따라서 오직 그들이 원하는 물건만 얻을 수 있다.
        
        let publisher1 = PassthroughSubject<String,Never>()
        let publisher2 = PassthroughSubject<String,Never>()
        
        let publishers = PassthroughSubject<PassthroughSubject<String,Never>,Never>()
        
        publishers.send(<#T##input: PassthroughSubject<String, Never>##PassthroughSubject<String, Never>#>)
        
    }
    
}
