//
//  CommentFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class CommentFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: CommentViewModelType
    var commentController: CommentController!
    let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, vm: CommentViewModelType, apiClient: ServiceProviderType) {
        self.presenter = presenter
        self.vm = vm
        self.apiClient = apiClient
        self.commentController = CommentController(viewModel: vm, apiClient: apiClient)
        
    }
    
    //MARK: - Action
    func start() {
        testCheckCoordinatorState()
        commentController.coordinator = self
        presenter.pushViewController(commentController, animated: true)
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}
