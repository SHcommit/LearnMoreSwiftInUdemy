//
//  SearchController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class SearchController: UITableViewController {
    
    //MARK: - Properties
    private var userVM: SearchUserViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchUserProfileList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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

//MARK: - setupNavigation UI
extension SearchController {
    
    func setupNavigationBar() {
        let searchBar = UISearchController()
        navigationItem.searchController = searchBar
    }
}


//MARK: - API
extension SearchController {
    
    func fetchUserProfileList() {
        UserService.fetchUserList() { users in
            guard let users = users else { return }
            self.userVM = SearchUserViewModel(users: users)
        }
    }
    
}


//MARK: - TableView DataSource
extension SearchController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userVM = userVM else {
            print("Fail to bind userVM in SearchController")
            return 0
        }

        return userVM.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_SEARCH_TABLE_CELL_IDENTIFIER, for: indexPath) as? SearchedUserCell else {
            fatalError("Fail to find reusableCell in SearchController")
        }
        guard let userVM = userVM else { fatalError() }
        let user = userVM.cellForRowAt(indexPath.row).userInfoModel()
        let url = user.profileURL
        cell.userVM = UserInfoViewModel(user: user, profileImage: nil)
        DispatchQueue.main.async {
            UserService.fetchUserProfile(userProfile: url) { image in
                guard let image = image else { return }
                cell.userVM?.initProfileImage(image: image)
                cell.configureImage()
            }
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SEARCHED_USER_CELL_PROFILE_WIDTH + SEARCHED_USER_CELL_PROFILE_MARGIN*2 + 1
    }
}
