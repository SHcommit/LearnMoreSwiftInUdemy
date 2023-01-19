//
//  InstagramFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class InstagramFlowCoordinator: FlowCoordinator{
    
    //MARK: - Properties
    fileprivate let window: UIWindow
    fileprivate var presenter: UINavigationController!
    fileprivate var rootViewController = UITabBarController()
    fileprivate var childCoordinators: [FlowCoordinator] = []
    
    fileprivate let apiClient: ServiceProvider = ServiceProvider.defaultProvider()
    
    fileprivate var isLoggedIn: Bool {
        checkUserInfoInUserDefaults()
    }
    
    //여기서 앱 런칭때 userModel 가져와야함 이건 홈뷰면 홈뷰한테 시키라해아함.
    
    
    //MARK: - Lifecycles
    init(window: UIWindow) {
        self.window = window
        _presenter = UINavigationController()
    }

    func start() {
        window.rootViewController = rootViewController
        let emptyVC = UIViewController()
        emptyVC.view.backgroundColor = .systemPink
        rootViewController.setViewControllers([emptyVC], animated: true)
        rootViewController.tabBar.backgroundColor = .brown
        //checkUserIsLoginAndCallChildCoordinator()
    }
    
    func finish() {
        print("DEBUG: Instagram application closed.")
    }
    
    
}

//MARK: - setup child coordinator
extension InstagramFlowCoordinator {
    
    fileprivate func showLogin() {
        
    }
    
    fileprivate func showFeed() {
        
    }
}

//얘는 각각의 하위 에서 달아야하겠다..
//extension InstagramFlowCoordinator: UINavigationControllerDelegate, NSObject {
//    func navigationController(_ naviController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//
//        guard let loadStateChangedVC = naviController
//            .transitionCoordinator?.viewController(forKey: .from) else{
//            return
//        }
//        if naviController.viewControllers.contains(loadStateChangedVC) {
//            return
//        }
//        coordinatorStateManager(loadStateChangedVC)
//    }
//
//    /// Manage parent coordinator of vc freed from memory
//    fileprivate func coordinatorStateManager(_ vc: UIViewController) {
//        switch vc {
//        case is FeedController:
//            break
//        default:
//            break
//        }
//    }
//
//}

//MARK: - Helpers
extension InstagramFlowCoordinator {
    
    fileprivate func checkUserIsLoginAndCallChildCoordinator() {
        guard isLoggedIn else {
            //로그인커디네이터 스타또 ㄱㄱ
            return
        }
        //홈뷰커디네이터 -> 피드커디네이터로 로 고고링
        
    }
    
//    func isLoginConfigure() async {
//        guard let isLogin = isLogin else { return }
//        if !isLogin {
//            DispatchQueue.main.async {
//                self.presentLoginScene()
//            }
//        }else {
//            guard let _ = userVM else {
//                await fetchCurrentUserInfo()
//                return
//            }
//        }
//    }
    
    fileprivate func checkUserInfoInUserDefaults() -> Bool {
        ///파이어베이스의 Auth.auth.currentUser는 믿으면 안됨. 갱신이 느려
        //이거 확인해야함. 로그인하고나서
        guard let _=Utils.pList.string(forKey: CURRENT_USER_UID),
            let _=FSConstants.user else {
            return false
        }
        return true
    }
    
}
