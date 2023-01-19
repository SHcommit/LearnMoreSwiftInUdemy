//
//  FeedFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit


class FeedFlowCoordinator: FlowCoordinator {
    typealias flowLayout = UICollectionViewFlowLayout
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var feedController: FeedController!
    
    //MARK: - Lifecycles
    init() {
        feedController = FeedController(collectionViewLayout: flowLayout())
        presenter = Utils.templateNavigationController(
            unselectedImage: .imageLiteral(name: "home_unselected"),
            selectedImage: .imageLiteral(name: "home_selected"),
            rootVC: feedController)
    }
    
    //MARK: - Action
    func start() {
        feedController.coordinator = self
        
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}
