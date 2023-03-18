//
//  FlowCoordinatorUtils.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

//MARK: - Utils
extension FlowCoordinator {
  
  static func isMainFlowCoordiantorChild(parent: FlowCoordinator?) -> Bool {
    guard let parent = parent else {
      print("DEBUG: parent's info is nil")
      return false
    }
    if parent is MainFlowCoordinator {
      return true
    }
    return false
  }
  
  // holding + child's coordinator start
  func holdChildByAdding<Element>(coordinator: Element) where Element: FlowCoordinator {
    UtilsCoordinator.setupChild(detail: coordinator) {
      self.addChild(target: $0)
      $0.parentCoordinator = self
      $0.start()
    }
  }
  
}


//MARK: - Test
extension FlowCoordinator {
  
  typealias TestUINaviC = UINavigationController
  
  func testCheckCoordinatorState() {
    print("DEBUG: Test! check subCoordinator state ---")
    print("DEBUG: target's subcoordinator list:\(childCoordinators)")
    print("DEBUG: target's parentCoordinator's subcoordinator list: \(parentCoordinator?.childCoordinators.debugDescription ?? "[ ]")")
    
  }
  
  /// Test UINavigationControllerDelegate didShow func
  /// castingLogic을 통해 특정 case에 캐스팅되는 VC일때 성공적으로 child.finish()실행하고 결과 나오는지 확인.
  func testNavigationController(_ navi: TestUINaviC, didShow vc: UIViewController, animated: Bool, castingLogic: (UIViewController)->Void) {
    print("DEBUG: Start navi's didShow event")
    guard let targetVC = navi.transitionCoordinator?.viewController(forKey: .from) else {
      print("DEBUG: Fail to completion child coordinator from navi's didShow func")
      return
    }
    if navi.viewControllers.contains(targetVC) {
      print("DEBUG: Fail to completion child coordinator from navi's didShow func. targetVC is Running.")
      return
    }
    print("DEBUG: Check targetVC. pop from navi stack. From now on downcast targetVC and update specific type's coordinator state. ")
    castingLogic(targetVC)
    ///만약 castingLogic에서 default DEBUG가 안뜨면 success.
    print("DEBUG: Success deinitialize child's coordinator.")
  }
  
}


//MARK: - Update child coordinator from popped view controller by executed presenter.

typealias UtilsChildState = UpdateChildCoordinatorState<UIViewController>

enum UpdateChildCoordinatorState<T> where T: UIViewController {
  
  case profile(T)
  case comment(T)
  case feed(T)
  case search(T)
  case register(T)
  
  var updateState: Void {
    switch self {
    case .comment(let targetVC):
      updateChildCommentCoordinatorFromPoppedVC(targetVC)
      return
    case .feed(let targetVC):
      updateChildFeedCoordinatorFromPoppedVC(targetVC)
      return
    case .profile(let targetVC):
      updateChildProfileFlowFromPoppedVC(targetVC)
      return
    case .search(let targetVC):
      updateChildSearchCoordinatorFromPoppedVC(targetVC)
      return
    case .register(let targetVC):
      updateChildRegistrationFlowFromPoppedVC(targetVC)
    }
  }
  
  static func poppedChildFlow(coordinator type: UpdateChildCoordinatorState) {
    type.updateState
  }
  
}

//MARK: - UpdateChildCoordinatorState Helpers
extension UpdateChildCoordinatorState {
  
  fileprivate func updateChildProfileFlowFromPoppedVC(_ vc: UIViewController) {
    guard let profileVC = vc as? ProfileController,
          let child = profileVC.coordinator else {
      return
    }
    child.finish()
  }
  
  fileprivate func updateChildCommentCoordinatorFromPoppedVC(_ vc: UIViewController) {
    guard let commentVC = vc as? CommentController,
          let child = commentVC.coordinator else {
      return
    }
    child.finish()
  }
  
  fileprivate func updateChildFeedCoordinatorFromPoppedVC(_ vc: UIViewController) {
    guard let feedVC = vc as? FeedController,
          let child = feedVC.coordinator else {
      return
    }
    child.finish()
  }
  
  fileprivate func updateChildSearchCoordinatorFromPoppedVC(_ vc: UIViewController) {
    guard let feedVC = vc as? SearchController,
          let child = feedVC.coordinator else {
      return
    }
    child.finish()
  }
  
  fileprivate func updateChildRegistrationFlowFromPoppedVC(_ vc: UIViewController) {
    guard let registrationVC = vc as? RegistrationController,
          let child = registrationVC.coordinator else {
      return
    }
    child.finish()
  }
  
}


struct UtilsCoordinator {
  
  static func setupChild<T>(detail target : T, apply: @escaping (T)->Void) where T: FlowCoordinator {
    apply(target)
  }
  
  static func setupVC<T>(detail target: T, apply: @escaping (T)->Void) where T: UIViewController {
    apply(target)
  }
  
}

