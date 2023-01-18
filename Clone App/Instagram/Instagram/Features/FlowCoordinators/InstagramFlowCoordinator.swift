//
//  InstagramFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class InstagramFlowCoordinator: NSObject {
    
    //MARK: - Properties
    fileprivate let window: UIWindow
    fileprivate var rootviewController: UINavigationController!
    fileprivate var _children: [FlowCoordinator] = []
    
    fileprivate let apiClient: ServiceProvider = ServiceProvider.defaultProvider()
    
    fileprivate var isLoggedIn: Bool {
        guard let _=Utils.pList.string(forKey: CURRENT_USER_UID) else {
            return false
        }
        return true
    }
    
    //여기서 앱 런칭때 userModel 가져와야함
    
    
    //MARK: - Lifecycles
    init(window: UIWindow) {
        self.window = window
        configRootViewController()
    }
}

//MARK: - FlowCoordinator
extension InstagramFlowCoordinator: FlowCoordinator {
    
    var children: [FlowCoordinator] {
        get {
            _children
        }
        set {
            _children = newValue
        }
    }
    
    var presenter: UINavigationController {
        get {
            rootviewController
        }
        set {
            rootviewController = newValue
        }
    }
    
    func start() {
        guard !isLoggedIn else {
            //로그인커디네이터 스타또 ㄱㄱ
        }
        //홈뷰커디네이터 -> 피드커디네이터로 로 고고링
    }
    
    func finish() {
        <#code#>
    }
    
    
}

//MARK: - Helpers
extension InstagramFlowCoordinator {
    fileprivate func configRootViewController() {
        rootviewController = UINavigationController()
    }
    
    fileprivate func showLogin() {
        
    }
    
    fileprivate func showFeed() {
        
    }
}
