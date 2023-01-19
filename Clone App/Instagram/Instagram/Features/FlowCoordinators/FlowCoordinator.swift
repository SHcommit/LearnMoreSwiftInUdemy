//
//  FlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

protocol FlowCoordinator: AnyObject {
    //MARK: - Computed Properties
    var parentCoordinator: FlowCoordinator? { get set }
    var childCoordinators: [FlowCoordinator] { get set }
    var presenter: UINavigationController { get set }
    
    //MARK: - Action
    func start()
    func finish()
}


//MARK: - Manage child coordinator
extension FlowCoordinator {
    
    func addChild(target coordinator: FlowCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(target coordinator: FlowCoordinator) {
        guard let idx = childCoordinators.firstIndex(where: {$0===coordinator}) else {
            print("DEBUG: Couldn't find target: \(coordinator) in childCoordinators")
            return
        }
        childCoordinators.remove(at: idx)
    }
    
    func removeAllChild() {
        childCoordinators.removeAll()
    }
    
}
