//
//  ImageSelectorFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class ImageSelectorFlowCoordinator: FlowCoordinator{
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var imageSelectorController: ImageSelectorController!
    
    //MARK: - Lifecycles
    init() {
        imageSelectorController = ImageSelectorController()
        presenter = Utils.templateNavigationController(
            unselectedImage: .imageLiteral(name: "plus_unselected")
            , selectedImage: .imageLiteral(name: "plus_unselected"),
            rootVC: imageSelectorController)

    }
    
    //MARK: - Action
    func start() {
        imageSelectorController.coordinator = self
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}
