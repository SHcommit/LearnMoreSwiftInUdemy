//
//  LoginFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class LoginFlowCoordinator: NSObject, FlowCoordinator {
  
  //MARK: - Properties
  var rootCoordinator: ApplicationFlowCoordinator?
  var parentCoordinator: FlowCoordinator?
  var childCoordinators = [FlowCoordinator]()
  var presenter: UINavigationController
  var loginController: LoginController!
  var vm: LoginViewModelType
  fileprivate let apiClient: ServiceProviderType
  
  //MARK: - Lifecycles
  init(apiClient: ServiceProviderType) {
    presenter = UINavigationController()
    self.apiClient = apiClient
    vm = LoginViewModel(apiClient: apiClient)
    loginController = LoginController(viewModel: vm)
  }
  
  //MARK: - Action
  func start() {
    //로그인의 경우 이 coordinator가 중첩 실행 할 경우 x. 그래서 다이렉트로 AppCoord Instance를 얻기로 했다.
    rootCoordinator = (parentCoordinator as! ApplicationFlowCoordinator)
    loginController.coordinator = self
    presenter.delegate = self
    presenter.viewControllers = [loginController]
  }
  
  func finish() {
    parentCoordinator?.removeChild(target: self)
    removeAllChild()
  }
  
  deinit{ print("DEBUG: loginCoordinator deallocated.") }
  
}

//MARK: - Setup child coordinator and holding :)
extension LoginFlowCoordinator {
  
  internal func gotoRegisterPage() {
    let vm = RegistrationViewModel(apiClient: apiClient)
    let child = RegisterFlowCoordinator(presenter: presenter, vm: vm)
    holdChildByAdding(coordinator: child)
  }
}

//MARK: - UINavigationControllerDelegate
extension LoginFlowCoordinator: UINavigationControllerDelegate {
  func navigationController(_ nav: UINavigationController, didShow viewC: UIViewController, animated: Bool) {
    updateDismissedViewControllerChildCoordinatorFromNaviController(
      nav, didShow: viewC) {
        if $0 is RegistrationController {
          UtilsChildState.poppedChildFlow(coordinator: .register($0))
        }
      }
  }
}
