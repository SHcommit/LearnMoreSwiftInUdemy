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
}
