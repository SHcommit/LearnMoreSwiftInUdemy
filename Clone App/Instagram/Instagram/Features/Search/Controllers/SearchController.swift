//
//  SearchController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine

class SearchController: UITableViewController {
    
    //MARK: - Properties
    internal var viewModel: SearchViewModelType!
    //MARK: - SearchViewModelInput
    fileprivate let cellForRowAt = PassthroughSubject<(SearchViewModelInputTableInfo,UISearchController),Never>()
    fileprivate let didSelectRowAt = PassthroughSubject<SearchViewModelInputTableInfo,Never>()
    fileprivate let searchResult = PassthroughSubject<String,Never>()
    fileprivate let appear = PassthroughSubject<Void,Never>()
    fileprivate var subscriptions = Set<AnyCancellable>()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    weak var coordinator: SearchFlowCoordinator?
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appear.send()
    }
    
    init(viewModel: SearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - Bind
extension SearchController {
    
    func setupBindings() {
        let output = viewModel.transform(input: SearchViewModelInput(
            cellForRowAt: cellForRowAt.eraseToAnyPublisher(),
            didSelectRowAt: didSelectRowAt.eraseToAnyPublisher(),
            searchResult: searchResult.eraseToAnyPublisher(),
            appear: appear.eraseToAnyPublisher()))
        output.sink { self.render($0) }.store(in: &subscriptions)
    }
    
    private func render(_ state: SearchControllerState) {
        switch state {
        case .none:
            break
        case .tableViewReload:
            tableView.reloadData()
            break
        case .success(let vc):
            navigationController?.pushViewController(vc, animated: true)
            break
        case .failure:
            break
        }
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

//MARK: - TableView DataSource
extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // origin return 근데 파이버에이스 이미지 자주 파싱받으면 돈내야해서 제한함
//        return viewModel.isSearchMode(withSearch: searchController) ? viewModel.filteredCount() : viewModel.numberOfRowsInSection(section)
        return viewModel.isSearchMode(withSearch: searchController) ? viewModel.filteredCount() : 5
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_SEARCH_TABLE_CELL_IDENTIFIER, for: indexPath) as? SearchedUserCell else {
            fatalError("Fail to find reusableCell in SearchController")
        }
        cellForRowAt.send(((cell,indexPath),searchController))
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
        didSelectRowAt.send((cell,indexPath))
    }
    
}

//MARK: - Adopt SearchResultsUpdating Protocol
extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else  { return }
        searchResult.send(text)
    }
    
}
