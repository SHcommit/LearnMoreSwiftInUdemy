//
//  ProfileFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class ProfileFlowCoordinator: NSObject, FlowCoordinator {
    
    //MARK: - Constants
    typealias ProfileFC = ProfileFlowCoordinator
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: ProfileViewModelType
    var profileController: ProfileController!
    
    fileprivate let apiClient: ServiceProviderType
    fileprivate var user: UserModel
    
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType, target user: UserModel, presenter: UINavigationController? = nil) {
        self.apiClient = apiClient
        self.user = user
        self.presenter = presenter ?? UINavigationController()
        self.vm = ProfileViewModel(user: user, apiClient: apiClient)
        self.profileController = ProfileController(viewModel: vm)
    }
    
    //MARK: - Action
    func start() {
        profileController.coordinator = self
        if ProfileFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
            self.presenter = Utils.templateNavigationController(
                unselectedImage: .imageLiteral(name: "profile_unselected")
                , selectedImage: .imageLiteral(name: "profile_selected"),
                rootVC: profileController)
            presenter.delegate = self
            return
        }
        
        presenter.pushViewController(profileController, animated: true)
    }
    
    func finish() {
        if parentCoordinator is MainFlowCoordinator {
            removeAllChild()
            return
        }
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
    deinit {
        print("DEBUG: parentCoordinator: \(parentCoordinator.debugDescription)'s child profileFlowCoordinator deallocate.")
    }
    
}

//MARK: - Setup child coordinator and holding :)
extension ProfileFlowCoordinator {
    
    internal func gotoSpecificUserDetailFeedPage(postOwner: PostModel) {
        let child = FeedFlowCoordinator(apiClient: apiClient, login: user,specificPostOwner: postOwner,presenter: presenter)
        holdChildByAdding(coordinator: child)
    }
    
}

//MARK: - UINavigationControllerDelegate :]
extension ProfileFlowCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navi: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        updateDismissedViewControllerChildCoordinatorFromNaviController(
            navi, didShow: viewController) { vc in
                profileFlowChildCoordinatorManager(target: vc)
            }
    }

}

//MARK: - UINavigationControllerDelegate Manager
extension ProfileFlowCoordinator {
    fileprivate func profileFlowChildCoordinatorManager(target vc: UIViewController) {
        switch vc {
        case is ProfileController:
            UtilsChildState.poppedChildFlow(coordinator: .profile(vc))
            break
        case is CommentController:
            UtilsChildState.poppedChildFlow(coordinator: .comment(vc))
            break
        case is FeedController:
            UtilsChildState.poppedChildFlow(coordinator: .feed(vc))
            break
        default:
            print("DEBUG: Unknown ViewController occured transition event in profile Flow Coordinator's NavigaitonController")
            break
        }
    }
}
