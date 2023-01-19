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
    
    fileprivate func feedCoordinatorSubscription() {
        let child = FeedFlowCoordinator()
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
        let child = NotificationFlowCoordinator(apiClient: apiClient)
        holdChildByAdding(coordinator: child)
    }
    
    fileprivate func profileCoordinatorSubscription() {
        let child = ProfileFlowCoordinator(apiClient: apiClient, login: me)
        holdChildByAdding(coordinator: child)
    }
}

//MARK: - Utils
extension MainFlowCoordinator {
    func holdChildByAdding<Element>(coordinator: Element) where Element: FlowCoordinator {
        ConfigCoordinator.setupChild(detail: coordinator) {
            self.addChild(target: $0)
            $0.parentCoordinator = self
            $0.start()
        }
    }
}
