//
//  UploadFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class UploadFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    //MARK: - Action
    func start() {
        <#code#>
    }
    
    func finish() {
        <#code#>
    }
    
}
