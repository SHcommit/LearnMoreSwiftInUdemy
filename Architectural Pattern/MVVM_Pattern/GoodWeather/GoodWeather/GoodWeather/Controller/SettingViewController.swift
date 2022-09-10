//
//  SettingViewController.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/09.
//

import UIKit

class SettingViewController: UITableViewController {

    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        setupNavigationBackground()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBackground()
    }
    
}

extension SettingViewController {
    func setupNavigationBackground() {
        guard let navBar = self.navigationController?.navigationBar else {
            return
        }
        self.setupNavigationAppearance(navBar: navBar)
    }
}
