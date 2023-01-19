//
//  SearchUserViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/03.
//

import UIKit
import Combine

class SearchViewModel {
    
    //MARK: - Properties
    @Published var users: [UserInfoModel] = [UserInfoModel]()
    @Published var filteredUsers: [UserInfoModel] = [UserInfoModel]()
    internal var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Usecase
    fileprivate let apiClient: ServiceProviderType
    
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
        Task() { await fetchAllUser() }
    }
}


//MARK: - SearchViewModelComputedPropertyCase
extension SearchViewModel: SearchViewModelComputedPropertyCase {
    
    func isSearchMode(withSearch viewController: UISearchController) -> Bool {
        guard let searchedText = viewController.searchBar.text else { return false }
        return viewController.isActive && !searchedText.isEmpty
    }
    
    func numberOfRowsInSection(_ section: Int = 0) -> Int {
        return section == 0 ? users.count : 0
    }
    
    func cellForRowAt(_ index: Int) -> UserInfoViewModel {
        let userVM = UserInfoViewModel(user: users[index], profileImage: nil, apiClient: apiClient)
        return userVM
    }
    
    func filteredCount() -> Int {
        return filteredUsers.count
    }
    
    func getUsers() -> [UserInfoModel] {
        users
    }
    
}

//MARK: - SearchViewModelType
extension SearchViewModel: SearchViewModelType {
    
    //MARK: - Input/Output
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {
        
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        
        let cellForRowAt = setupCellForRowAtInputBind(with: input)
        let didSelectRowAt = setupDidSelectRowAtInputBind(with: input)
        let appear = setupAppearInputBind(with: input)
        let searched = setupSearchResultInputBind(with: input)
        let success: SearchViewModelOutput = Publishers.Merge(searched, didSelectRowAt).eraseToAnyPublisher()
        let tableViewReload: SearchViewModelOutput = Publishers.Merge(success, appear).eraseToAnyPublisher()
        
        return Publishers.Merge(cellForRowAt, tableViewReload).eraseToAnyPublisher()
    }
    
}

//MARK: - SearchViewModelInputCase
extension SearchViewModel: SearchViewModelInputCase {
        
    //MARK: - CellForRowAt case
    func setupCellForRowAtInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput {
        return input
            .cellForRowAt
            .receive(on: RunLoop.main)
            .map { [unowned self] tableInfo, searchController -> SearchControllerState in
                setupUserViewModelInCell(with: tableInfo, searchController)
                fetchUserStats(in: tableInfo.cell)
                fetchUserImage(in: tableInfo.cell)
                return .none
            }.eraseToAnyPublisher()
    }
    
    func setupUserViewModelInCell(with tableInfo: tableInfo, _ searchController: UISearchController) {
        tableInfo.cell.userVM = isSearchMode(withSearch: searchController) ? UserInfoViewModel(user: filteredUsers[tableInfo.indexPath.row], apiClient: apiClient) : cellForRowAt(tableInfo.indexPath.row)
    }
    
    func fetchUserStats(in cell: SearchedUserCell) {
        cell.userVM?.fetchUserStats()
    }
    
    func fetchUserImage(in cell: SearchedUserCell) {
        Task() {
            await cell.userVM?.fetchImage()
            DispatchQueue.main.async {
                cell.configureImage()
            }
        }
    }
    
    //MARK: - DidselectRowAt case
    func setupDidSelectRowAtInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput {
        return input
            .didSelectRowAt
            .receive(on: RunLoop.main)
            .map { tableInfo -> SearchControllerState in
                guard let  user = tableInfo.cell.userVM else { return .failure }
                let vc = ProfileController(viewModel: ProfileViewModel(user: user.userInfoModel(), apiClient: self.apiClient))
                //let vc = ProfileController(user: user.userInfoModel())
                return .success(vc)
            }.eraseToAnyPublisher()
    }
    
    //MARK: - SearchResult case
    func setupSearchResultInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput {
        let delayedText = delayTextfieldTyping(with: input)
        return filterTypingFormFromUsers(with: delayedText)
    }
    
    func delayTextfieldTyping(with input: SearchViewModelInput) -> AnyPublisher<String, Never> {
        return input
            .searchResult
            .debounce(for: .seconds(0.4), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func filterTypingFormFromUsers(with delayedText: AnyPublisher<String,Never>) -> SearchViewModelOutput {
        delayedText
            .map { [unowned self] text -> SearchControllerState in
            let res = users.filter({
                $0.fullname.lowercased().contains(text) ||
                $0.username.lowercased().contains(text)
            })
            filteredUsers.removeAll()
            filteredUsers = res
            return .tableViewReload
        }.eraseToAnyPublisher()
    }
    
    //MARK: - Appear case
    func setupAppearInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput {
        return input
            .appear
            .receive(on: RunLoop.main)
            .map { _ -> SearchControllerState in
                return .tableViewReload
            }.eraseToAnyPublisher()
    }
}

//MARK: - SearchViewModelNetworkServiceType
extension SearchViewModel: SearchViewModelNetworkServiceType {
    
    func fetchAllUser() async {
        do {
            try await fetchAllUserDefaultInfo()
        }catch {
            fetchAllUserErrorHandling(withError: error)
        }
    }
    
    func fetchAllUserDefaultInfo() async throws {
        guard let users = try await apiClient.userCase.fetchUserList(type: UserInfoModel.self) else { throw FetchUserError.invalidUsers }
        DispatchQueue.main.async {
            self.users = users
        }
    }
    
}

//MARK: - SearchViewModelNetworkErrorHandlingType
extension SearchViewModel: SearchViewModelNetworkErrorHandlingType {
    
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

