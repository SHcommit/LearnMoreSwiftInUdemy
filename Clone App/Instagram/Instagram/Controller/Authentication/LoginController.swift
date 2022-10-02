//
//  LoginController.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/02.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


//MARK: - Helpers
extension LoginController {
    func setupUI() {
        setupNavigationBar()
        setupViewBackground()
    }
}


//MARK: - Setup Navigation
extension LoginController {
    func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupNavigationBar() {
        setupNavigationAppearance()
        navigationController?.navigationBar.isHidden = true
    }
}

//MARK: - Setup ViewController UI
extension LoginController {
    func setupViewBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        
        let gradientColors: [CGColor] = [.init(red: 1.0, green: 0.98, blue: 0.84, alpha: 1),
                                         .init(red: 1.00, green: 0.76, blue: 0.44, alpha: 1.00),
                                         .init(red: 1.00, green: 0.37, blue: 0.43, alpha: 1.00)]
        
        gradient.colors = gradientColors
        view.layer.addSublayer(gradient)
    }
}
