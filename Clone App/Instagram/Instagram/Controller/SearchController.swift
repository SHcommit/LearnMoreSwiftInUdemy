//
//  SearchController.swift
//  Instagram
//
//  Created by μμΉν on 2022/09/30.
//

import UIKit
import Combine

class SearchController: UITableViewController {
    
    //MARK: - Properties
    var viewModel: SearchViewModelType
    //MARK: - SearchViewModelInput
    private let cellForRowAt = PassthroughSubject<(SearchViewModelInputTableInfo,UISearchController),Never>()
    private let didSelectRowAt = PassthroughSubject<SearchViewModelInputTableInfo,Never>()
    private let searchResult = PassthroughSubject<String,Never>()
    private let appear = PassthroughSubject<Void,Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    private let searchController = UISearchController(searchResultsController: nil)
    
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


//MARK: - Bindings
extension SearchController {
    
    func setupBindings() {
        let output = viewModel.transform(input: SearchViewModelInput(
            cellForRowAt: cellForRowAt.eraseToAnyPublisher(),
            didSelectRowAt: didSelectRowAt.eraseToAnyPublisher(),
            searchResult: searchResult.eraseToAnyPublisher(),
            appear: appear.eraseToAnyPublisher()))
        output.sink { self.render($0) }.store(in: &subscriptions)
    }
    
}


//MARK: - Helpers
extension SearchController {

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
        // origin return κ·Όλ° νμ΄λ²μμ΄μ€ μ΄λ―Έμ§ μμ£Ό νμ±λ°μΌλ©΄ λλ΄μΌν΄μ μ νν¨
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
