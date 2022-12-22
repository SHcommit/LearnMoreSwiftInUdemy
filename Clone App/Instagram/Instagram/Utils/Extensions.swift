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
    
    func startIndicator(indicator: UIActivityIndicatorView) {
        
        setupIndicatorConstraints(indicator: indicator)
        
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(indicator)
            indicator.isHidden = false
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


//MARK: - Codable extensions
extension Encodable {
    var encodeToDictionary: [String:Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
    }
}


//MARK: - About UIImage
extension UIImage {
    static func imageLiteral(name: String) -> UIImage {
        return UIImage(imageLiteralResourceName: name)
    }
    
}

class Dynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(callback: @escaping Listener) {
        listener = callback
    }
    
    init(_ value: T) {
        self.value = value
    }
    
}

protocol ServiceExtensionType {
    
    static func encodeToNSDictionary(info: Codable) -> [String:Any]
    
}

extension ServiceExtensionType {
    
    static func encodeToNSDictionary(info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
    
}

struct Utils {
    static var pList: UserDefaults {
        get {
            let pList = UserDefaults.standard
            pList.synchronize()
            return pList
        }
    }
}
