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
    private var filteredUsers = [UserInfoModel]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchMode: Bool {
        get {
            guard let searchedText = searchController.searchBar.text else {
                return false
            }
            return searchController.isActive && !searchedText.isEmpty
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}


//MARK: - Helpers
extension SearchController {
    
    func configure() {
        configureSearchController()
        configureTableView()
    }
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(SearchedUserCell.self, forCellReuseIdentifier: REUSE_SEARCH_TABLE_CELL_IDENTIFIER)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

//MARK: - API
extension SearchController {
    
    func fetchAllUser() async {
        do {
            try await fetchAllUserDefaultInfo()
        }catch {
            fetchAllUserErrorHandling(withError: error)
        }
    }
    
    func fetchAllUserDefaultInfo() async throws {
        guard let users = try await UserService.fetchUserList() else { throw FetchUserError.invalidUsers }
        DispatchQueue.main.async {
            self.userVM = SearchUserViewModel(users: users)
        }
    }
    
    func fetchAllUserErrorHandling(withError error: Error) {
        switch error {
        case FetchUserError.invalidUsers:
            print("DEBUG: Failure get invalid users instance")
        case FetchUserError.invalidUserData:
            print("DEBUG: Failure get invalid user data")
        case FetchUserError.invalidDocuemnts:
            print("DEBUG: Failure get invalid firestore's documents")
        default:
            print("DEBUG: Failure unexcepted error occured : \(error.localizedDescription)")
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
        //return isSearchMode ? filteredUsers.count : userVM.numberOfRowsInSection(section)

        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_SEARCH_TABLE_CELL_IDENTIFIER, for: indexPath) as? SearchedUserCell else {
            fatalError("Fail to find reusableCell in SearchController")
        }
        guard let userVM = userVM else { fatalError() }
        cell.userVM = isSearchMode ? UserInfoViewModel(user: filteredUsers[indexPath.row]) : userVM.cellForRowAt(indexPath.row)
        
        DispatchQueue.global().async {
            cell.userVM?.fetchUserStats() {}
        }
        Task() {
            await cell.userVM?.fetchImage()
            DispatchQueue.main.async {
                cell.configureImage()
            }
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SEARCHED_USER_CELL_PROFILE_WIDTH + SEARCHED_USER_CELL_PROFILE_MARGIN*2 + 1
    }
}

//MARK: - TableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchedUserCell else {fatalError("DEBUG: Fail to fild reusableCell in SearchController")}
        guard let user = cell.userVM else { return }
        let vc = ProfileController(user: user.userInfoModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Adopt SearchResultsUpdating Protocol
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else  { return }
        guard let users = userVM?.getUserInfoModel() else { return }
        
        filteredUsers = users.filter {
            $0.username.contains(text) ||
            $0.fullname.contains(text)}
        tableView.reloadData()
    }
}
