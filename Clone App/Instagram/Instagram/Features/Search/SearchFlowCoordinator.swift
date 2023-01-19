//
//  SearchFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class SearchFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: SearchViewModelType
    var searchController: SearchController!
    fileprivate var apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
        vm = SearchViewModel(apiClient: apiClient)
        searchController = SearchController(viewModel: vm)
        presenter = Utils.templateNavigationController(
            unselectedImage: .imageLiteral(name: "search_unselected"),
            selectedImage: .imageLiteral(name: "search_selected"),
            rootVC: searchController)
    
    }
    
    //MARK: - Action
    func start() {
        searchController.coordinator = self
    }
    
    func finish() {
        print("DEBUG: finish logic need!")
    }
    
    
}
