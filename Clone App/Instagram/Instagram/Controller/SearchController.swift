//
//  SearchController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class SearchController: UITableViewController {
    
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
}

//MARK: - setupNavigation UI
extension SearchController {
    
    func setupNavigationBar() {
        let searchBar = UISearchController()
        navigationItem.searchController = searchBar
    }
}


//MARK: - Helpers
extension SearchController {
    
    func configure() {
        configureTableView()
        setupNavigationBar()
    }
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(SearchedUserCell.self, forCellReuseIdentifier: REUSE_SEARCH_TABLE_CELL_IDENTIFIER)
    }
}

//MARK: - TableView DataSource
extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_SEARCH_TABLE_CELL_IDENTIFIER, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SEARCHED_USER_CELL_PROFILE_WIDTH + SEARCHED_USER_CELL_PROFILE_MARGIN*2 + 1
    }
}
