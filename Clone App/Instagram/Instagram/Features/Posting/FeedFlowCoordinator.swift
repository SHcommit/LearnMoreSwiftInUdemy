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
    fileprivate var user: UserModel
    fileprivate var specificPostOwner: PostModel?
    
    //MARK: - Lifecycles
    /// presenter의 경우 MainFlow에 의한 subCoordinator인 경우에만 nil이다.
    /// 그 외의 경우 대화도중 상대방 프로필 누를 때, 검색 후 상대방 프로필 -> Feed 로 갈 수 있다. 이 경우 등은
    /// 무저건 presenter를 할당받고 초기화 시점에 초기화된다.
    /// 초기화 시점에 Utils.templateNavigationController()를 통해 presenter를 초기화 할 경우에
    /// MainFlowCoordinator시점일 때 subCoordinator의 subscription holding 함수에서
    /// holdChildByAdding(coordinator:) 여기서 parent's coordinator == nil이 뜨게 된다.
    /// 그래서 Start에서 초기화를 하는데 무조건 isMainFlowCoordinator's Child 인 경우에만! 네비를 초기화하고 이후엔 이 네비를
    ///     주입받으면서 네비게이션 스택 관리를 하게된다. with parent,child's array
    init(apiClient: ServiceProviderType, login user: UserModel, specificPostOwner: PostModel? = nil, presenter: UINavigationController? = nil) {
        self.apiClient = apiClient
        self.user = user
        
        // MainFlow일 경우에만 nil. 나머지 subCoord는 무저건 init에 대입한다.
        //이건 임시적으로 걸어두는거 start 시점에 체크 후 초기화.
        self.presenter = presenter ?? UINavigationController()
        self.specificPostOwner = specificPostOwner
        let vm = FeedViewModel(post: specificPostOwner,apiClient: apiClient)
        self.feedController = FeedController(
            user: user, apiClient: apiClient,
            vm: vm, UICollectionViewFlowLayout())
    }
    
    //MARK: - Action
    func start() {
        feedController.coordinator = self
        if FeedFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
            self.presenter = Utils.templateNavigationController(
                unselectedImage: .imageLiteral(name: "home_unselected"),
                selectedImage: .imageLiteral(name: "home_selected"),
                rootVC: feedController)
            presenter.delegate = self
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
    }
    
    deinit {
        print("DEBUG: parentCoordinator: \(parentCoordinator.debugDescription)'s child feedFlowCoordinator deallocate.")
    }
    
}

//MARK: - Setup child coordinator and holding :)
extension FeedFlowCoordinator {
    
    internal func gotoProfilePage(with selectedUser: UserModel) {
        let child = ProfileFlowCoordinator(
            apiClient: apiClient, target: selectedUser, presenter: presenter)
        holdChildByAdding(coordinator: child)
    }
    
    internal func gotoCommentPage(with post: PostModel) {
        let vm = CommentViewModel(post: post, apiClient: apiClient)
        let child = CommentFlowCoordinator(
            presenter: presenter, vm: vm, apiClient: apiClient)
        holdChildByAdding(coordinator: child)
    }
    
    internal func gotoLoginPage() {
        if parentCoordinator is MainFlowCoordinator {
            guard let mainFlow = parentCoordinator as? MainFlowCoordinator,
                  let appFlow = mainFlow.rootCoordinator else {
                return
            }
            self.finish()
            appFlow.gotoLoginPage(withDelete: mainFlow)
        }
    }
    
}
/*
    navi의 barbutton item에서 back button을 누를 경우 해당 VC에서 특정 버튼으로 액션 핸들러를 구현한 경우
    직접하는 coordinator할당 해제하는 경우와
    아래의 경우를 사용하는 경우가있다.
    아니면 viewWillDisappear 부분에 coordinator.finish()를 선언해도 되지만 특정 vc에서 다른 vc를 또 호출 할 경우엔 현재 vc가 사라지게 되는 것임으로 최종 vc,,더 이상 이동할 수 없는 경우에만 viewWillDisappear에 선언하는게 좋다.
    navigationController(_:didShow:)의 경우엔 presenter.델리게이트를 self로 선언해야한다.
 */
//MARK: - UINavigationControllerDelegate
extension FeedFlowCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navi: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        updateDismissedViewControllerChildCoordinatorFromNaviController(
            navi, didShow: viewController) { vc in
                feedFlowChildCoordinatorManager(target: vc)
            }
    }

}

//MARK: - UINavigationControllerDelegate Manager
extension FeedFlowCoordinator {
    
    fileprivate func feedFlowChildCoordinatorManager(target vc: UIViewController) {
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
            print("DEBUG: Unknown ViewController occured transition event in Feed Flow Coordinator's NavigaitonController")
            break
        }
    }
    
}
