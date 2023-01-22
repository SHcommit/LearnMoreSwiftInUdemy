//
//  FlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

protocol FlowCoordinator: AnyObject {
    //MARK: - Computed Properties
    var parentCoordinator: FlowCoordinator? { get set }
    var childCoordinators: [FlowCoordinator] { get set }
    var presenter: UINavigationController { get set }
    
    //MARK: - Action
    func start()
    func finish()
}


//MARK: - Manage child coordinator
extension FlowCoordinator {
    
    func addChild(target coordinator: FlowCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(target coordinator: FlowCoordinator) {
        guard let idx = childCoordinators.firstIndex(where: {$0===coordinator}) else {
            print("DEBUG: Couldn't find target: \(coordinator) in childCoordinators")
            return
        }
        childCoordinators.remove(at: idx)
    }
    
    func removeAllChild() {
        childCoordinators.removeAll()
    }
    
    func updateDismissedViewControllerChildCoordinatorFromNaviController(_ navi: UINavigationController, didShow vc: UIViewController, castForCheck: (UIViewController) -> Void) {
        guard let targetVC = navi.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navi.viewControllers.contains(targetVC) { return }
        castForCheck(targetVC)
    }
    
}


/// Test
extension FlowCoordinator {
    
    typealias TestUINaviC = UINavigationController
    
    func testCheckCoordinatorState() {
        print("DEBUG: Test! check subCoordinator state ---")
        print("DEBUG: target's subcoordinator list:\(childCoordinators)")
        print("DEBUG: target's parentCoordinator's subcoordinator list: \(parentCoordinator?.childCoordinators)")

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
        print("DEBUG: Success deinitialize child's coordinator.")
    }
    
}

