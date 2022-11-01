//
//  SearchController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class SearchController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
}

//MARK: - setupNavigation UI
extension SearchController {
    
    func setupNavigationBar() {
        let searchBar = UISearchController()
        navigationItem.searchController = searchBar
    }
}
