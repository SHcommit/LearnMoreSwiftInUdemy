//
//  ViewController.swift
//  WeatherAPI
//
//  Created by 양승현 on 2022/11/17.
//

import UIKit
import Combine
/**
 
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
        
        self.cancellable = WebService.fetchWeather(city: "Houston")
            .catch { _ in Just(WeatherModel.placeholder)}
            .map { weather in
                if let temp = weather.temp {
                    return "\(temp) F"
                }
                return "error"
            }.assign(to: \.text, on: self.label)
            
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
    

}

