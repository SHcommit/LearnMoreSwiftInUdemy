//
//  ViewController.swift
//  WeatherAPI
//
//  Created by 양승현 on 2022/11/17.
//

import UIKit
import Combine
/**
    어떻게하면 textfield를 입력할 때마다 값을 얻어올 수 있을까?
    어떻게 하면 사용자가 버튼을 눌렀을때 fetch후 lb를 갱신할 수 있을 까?
 
 self.cancellable = WebService.fetchWeather(city: "Houston")
     .catch { _ in Just(WeatherModel.placeholder)}
     .map { weather in
         if let temp = weather.temp {
             return "\(temp) F"
         }
         return "error"
     }.assign(to: \.text, on: self.label)
 
    cancellable에 값을 넣는 위 로직은 WebService.fetchWeater(city:)를 통해 만든 특정 dataTaskPublisher를 anyPubliahser로 반환한 publisher이다.
    textfield를 통해 입력을 하면 notification을 통해서 알 수 있다.
 */
class ViewController: UIViewController {
    var label: UILabel = {
       let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.textAlignment = .center
        lb.text = "placeholder"
        return lb
    }()
    
    var tf: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.placeholder = "input city"
        tf.textAlignment = .center
        return tf
    }()
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
        
        setupPublishers()
        
            
    }
    func configure() {
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        view.addSubview(tf)
        NSLayoutConstraint.activate([
            tf.topAnchor.constraint(equalTo: label.bottomAnchor),
            tf.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tf.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    private func setupPublishers() {
        // 퍼블리셔를 setup해준다.
        // publish event.. 사용자의 input textfield와 같은
        
        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,object: self.tf)
        /**
            debounce(for:scheduler:)
            특정 기간을 기다리게 한 다음에 publisher를 시작할 수 있는 함수
            즉 우리가 textfield를 치는데 칠 때 모든 시간마다 webservice로부터 호출하게 되면 노굿임 낫굿퍼포먼스
                그래서 사용자가 더이상 터치를 하지 않을 때까지 기다린 다음에 비로소 api로 request... 대박인데;;
         
            addingPercentEncoding(withAllowedCharacters:)를쓴 이유는
            사용자는 검색을 할 때 San Antonio이렇게 검색을한다. 공백이 붙여있는데 url은 San%20Antonio 이렇게 특수문자로 공백을사용하기 때문에 encoding한 것이다.
         */
        self.cancellable = publisher
            .compactMap { notification in
            return  (notification.object as? UITextField)?.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            }.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .flatMap{ city in
                return WebService.fetchWeather(city: city)
                    .catch{ _ in
                        Just(WeatherModel(temp: 0.0, humidity: 0.0))
                    }
                    .map { $0 }
            }.sink {
                
                self.label.text = "\($0.temp) F"
            }
        //.catch{ _ in Empty()}
    }
    

}

