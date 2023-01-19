//
//  NotificationFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class NotificationFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: NotificationViewModelType
    var notificationController: NotificationController!
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
        vm = NotificationsViewModel(apiClient: apiClient)
        notificationController = NotificationController(vm: vm, apiClient: apiClient)
        presenter = Utils.templateNavigationController(
            unselectedImage: .imageLiteral(name: "like_unselected"),
            selectedImage: .imageLiteral(name: "like_selected"),
            rootVC: notificationController)
    }
    
    //MARK: - Action
    func start() {
        notificationController.coordinator = self
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}
