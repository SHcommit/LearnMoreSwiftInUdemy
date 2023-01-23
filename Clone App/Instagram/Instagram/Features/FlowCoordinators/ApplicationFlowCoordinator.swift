//
//  InstagramFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit
import Combine

class ApplicationFlowCoordinator: FlowCoordinator{
    
    //MARK: - Properties
    internal var parentCoordinator: FlowCoordinator?
    internal var presenter: UINavigationController
    internal var childCoordinators: [FlowCoordinator] = []
    
    ///로그인 한 유저
    @Published var me: UserModel!
    fileprivate let fetchLoginOwnerInfoFailed = PassthroughSubject<Void,Never>()
    fileprivate var fetchFailedLoginOwnerSubscription: AnyCancellable?
    fileprivate var cancellable: AnyCancellable?
    fileprivate let window: UIWindow
    fileprivate let apiClient: ServiceProvider = ServiceProvider.defaultProvider()
    fileprivate var isLoggedIn: Bool {
        return checkUserInfoInUserDefaults()
    }
    
    //MARK: - Lifecycles
    init(window: UIWindow) {
        presenter = UINavigationController()
        self.window = window
    }

    func start() {
        setupBindings()
        checkUserIsLoginAndCallChildCoordinators()
        setupUserInfo()
        parentCoordinator = self
    }
    
    func finish() {
        print("DEBUG: Instagram application closed.")
    }
    
}

//MARK: - Helpers
extension ApplicationFlowCoordinator {
    
    fileprivate func checkUserIsLoginAndCallChildCoordinators() {
        guard isLoggedIn else {
            loginCoordinatorSubscription()
            return
        }
        cancellable = $me
            .receive(on: RunLoop.main)
            .sink { _ in
                print("DEBUG: log out")
            } receiveValue: { user in
                guard let user = user else {
                    print("초기 세팅. 안됨.")
                    return
                }
                self.mainCoordinatorSubscription(with: user)
            }
    }
    
    fileprivate func checkUserInfoInUserDefaults() -> Bool {
        guard let _=Utils.pList.string(forKey: CURRENT_USER_UID),
            let _=FSConstants.user else {
            return false
        }
        return true
    }
    
    fileprivate func setupBindings() {
        fetchFailedLoginOwnerSubscription = fetchLoginOwnerInfoFailed
            .subscribe(on: RunLoop.main)
            .sink {
                self.setupUserInfo()
            }
    }
    
}

//MARK: - Setup child coordinator subscription
extension ApplicationFlowCoordinator {

    //MARK: - MainHomeTabCoordinator
    fileprivate func mainCoordinatorSubscription(with me: UserModel) {
        let child = MainFlowCoordinator(me: me, apiClient: apiClient)
        UtilsCoordinator.setupChild(detail: child) {
            $0.parentCoordinator = self
            self.addChild(target: $0)
            self.window.rootViewController = nil
            self.window.rootViewController = $0.rootViewController
            $0.start()
        }
    }
    
    //MARK: - AuthenticationCoordinator
    fileprivate func loginCoordinatorSubscription() {
        let child = LoginFlowCoordinator(apiClient: apiClient)
        UtilsCoordinator.setupChild(detail: child) {
            $0.parentCoordinator = self
            self.addChild(target: $0)
            self.window.rootViewController = child.presenter
            $0.start()
        }
    }
    
}

//MARK: - Setup child coordinator and holding :]
extension ApplicationFlowCoordinator {
    
    internal func gotoLoginPage(withDelete child: MainFlowCoordinator) {
        loginCoordinatorSubscription()
        child.finish()
    }
    
    
    internal func gotoFeedPage(withDelete child: LoginFlowCoordinator) {
        me = nil
        cancellable = nil
        setupUserInfo()
        cancellable = $me
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] loginOwner in
                guard let loginOwner = loginOwner else {
                    self.fetchLoginOwnerInfoFailed.send()
                    return
                }
                child.finish()
                mainCoordinatorSubscription(with: loginOwner)
            }
    }
}

//MARK: - APIs
extension ApplicationFlowCoordinator {
    fileprivate func setupUserInfo() {
        Task(priority: .high) {
            guard let user = try? await apiClient.userCase.fetchCurrentUserInfo(type: UserModel.self) else {
                return
            }
            self.me = user
        }
    }
}
