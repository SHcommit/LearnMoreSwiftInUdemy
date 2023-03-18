//
//  MainTabController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine
import Firebase

class MainHomeTabController: UITabBarController {
  
  //MARK: - Properties
  var vm: MainHomeTabViewModelType
  var appear = PassthroughSubject<Void,Never>()
  var subscriptions = Set<AnyCancellable>()
  weak var coordinator: MainFlowCoordinator?
  
  //MARK: - Lifecycle
  init(vm: MainHomeTabViewModelType) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
    configure()
    view.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
}

//MARK: - Bind
extension MainHomeTabController {
  
  fileprivate func setupBindings() {
    _=subscriptions.map{$0.cancel()}
    subscriptions.removeAll()
    
    let input = MainHomeTabViewModelInput(appear: appear.eraseToAnyPublisher())
    let output = vm.transform(with: input)
    output.sink { _ in
      print("DEBUG: MainHomeTabController's transform complete.")
    } receiveValue: {
      self.render($0)
    }.store(in: &subscriptions)
  }
  
  fileprivate func render(_ state: MainHomeTabControllerState) {
    switch state {
    case .none:
      break
    case .fetchUserInfoIsCompleted:
      break
    }
  }
}

//MARK: - Helpers
extension MainHomeTabController {
  
  func configure() {
    customTabBarUI()
    delegate = self
  }
  
}

//MARK: - Setup tabBar UI
extension MainHomeTabController {
  
  func customTabBarUI() {
    setupTabBarAppearance()
    setupTabBarTintColor()
  }
  
  func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
  }
  
  func setupTabBarTintColor() {
    tabBar.tintColor = .black
  }
  
}

extension MainHomeTabController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    if tabBarController.selectedIndex == 2 {
      coordinator?.gotoUploadPost()
    }
  }
}
