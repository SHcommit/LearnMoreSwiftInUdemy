//
//  ProfileFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class ProfileFlowCoordinator: FlowCoordinator {

    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: ProfileViewModelType
    var profileController: ProfileController!
    fileprivate let apiClient: ServiceProviderType
    
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType, login user: UserInfoModel) {
        self.apiClient = apiClient
        vm = ProfileViewModel(user: user, apiClient: apiClient)
        profileController = ProfileController(viewModel: vm)
        presenter = Utils.templateNavigationController(
            unselectedImage: .imageLiteral(name: "profile_unselected")
            , selectedImage: .imageLiteral(name: "profile_selected"),
            rootVC: profileController)
    }
    
    //MARK: - Action
    func start() {
        profileController.coordinator = self
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}
