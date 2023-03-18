//
//  Extensions.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//
import UIKit

//MARK: - Custom indicator

enum IndicatorState {
  case start
  case end
}

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
    if view.subviews.contains(where: {$0==_indicator}) {
      return _indicator
    }
    view.addSubview(_indicator)
    return _indicator
  }
  
  func startIndicator() {
    setupIndicatorConstraints()
    self.view.isUserInteractionEnabled = false
    DispatchQueue.main.async {
      self.view.bringSubviewToFront(self.indicator)
      self.indicator.isHidden = false
      self.indicator.startAnimating()
    }
  }
  
  func isRunningIndicator() ->Bool {
    return indicator.isAnimating
  }
  
  func endIndicator() {
    self.view.isUserInteractionEnabled = true
    DispatchQueue.main.async {
      self.indicator.isHidden = true
      self.indicator.stopAnimating()
    }
  }
  
  fileprivate func setupIndicatorConstraints() {
    UtilsUI.setupConstraints(with: indicator) {
      [$0.centerX.constraint(equalTo: view.centerX),
       $0.centerY.constraint(equalTo: view.centerY, constant: -40),
       $0.width.constraint(equalToConstant: 88),
       $0.height.constraint(equalToConstant: 88)]
    }
    
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
  
  func encodeToNSDictionary(info: Codable) -> [String:Any]
  
}

extension ServiceExtensionType {
  
  func encodeToNSDictionary(info: Codable) -> [String : Any] {
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


//MARK: - RootNavigationController+
extension Utils {
  
  static func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootVC: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootVC)
    nav.tabBarItem.image = unselectedImage
    nav.tabBarItem.selectedImage = selectedImage
    nav.navigationBar.tintColor = .black
    setupNavigationAppearance(nav: nav)
    return nav
  }
  
  static func setupNavigationAppearance(nav: UINavigationController) {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    nav.navigationBar.standardAppearance = appearance
    nav.navigationBar.scrollEdgeAppearance = appearance
  }
  
}
