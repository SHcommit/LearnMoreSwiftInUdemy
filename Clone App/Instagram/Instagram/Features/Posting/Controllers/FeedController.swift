//
//  FeedController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine
import Firebase

class FeedController: UICollectionViewController, FeedViewModelConvenience {
    
    //MARK: - Properties
    weak var coordinator: FeedFlowCoordinator?
    internal var subscriptions = Set<AnyCancellable>()
    fileprivate var initData = PassthroughSubject<Void,Never>()
    fileprivate var appear = PassthroughSubject<Void,Never>()
    fileprivate var refresh = PassthroughSubject<Void,Never>()
    fileprivate var logout = PassthroughSubject<Void,Never>()
    fileprivate var cancelAndPopVC = PassthroughSubject<Void,Never>()
    fileprivate var initCell = PassthroughSubject<Int,Never>()
    fileprivate var loginUser: UserModel
    internal var vm: FeedViewModelType
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - LifeCycle
    init(user: UserModel, apiClient: ServiceProviderType, vm: FeedViewModelType,_ collectionViewLayout: UICollectionViewFlowLayout) {
        self.vm = vm
        self.apiClient = apiClient
        self.loginUser = user
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FEEDCELLRESUIDENTIFIER)
        setupBindings()
        initData.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send()
    }
    
}

extension FeedController {
    
    fileprivate func setupBindings() {
        let input = FeedViewModelInput(
            initData: initData.eraseToAnyPublisher(),
            appear: appear.eraseToAnyPublisher(),
            refresh: refresh.eraseToAnyPublisher(),
            logout: logout.eraseToAnyPublisher(),
            initCell: initCell.eraseToAnyPublisher())
        let output = vm.transform(with: input).receive(on: RunLoop.main)
        output
            .receive(on: RunLoop.main)
            .sink { _ in
            print("DEBUG: FeedController binding deallocated.")
        } receiveValue: {
            self.render($0)
        }.store(in: &subscriptions)
    }
    
    fileprivate func render(_ state: State) {
        switch state {
        case .appear:
            setupUI()
            break
        case .reloadData:
            if isRunningIndicator() { endIndicator() }
            guard let refresh = collectionView.refreshControl else {
                return
            }
            if refresh.isRefreshing {
                collectionView.refreshControl?.endRefreshing()
            }
            collectionView.reloadData()
            break
        case .endIndicator:
            endIndicator()
            break
        case .showLogin:
            do {
                try Auth.auth().signOut()
                Utils.pList.removeObject(forKey: CURRENT_USER_UID)
                DispatchQueue.main.async {
                    self.coordinator?.gotoLoginPage()
                }
            } catch {
                print("Failed to sign out")
            }
            break
        case .none:
            break
        }
    }
    
}

//MARK: - Helpers
extension FeedController {
    
    func setupUI() {
        setupNavigationUI()
        setupRefreshUI()
        view.backgroundColor = .white
    }
    
    func setupNavigationUI() {
        if coordinator?.parentCoordinator is MainFlowCoordinator {
            // 탭의 근본 피드는 로그아웃, 이후 subcoordinator navi에 의해 push된 경우 back bar button.
            setupLogoutBarButton()
        }
        navigationItem.title = "Feed"
    }
    
    func setupRefreshUI() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresh
    }
    
    func setupCell(_ cell: FeedCell, index: Int, post: PostModel?) {
        
        if vm.isEmptyPost {
            if vm.count == 0 {
                return
            }
            cell.viewModel = FeedCellViewModel(post: vm.posts[index], loginUser: loginUser, apiClient: apiClient)
        } else {
            cell.viewModel = FeedCellViewModel(post: post!, loginUser: loginUser, apiClient: apiClient)
        }
        cell.coordinator = coordinator
        cell.delegate = self
        cell.configure()
        cell.setupBinding()
    }
}

//MARK: - Event handler
extension FeedController {
    
    @objc func handleLogout() {
        logout.send()
    }
    
    @objc func handleRefresh() {
        refresh.send()
    }
    
    @objc func cancel() {
        cancelAndPopVC.send()
    }
}

//MARK: - UICollectionView DataSource
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FEEDCELLRESUIDENTIFIER, for: indexPath) as? FeedCell else {
            fatalError()
        }
        setupCell(cell,index: indexPath.row, post: vm.getPost)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = view.frame.width
        var cellHeight = cellWidth + 8 + 40 + 8
        
        cellHeight += 50
        cellHeight += 60
        
        return CGSize(width: view.frame.width, height: cellHeight)
    }
    
 }


//MARK: - UINavigationController configure
extension FeedController {
    
    func setupLogoutBarButton() {
        guard let _ = navigationItem.leftBarButtonItem else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(handleLogout))
            return
        }
        
    }
    
    func setupPrevBarButton() {
        let back = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = back
    }
    
}

extension FeedController: FeedCellDelegate {
    func wantsToShowIndicator() {
        startIndicator()
    }
    
    func wantsToHideIndicator() {
        endIndicator()
    }
    
    
}
