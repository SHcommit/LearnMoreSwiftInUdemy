//
//  NotificationFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class NotificationFlowCoordinator: FlowCoordinator {
    
    typealias NotificationFC = NotificationFlowCoordinator
    
    //MARK: - Properties
    internal var parentCoordinator: FlowCoordinator?
    internal var childCoordinators = [FlowCoordinator]()
    internal var presenter: UINavigationController
    internal var vm: NotificationViewModelType
    internal var notificationController: NotificationController!
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType, presenter: UINavigationController? = nil) {
        self.apiClient = apiClient
        self.vm = NotificationsViewModel(apiClient: apiClient)
        self.presenter = presenter ?? UINavigationController()
        notificationController = NotificationController(vm: vm, apiClient: apiClient)
    }
    
    //MARK: - Action
    func start() {
        notificationController.coordinator = self
        if NotificationFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
            self.presenter = Utils.templateNavigationController(
                unselectedImage: .imageLiteral(name: "like_unselected"),
                selectedImage: .imageLiteral(name: "like_selected"),
                rootVC: notificationController)
            return
        }
        //Main Flow가 아닌 타 coordinator에서 호출된 경우
        presenter.pushViewController(notificationController, animated: true)
    }
    
    func finish() {
        if parentCoordinator is MainFlowCoordinator {
            removeAllChild()
            return
        }
        parentCoordinator?.removeChild(target: self)
    }
    
}
