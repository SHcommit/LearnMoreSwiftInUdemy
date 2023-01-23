//
//  UploadFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class UploadFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    let selectedImg: UIImage?
    let loginOwner: UserModel
    let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, loginOwner: UserModel, selectedImg: UIImage?, apiClient: ServiceProviderType) {
        self.selectedImg = selectedImg
        self.presenter = presenter
        self.loginOwner = loginOwner
        self.apiClient = apiClient
    }
    
    //MARK: - Action
    func start() {
        let vc = UploadPostController(apiClient: apiClient)
        vc.coordinator = self
        vc.selectedImage = selectedImg
        vc.currentUserInfo = loginOwner
        presenter.pushViewController(vc, animated: true)
    }
    
    func finish() {
        print("aaaa")
//        presenter.popViewController(animated: true)
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
        guard let imageFlow = parentCoordinator as? ImageSelectorFlowCoordinator else {
            return
        }
        print("aaaaa")
        imageFlow.gotoFeedPage()
            
    }
    
}
