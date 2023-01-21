//
//  NotificationFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class NotificationFlowCoordinator: NSObject, FlowCoordinator {
    
    typealias NotificationFC = NotificationFlowCoordinator
    
    //MARK: - Properties
    internal var parentCoordinator: FlowCoordinator?
    internal var childCoordinators = [FlowCoordinator]()
    internal var presenter: UINavigationController
    internal var notificationController: NotificationController!
    internal var user: UserInfoModel
    internal var vm: NotificationViewModelType
    fileprivate let apiClient: ServiceProviderType
    
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType, user: UserInfoModel, presenter: UINavigationController? = nil) {
        self.apiClient = apiClient
        self.user = user
        self.vm = NotificationsViewModel(apiClient: apiClient)
        self.presenter = presenter ?? UINavigationController()
        notificationController = NotificationController(vm: vm, apiClient: apiClient)
    }
    
    //MARK: - Action
    func start() {
        notificationController.coordinator = self
        if NotificationFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
            self.presenter = Utils.templateNavigationController(
                unselectedImage: .imageLiteral(name: "like_unselected"),
                selectedImage: .imageLiteral(name: "like_selected"),
                rootVC: notificationController)
            return
        }
        //Main Flow가 아닌 타 coordinator에서 호출된 경우
        presenter.pushViewController(notificationController, animated: true)
    }
    
    func finish() {
        if parentCoordinator is MainFlowCoordinator {
            removeAllChild()
            return
        }
        parentCoordinator?.removeChild(target: self)
    }
    
}

//MARK: - Setup child coordinator and holding :)
extension NotificationFlowCoordinator {
    
    internal func gotoSpecificUserProfilePage() {
        let child = ProfileFlowCoordinator(apiClient: apiClient, target: user, presenter: presenter)
        holdChildByAdding(coordinator: child)
    }
    
    //이건 feedCell에서 화면 이벤트 전송될 때 post model도 같이 전달해줘야함.
    internal func gotoDetailPostFeedPage(with post: PostModel) {
        let child = CommentFlowCoordinator(presenter: presenter, vm: CommentViewModel(post: post, apiClient: apiClient))
        holdChildByAdding(coordinator: child)
    }
    
}

//MARK: - Manage childCoordinators :]
extension NotificationFlowCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let notifiedVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(notifiedVC) {
            return
        }
        NotificationFlowChildCoordinatorManager(target: notifiedVC)
    }
    
    //MARK: - UINavigationControllerDelegate Manager
    fileprivate func NotificationFlowChildCoordinatorManager(target vc: UIViewController) {
        switch vc {
        case is ProfileController:
            popProfileChildCoordinator(vc)
            break
        case is FeedController:
            popFeedChildCoordinator(vc)
            break
        default:
            print("DEBUG: Unknown ViewController occured transition event in Feed Flow Coordinator's NavigaitonController")
            break
        }
    }
    
    fileprivate func popProfileChildCoordinator(_ vc : UIViewController) {
        guard let profileVC = vc as? ProfileController,
              let child = profileVC.coordinator else {
            return
        }
        child.finish()
        vc.dismiss(animated: true)
    }
    
    fileprivate func popFeedChildCoordinator(_ vc: UIViewController) {
        guard let feedVC = vc as? FeedController,
              let child = feedVC.coordinator else {
            return
        }
        child.finish()
        vc.dismiss(animated: true)
    }
    
}
extension FeedFlowCoordinator {
    func popChildCoordinator<T>(with vc: UIViewController, type: T.Type) where T: UIViewController {
        
    }
}
