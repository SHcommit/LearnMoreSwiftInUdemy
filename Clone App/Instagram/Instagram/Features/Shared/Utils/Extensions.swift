//
//  Extensions.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//
import UIKit

//MARK: - Custom indicator
fileprivate var _indicator = {
    let _indicator = UIActivityIndicatorView(style: .large)
    _indicator.translatesAutoresizingMaskIntoConstraints = false
    _indicator.backgroundColor = UIColor(red: 0.87, green: 0.90, blue: 0.91, alpha: 1.00)
    _indicator.hidesWhenStopped = true
    _indicator.layer.cornerRadius = 15
    return _indicator
}()

extension UIViewController {
    fileprivate var indicator: UIActivityIndicatorView {
        get {
            return _indicator
        }
    }

    func startIndicator() {
        view.addSubview(indicator)
        setupIndicatorConstraints()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.indicator)
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        }
    }
    
    func endIndicator() {
        self.view.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
    }
    
    fileprivate func setupIndicatorConstraints() {
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -110),
            indicator.widthAnchor.constraint(equalToConstant: 88),
            indicator.heightAnchor.constraint(equalToConstant: 88)])
    }
    
}

//MARK: - Custom gradient background in Authentication scnene
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

//MARK: - Network service extension
protocol ServiceExtensionType {
    
    static func encodeToNSDictionary(info: Codable) -> [String:Any]
    
}

extension ServiceExtensionType {
    
    static func encodeToNSDictionary(info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
    
}

//MARK: - Utils
struct Utils {
    static var pList: UserDefaults {
        get {
            let pList = UserDefaults.standard
            pList.synchronize()
            return pList
        }
    }
}
