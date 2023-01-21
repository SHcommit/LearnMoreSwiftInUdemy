//
//  SearchFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class SearchFlowCoordinator: FlowCoordinator {
    
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
