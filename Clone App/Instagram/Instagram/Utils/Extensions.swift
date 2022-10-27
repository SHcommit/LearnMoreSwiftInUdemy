//
//  Extensions.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//
import UIKit

extension UIViewController {
    func setupViewGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        
        let gradientColors: [CGColor] = [
                .init(red: 1.00, green: 0.37, blue: 0.43, alpha: 1.00),
                .init(red: 1.00, green: 0.75, blue: 0.46, alpha: 1.00),
                .init(red: 1.00, green: 0.76, blue: 0.44, alpha: 1.00)]
        
        gradient.colors = gradientColors
        view.layer.addSublayer(gradient)
    }
    
    func presentLoginScene() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
    
    func startIndicator(indicator: UIActivityIndicatorView) {
        
        setupIndicatorConstraints(indicator: indicator)
        
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(indicator)
            indicator.startAnimating()
        }
    }
    
    func endIndicator(indicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            indicator.isHidden = true
            indicator.stopAnimating()
        }
    }
    
    func setupIndicatorConstraints(indicator: UIActivityIndicatorView) {
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
}
