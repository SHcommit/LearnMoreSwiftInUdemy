//
//  FeedFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit


class FeedFlowCoordinator: NSObject, FlowCoordinator {
    
    //MARK: - Constants
    typealias flowLayout = UICollectionViewFlowLayout
    typealias FeedFC = FeedFlowCoordinator
    
    //MARK: - Properties
    internal var parentCoordinator: FlowCoordinator?
    internal var childCoordinators = [FlowCoordinator]()
    internal var presenter: UINavigationController
    internal var feedController: FeedController!
    fileprivate let apiClient: ServiceProviderType
    fileprivate var user: UserInfoModel
    
    //MARK: - Lifecycles
    /// presenter의 경우 MainFlow에 의한 subCoordinator인 경우에만 nil이다.
    /// 그 외의 경우 대화도중 상대방 프로필 누를 때, 검색 후 상대방 프로필 -> Feed 로 갈 수 있다. 이 경우 등은
    /// 무저건 presenter를 할당받고 초기화 시점에 초기화된다.
    /// 초기화 시점에 Utils.templateNavigationController()를 통해 presenter를 초기화 할 경우에
    /// MainFlowCoordinator시점일 때 subCoordinator의 subscription holding 함수에서
    /// holdChildByAdding(coordinator:) 여기서 parent's coordinator == nil이 뜨게 된다.
    /// 그래서 Start에서 초기화를 하는데 무조건 isMainFlowCoordinator's Child 인 경우에만! 네비를 초기화하고 이후엔 이 네비를
    ///     주입받으면서 네비게이션 스택 관리를 하게된다. with parent,child's array
    init(apiClient: ServiceProviderType, login user: UserInfoModel, presenter: UINavigationController? = nil) {
        self.apiClient = apiClient
        self.user = user
        // MainFlow일 경우에만 nil. 나머지 subCoord는 무저건 init에 대입0.
        //이건 임시적으로 걸어두는거 start 시점에 체크 후 초기화.
        self.presenter = presenter ?? UINavigationController()
        self.feedController = FeedController(
            user: user, apiClient: apiClient,
            vm: FeedViewModel(apiClient: apiClient), UICollectionViewFlowLayout())
    }
    
    //MARK: - Action
    func start() {
        testCheckCoordinatorState()
        feedController.coordinator = self
        if FeedFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
            self.presenter = Utils.templateNavigationController(
                unselectedImage: .imageLiteral(name: "home_unselected"),
                selectedImage: .imageLiteral(name: "home_selected"),
                rootVC: feedController)
            return
        }
        /// MainFlowCoordinator시점 start가 아닌 경우엔 push.
        presenter.pushViewController(feedController, animated: true)
    }
    
    func finish() {
        //메인일 경우 메인에 추가된 자식꺼 삭제하면 안된다. 탭바이기 때문
        if parentCoordinator is MainFlowCoordinator {
            removeAllChild()
            return
        }
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
        presenter.popViewController(animated: true)
    }
    
}

//MARK: - Setup child coordinator and holding :)
extension FeedFlowCoordinator {
    
    internal func gotoProfilePage() {
        let child = ProfileFlowCoordinator(
            apiClient: apiClient, target: user, presenter: presenter)
        holdChildByAdding(coordinator: child)
    }
    
    //이건 feedCell에서 화면 이벤트 전송될 때 post model도 같이 전달해줘야함.
    internal func gotoCommentPage(with post: PostModel) {
        let vm = CommentViewModel(post: post, apiClient: apiClient)
        let child = CommentFlowCoordinator(
            presenter: presenter, vm: vm, apiClient: apiClient)
        holdChildByAdding(coordinator: child)
    }
    
}

//MARK: - Manage childCoordinators :]
extension FeedFlowCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let notifiedVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(notifiedVC) {
            return
        }
        feedFlowChildCoordinatorManager(target: notifiedVC)
    }
    
    //MARK: - UINavigationControllerDelegate Manager
    fileprivate func feedFlowChildCoordinatorManager(target vc: UIViewController) {
        switch vc {
        case is ProfileController:
            popProfileChildCoordinator(vc)
            break
        case is CommentController:
            popCommentChildCoordinator(vc)
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
    
    fileprivate func popCommentChildCoordinator(_ vc: UIViewController) {
        guard let commentVC = vc as? CommentController,
              let child = commentVC.coordinator else {
            return
        }
        child.finish()
        vc.dismiss(animated: true)
    }
    
}
