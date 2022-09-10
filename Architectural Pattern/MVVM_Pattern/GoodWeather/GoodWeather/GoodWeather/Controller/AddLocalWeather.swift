//
//  AddLocalWeather.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/09.
//

import UIKit

protocol AddWeatherDelegate {
    func addWeatherDidSave(vm: WeatherViewModel)
}

class AddLocalWeather : UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBAction func saveCityButton(_ sender: Any) {
        if let city = cityNameTextField.text {
            AddWeatherViewModel().addWeather(for: city) { vm in
                
            }
        }
    }
    private var addWeatherVM = AddWeatherViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add City"
        setupNavigationBackground()
        TestModule().testStartWebservice()
        TestModule().testStartWeatherResponse()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBackground()
    }
}

extension AddLocalWeather {
    func setupNavigationBackground() {
        guard let navBar = self.navigationController?.navigationBar else {
            return
        }
        self.setupNavigationAppearance(navBar: navBar)
    }
}
