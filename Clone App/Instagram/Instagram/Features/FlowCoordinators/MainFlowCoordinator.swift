//
//  MainFLowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/20.
//

import UIKit

class MainFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    internal var parentCoordinator: FlowCoordinator?
    internal var childCoordinators: [FlowCoordinator] = []
    var presenter: UINavigationController
    var rootViewController: MainHomeTabController
    fileprivate var apiClient: ServiceProviderType
    fileprivate var me: UserInfoModel
    
    //MARK: - LifeCycles
    init(me: UserInfoModel, apiClient: ServiceProviderType) {
        self.apiClient = apiClient
        self.me = me
        presenter = UINavigationController()
        let vm = MainHomeTabViewModel(apiClient: apiClient)
        self.rootViewController = MainHomeTabController(vm: vm)
    }
    
    //MARK: - Action
    func start() {
        rootViewController.coordinator = self
        parentCoordinator = self
        feedCoordinatorSubscription()
        searchCoordinatorSubscription()
        imageSelectorCoordinatorSubscription()
        notificationCoordinatorSubscription()
        profileCoordinatorSubscription()
        rootViewController
            .viewControllers = childCoordinators.map{$0.presenter}
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}

//MARK: - Setup child coordinator and holding :]
extension MainFlowCoordinator {
    typealias flowLayout = UICollectionViewFlowLayout
    
    ///초기 tamplete로 네비 설정할 때 각 FlowCoordinator init시점에 navi를 추가해버리면 이게 내비 추가할 때 mainFlow에 의한 것이면
    /// 템플릿 네비init를 사용하는 건데 그게 아닌 subCoordinator에서 호출 할 경우 parent의 navi를 받아야한다.
    /// init시점에 하면 presenter가 mainFlow인지검사하는 구간이 init 다음에 있어서 parentCoordinator 무조건 nil 뜬다
    fileprivate func feedCoordinatorSubscription() {
        
        let child = FeedFlowCoordinator(apiClient: apiClient, login: me)
        holdChildByAdding(coordinator: child)
    }
    
    fileprivate func searchCoordinatorSubscription() {
        let child = SearchFlowCoordinator(apiClient: apiClient)
        holdChildByAdding(coordinator: child)
    }
    
    fileprivate func imageSelectorCoordinatorSubscription() {
        let child = ImageSelectorFlowCoordinator()
        holdChildByAdding(coordinator: child)
    }
    
    fileprivate func notificationCoordinatorSubscription() {
        let child = NotificationFlowCoordinator(apiClient: apiClient, user: me)
        holdChildByAdding(coordinator: child)
    }
    
    fileprivate func profileCoordinatorSubscription() {
        let child = ProfileFlowCoordinator(apiClient: apiClient, target: me)
        holdChildByAdding(coordinator: child)
    }
}

