//
//  AddLocalWeather.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/09.
//

import UIKit

class AddLocalWeather : UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBAction func saveCityButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add City"
        setupNavigationBackground()
        TestModule().start()
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
