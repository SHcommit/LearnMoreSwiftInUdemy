//
//  MainFLowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/20.
//

import UIKit

class MainFlowCoordinator: FlowCoordinator {
  
  //MARK: - Properties
  internal var rootCoordinator: ApplicationFlowCoordinator?
  internal var parentCoordinator: FlowCoordinator?
  internal var childCoordinators: [FlowCoordinator] = []
  internal var presenter: UINavigationController
  internal var rootViewController: MainHomeTabController
  fileprivate var apiClient: ServiceProviderType
  fileprivate var me: UserModel
  fileprivate var isImageSelectorAllocated = false
  
  //MARK: - LifeCycles
  init(me: UserModel, apiClient: ServiceProviderType) {
    self.apiClient = apiClient
    self.me = me
    presenter = UINavigationController()
    let vm = MainHomeTabViewModel(apiClient: apiClient)
    self.rootViewController = MainHomeTabController(vm: vm)
  }
  
  //MARK: - Action
  func start() {
    rootViewController.coordinator = self
    rootCoordinator = (parentCoordinator as! ApplicationFlowCoordinator)
    
    //음? 왜 이렇게 했을까,, 일단 원래 parent는 Application인데 아마 MainFlow 인스턴스를 얻어야 하기 위해
    //parent를 자기자신으로 한 것 같다. 그래서 일단 상위 coordinator가 필요해서 rootCoordinator로 값 대입했다..
    parentCoordinator = self
    feedCoordinatorSubscription()
    searchCoordinatorSubscription()
    imageSelectorCoordinatorSubscription()
    notificationCoordinatorSubscription()
    profileCoordinatorSubscription()
    rootViewController
      .viewControllers = childCoordinators.map{$0.presenter}
  }
  
  func finish() {
    parentCoordinator?.removeChild(target: self)
    removeAllChild()
  }
  
}

//MARK: - Setup child coordinator and holding :]
extension MainFlowCoordinator {
  typealias flowLayout = UICollectionViewFlowLayout
  
  ///초기 tamplete로 네비 설정할 때 각 FlowCoordinator init시점에 navi를 추가해버리면 이게 내비 추가할 때 mainFlow에 의한 것이면
  /// 템플릿 네비init를 사용하는 건데 그게 아닌 subCoordinator에서 호출 할 경우 parent의 navi를 받아야한다.
  /// init시점에 하면 presenter가 mainFlow인지검사하는 구간이 init 다음에 있어서 parentCoordinator 무조건 nil 뜬다
  fileprivate func feedCoordinatorSubscription() {
    let child = FeedFlowCoordinator(apiClient: apiClient, login: me)
    holdChildByAdding(coordinator: child)
  }
  
  fileprivate func searchCoordinatorSubscription() {
    let child = SearchFlowCoordinator(apiClient: apiClient)
    holdChildByAdding(coordinator: child)
  }
  
  fileprivate func imageSelectorCoordinatorSubscription() {
    let child = ImageSelectorFlowCoordinator(loginOwner: me, apiClient: apiClient)
    holdChildByAdding(coordinator: child)
  }
  
  fileprivate func notificationCoordinatorSubscription() {
    let child = NotificationFlowCoordinator(apiClient: apiClient, user: me)
    holdChildByAdding(coordinator: child)
  }
  
  fileprivate func profileCoordinatorSubscription() {
    let child = ProfileFlowCoordinator(apiClient: apiClient, target: me)
    holdChildByAdding(coordinator: child)
  }
  
}

//MARK: - Setup sub child coordinator and holding :]
extension MainFlowCoordinator {
  
  func gotoUploadPost() {
    if isImageSelectorAllocated == false {
      isImageSelectorAllocated = true
      return
    }
    guard let child = childCoordinators
      .first(where: {$0 is ImageSelectorFlowCoordinator})
            as? ImageSelectorFlowCoordinator else { return }
    child.imageSelectorController.showPicker()
  }
  
  func gotoFeedPage() {
    rootViewController.selectedIndex = 0
  }
  
}

//MARK: - UploadPostControllerDelegate
extension MainFlowCoordinator: UploadPostControllerDelegate {
  func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
    controller.dismiss(animated: true)
    childCoordinators
      .first(where: {$0 is ImageSelectorFlowCoordinator})?
      .childCoordinators
      .removeAll()
    rootViewController.selectedIndex = 0
    guard let feedFlow = childCoordinators
      .first as? FeedFlowCoordinator else {
      return
    }
    feedFlow.feedController.handleRefresh()
  }
  
}