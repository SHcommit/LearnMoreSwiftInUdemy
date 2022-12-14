//
//  Extensions.swift
//  GoodWeather
//
//  Created by μμΉν on 2022/09/09.
//

import UIKit

extension UIViewController {
    func setupNavigationAppearance(navBar: UINavigationBar) {
        navBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        appearance.backgroundColor = .orange
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
    }
    
}
