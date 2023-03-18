//
//  NotificationFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class NotificationFlowCoordinator: NSObject, FlowCoordinator {
  
  //MARK: - Constants
  typealias NotificationFC = NotificationFlowCoordinator
  
  //MARK: - Properties
  internal var parentCoordinator: FlowCoordinator?
  internal var childCoordinators = [FlowCoordinator]()
  internal var presenter: UINavigationController
  internal var notificationController: NotificationController!
  internal var user: UserModel
  internal var vm: NotificationViewModelType
  fileprivate let apiClient: ServiceProviderType
  
  //MARK: - Lifecycles
  init(apiClient: ServiceProviderType, user: UserModel, presenter: UINavigationController? = nil) {
    self.apiClient = apiClient
    self.user = user
    self.vm = NotificationsViewModel(apiClient: apiClient)
    self.presenter = presenter ?? UINavigationController()
    notificationController = NotificationController(vm: vm, user: user, apiClient: apiClient)
  }
  
  //MARK: - Action
  func start() {
    notificationController.coordinator = self
    if NotificationFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
      self.presenter = Utils.templateNavigationController(
        unselectedImage: .imageLiteral(name: "like_unselected"),
        selectedImage: .imageLiteral(name: "like_selected"),
        rootVC: notificationController)
      presenter.delegate = self
      return
    }
    presenter.pushViewController(notificationController, animated: true)
  }
  
  func finish() {
    if parentCoordinator is MainFlowCoordinator {
      removeAllChild()
      return
    }
    parentCoordinator?.removeChild(target: self)
  }
  
  deinit {
    print("DEBUG: parentCoordinator: \(parentCoordinator.debugDescription)'s child notificationFlowCoordinator deallocate.")
  }
  
}


//MARK: - Setup child coordinator and holding :)
extension NotificationFlowCoordinator {
  
  internal func gotoProfilePage(with specificUser: UserModel) {
    let child = ProfileFlowCoordinator(apiClient: apiClient, target: specificUser, presenter: presenter)
    holdChildByAdding(coordinator: child)
  }
  
  internal func gotoDetailPostFeedPage(with post: PostModel) {
    //이경우 로그인이 아니라 특정 사용자.
    let child = FeedFlowCoordinator(
      apiClient: apiClient, login: user,specificPostOwner: post, presenter: presenter)
    holdChildByAdding(coordinator: child)
  }
  
}

//MARK: - Manage childCoordinators :]
extension NotificationFlowCoordinator: UINavigationControllerDelegate {
  
  func navigationController(_ nav: UINavigationController, didShow viewC: UIViewController, animated: Bool) {
    updateDismissedViewControllerChildCoordinatorFromNaviController(
      nav, didShow: viewC) { vc in
        notificationFlowChildCoordinatorManager(target: vc)
      }
  }
  
}

//MARK: - UINavigationControllerDelegate Manager
extension NotificationFlowCoordinator {
  
  fileprivate func notificationFlowChildCoordinatorManager(target vc: UIViewController) {
    switch vc {
    case is ProfileController:
      UtilsChildState.poppedChildFlow(coordinator: .profile(vc))
      break
    case is FeedController:
      UtilsChildState.poppedChildFlow(coordinator: .feed(vc))
      break
    case is CommentController:
      UtilsChildState.poppedChildFlow(coordinator: .comment(vc))
      break
    default:
      print("DEBUG: Unknown ViewController occured transition event in notification Flow Coordinator's NavigaitonController")
      break
    }
  }
  
}
