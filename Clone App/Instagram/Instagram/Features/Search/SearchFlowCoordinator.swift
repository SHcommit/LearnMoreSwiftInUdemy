//
//  SearchFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class SearchFlowCoordinator: NSObject, FlowCoordinator {
    
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
            return
        }
        //아마 현재 구현된 기능에선 SearchController를 재사용 할 일이 없다.( 실행 안됨 Date: 23.01.21)
        presenter.pushViewController(searchController, animated: true)
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
extension SearchFlowCoordinator {
    
    //이때도 cell의 특정 유저 정보를 받아와야함.
    internal func gotoProfilePage(specific user: UserModel) {
        let child = ProfileFlowCoordinator(apiClient: apiClient, target: user, presenter: presenter)
        holdChildByAdding(coordinator: child)
    }
    
}

//MARK: - Manage childCoordinators :]
extension SearchFlowCoordinator: UINavigationControllerDelegate {
    
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
    
}
