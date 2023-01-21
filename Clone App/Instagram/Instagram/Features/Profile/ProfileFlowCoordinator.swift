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
    fileprivate var user: UserInfoModel
    
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType, target user: UserInfoModel, presenter: UINavigationController? = nil) {
        self.apiClient = apiClient
        self.user = user
        self.presenter = presenter ?? UINavigationController()
        self.vm = ProfileViewModel(user: user, apiClient: apiClient)
        self.profileController = ProfileController(viewModel: vm)
    }
    
    //MARK: - Action
    func start() {
        profileController.coordinator = self
        //mainFlow냐?! 아니면 다른 sub Coordinator에서 호출한거야?!
        if ProfileFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
            self.presenter = Utils.templateNavigationController(
                unselectedImage: .imageLiteral(name: "profile_unselected")
                , selectedImage: .imageLiteral(name: "profile_selected"),
                rootVC: profileController)
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
    
}

//MARK: - Setup child coordinator and holding :)
extension ProfileFlowCoordinator {
    
    
}

//MARK: - Manage childCoordinators :]
extension ProfileFlowCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let notifiedVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(notifiedVC) {
            return
        }
        profileFlowChildCoordinatorManager(target: notifiedVC)
    }
    
    
    //MARK: - UINavigationControllerDelegate Manager
    func profileFlowChildCoordinatorManager(target vc: UIViewController) {
//        switch vc {
//        case is ProfileController:
//            popProfileChildCoordinator(vc)
//            break
//        case is CommentController:
//            popCommentChildCoordinator(vc)
//            break
//        default:
//            print("DEBUG: Unknown ViewController occured transition event in Feed Flow Coordinator's NavigaitonController")
//            break
//        }
    }
//
//    func popProfileChildCoordinator(_ vc : UIViewController) {
//        guard let profileVC = vc as? ProfileController,
//              let child = profileVC.coordinator else {
//            return
//        }
//        child.finish()
//        vc.dismiss(animated: true)
//    }
//
//
//    func popCommentChildCoordinator(_ vc: UIViewController) {
//        guard let commentVC = vc as? CommentController,
//              let child = commentVC.coordinator else {
//            return
//        }
//        child.finish()
//        vc.dismiss(animated: true)
//    }
}
