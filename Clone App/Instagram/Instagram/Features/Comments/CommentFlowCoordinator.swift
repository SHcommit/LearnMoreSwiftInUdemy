//
//  CommentFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class CommentFlowCoordinator:NSObject, FlowCoordinator {
    
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
        commentController.coordinator = self
        presenter.pushViewController(commentController, animated: true)
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
    deinit {
        print("DEBUG: parentCoordinator: \(String(describing: parentCoordinator))'s child comment flow coordinator deallocate.")
    }
    
}

//MARK: - Setup child coordinator and holding :]
extension CommentFlowCoordinator {
    
    internal func gotoProfilePage(with selectedUser: UserModel) {
        let child = ProfileFlowCoordinator(
            apiClient: apiClient, target: selectedUser, presenter: presenter)
        holdChildByAdding(coordinator: child)
        print(child)
    }
    
}

extension CommentFlowCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navi: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("a")
        guard let targetVC = navi.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        print("b")
        if navi.viewControllers.contains(targetVC) { return }
        print("c")
        if targetVC is ProfileController {
            guard let profileVC = targetVC as? ProfileController,
                  let child = profileVC.coordinator else {
                return
            }
            print("d")
            child.finish()
        }
    }
    
}
