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
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, vm: CommentViewModelType) {
        self.presenter = presenter
        self.vm = vm
    }
    
    //MARK: - Action
    func start() {
        print("DEBUG: start logic need!")
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}
