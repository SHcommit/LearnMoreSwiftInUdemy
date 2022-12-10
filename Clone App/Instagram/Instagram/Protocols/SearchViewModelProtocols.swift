//
//  SearchViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/09.
//

import UIKit
import Combine

protocol SearchViewModelType {
    //MARK: - Input/Output
    /// SearchController's input -> viewModel's output
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput
    
    //MARK: - Get/Set
    /// Is searchController activated?
    func isSearchMode(withSearch viewController: UISearchController) -> Bool
    
    /// TableView's numberOfRows
    func numberOfRowsInSection(_ section: Int) -> Int
    
    /// TableView's each cell
    func cellForRowAt(_ index: Int) -> UserInfoViewModel
    
    /// filteredUser's count
    func filteredCount() -> Int
    
    func getUsers() -> [UserInfoModel]
    
}

//MARK: - APIs
protocol SearchViewModelNetworkServiceType {
    
    /// Fetch All User info from firestore. this is SearchController's tableView's each cell data
    func fetchAllUser() async

    func fetchAllUserDefaultInfo() async throws
    
}

//MARK: - API error handling
protocol SearchViewModelNetworkErrorHandlingType {
    
    func fetchAllUserErrorHandling(withError error: Error)
    
}

//MARK: - SearchController's Input type.
/**
 TODO : SearchController's view event.
 
 - Param cellForRowAt : Initialize each cell with data( viewModel.users or viewModel.filteredUsers)
 - Param didSelectRowAt : When tableView's special cell selected
 - Param searchResult : Filtered special user list When user searched other user's name or fullname.
 - Param appear : When SearchController viewWillAppear.
 
 # Notes: #
 1. viewModel 의 input타입은 4개 입니다. viewModel은 SearchViewModelInput에 의한 output 결과를 combine으로 처리했습니다.
 */
typealias SearchViewModelInputTableInfo = (cell: SearchedUserCell, indexPath: IndexPath)
struct SearchViewModelInput {
    
    var cellForRowAt: AnyPublisher<(SearchViewModelInputTableInfo,UISearchController),Never>
    
    var didSelectRowAt: AnyPublisher<SearchViewModelInputTableInfo,Never>
    
    var searchResult: AnyPublisher<String, Never>
    
    var appear: AnyPublisher<Void,Never>
    
}

protocol SearchViewModelInputCase {
    
    typealias tableInfo = (cell: SearchedUserCell, indexPath: IndexPath)
    //MARK: - CellForRowAt case
    /// Update cell's data with SearchViewModelInputTableInfo, UISearchController
    func setupCellForRowAtInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput

    func setupUserViewModelInCell(with tableInfo: tableInfo, _ searchController: UISearchController)
    
    //이거
    //이거
    //요곤 userVM이라고하는 viewModel 거기서 알아서 하라고 바꿔야함
    func fetchUserStats(in cell: SearchedUserCell)
    func fetchUserImage(in cell: SearchedUserCell)
    
    //MARK: - didselectRowAt case
    /// Show special cell's info with didSelectRowAt's SearchViewModelInputTableInfo.
    func setupDidSelectRowAtInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput
    
    //MARK: - SearchResult case
    /// Update viewModel.filteredUser with searchResult's String
    func setupSearchResultInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput
    func delayTextfieldTyping(with input: SearchViewModelInput) -> AnyPublisher<String,Never>
    func filterTypingFormFromUsers(with delayedText: AnyPublisher<String,Never>) -> SearchViewModelOutput
    
    //MARK: - Appear case
    /// Update tableView. ReloadData
    func setupAppearInputBind(with input: SearchViewModelInput) -> SearchViewModelOutput
    
}

//MARK: - SearchViewModel's outputType

/**
 TODO : Update SearchController's view with viewModel's output.
 
 - case none : viewModel's output default result. Not changed view.
 - case success(ProfileController) : Enter cell's detail profileInfo when user didSelectedRow.
 - case tableViewReload : reloadTableView
 - case failure : none.
 
 # Notes: #
 1. 아직 failure은 추가x. 추후 에러 헨들러를 통해 실패 가능 경우에 따른 처리를 할 것임
 */
typealias SearchViewModelOutput = AnyPublisher<SearchControllerState, Never>
enum SearchControllerState: Equatable {
    case none
    case success(ProfileController)
    case tableViewReload
    case failure
    
    static func == (lhs: Self,rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case
            (.none, .none),
            (.success(_), .success(_)),
            (.tableViewReload, .tableViewReload),
            (.failure, .failure):
            return true
        default:
            return false
            
        }
        
    }
}
