//
//  SearchFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class SearchFlowCoordinator:NSObject, FlowCoordinator {
  
  typealias SearchFC = SearchFlowCoordinator
  
  //MARK: - Properties
  internal var parentCoordinator: FlowCoordinator?
  internal var childCoordinators = [FlowCoordinator]()
  internal var presenter: UINavigationController
  internal var vm: SearchViewModelType
  internal var searchController: SearchController!
  fileprivate var apiClient: ServiceProviderType
  
  //MARK: - Lifecycles
  init(apiClient: ServiceProviderType, presenter: UINavigationController? = nil) {
    self.apiClient = apiClient
    self.vm = SearchViewModel(apiClient: apiClient)
    self.presenter = presenter ?? UINavigationController()
    self.searchController = SearchController(viewModel: vm)
    
  }
  
  //MARK: - Action
  func start() {
    searchController.coordinator = self
    if SearchFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
      presenter = Utils.templateNavigationController(
        unselectedImage: .imageLiteral(name: "search_unselected"),
        selectedImage: .imageLiteral(name: "search_selected"),
        rootVC: searchController)
      presenter.delegate = self
      return
    }
    //아마 현재 구현된 기능에선 SearchController를 재사용 할 일이 없다.( 실행 안됨 Date: 23.01.21)
    presenter.pushViewController(searchController, animated: true)
  }
  
  //이 함수도 안 쓰임. 추후에 Search를 다른 VC에서 부른다면 사용해야함.
  func finish() {
    if parentCoordinator is MainFlowCoordinator {
      removeAllChild()
      return
    }
    parentCoordinator?.removeChild(target: self)
    removeAllChild()
    presenter.popViewController(animated: true)
  }
  
  deinit {
    print("parentCoordinator: \(parentCoordinator)'s child SearchFlow deallocate.")
  }
  
}

//MARK: - Setup child coordinator and holding :)
extension SearchFlowCoordinator {
  
  internal func gotoProfilePage(specific selectedUser: UserModel) {
    let child = ProfileFlowCoordinator(apiClient: apiClient, target: selectedUser, presenter: presenter)
    holdChildByAdding(coordinator: child)
  }
  
}

/// 검색의 경우 특정 프로필틀통해서 대화, 프로필, feed를 갈 수 있다. 이게 무한 반복으로 들어갈 수 있다. 각각의 경우에 대해 처리한다.
//MARK: - UINavigationControllerDelegate
extension SearchFlowCoordinator: UINavigationControllerDelegate {
  func navigationController(_ navi: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    updateDismissedViewControllerChildCoordinatorFromNaviController(
      navi, didShow: viewController) { vc in
        searchFlowChildCoordinatorManager(target: vc)
      }
  }
  
}

//MARK: - UINavigationControllerDelegate Manager
extension SearchFlowCoordinator {
  
  fileprivate func searchFlowChildCoordinatorManager(target vc: UIViewController) {
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
      print("DEBUG: Unknown ViewController occured transition event in Search Flow Coordinator's NavigaitonController")
      break
    }
  }
  
}
