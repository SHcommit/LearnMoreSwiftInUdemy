//
//  FeedController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine
import Firebase

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    weak var coordinator: FeedFlowCoordinator?
    internal var subscriptions = Set<AnyCancellable>()
    fileprivate var initData = PassthroughSubject<Void,Never>()
    fileprivate var appear = PassthroughSubject<Void,Never>()
    fileprivate var refresh = PassthroughSubject<Void,Never>()
    fileprivate var logout = PassthroughSubject<Void,Never>()
    fileprivate var cancelAndPopVC = PassthroughSubject<Void,Never>()
    fileprivate var initCell = PassthroughSubject<Int,Never>()
    fileprivate var loginUser: UserInfoModel
    internal var vm: FeedViewModelType
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - LifeCycle
    init(user: UserInfoModel, apiClient: ServiceProviderType, vm: FeedViewModelType,_ collectionViewLayout: UICollectionViewFlowLayout) {
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
        coordinator?.testCheckCoordinatorState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.finish()
    }
    
}

extension FeedController {
    
    fileprivate func setupBindings() {
        let input = FeedViewModelInput(
            initData: initData.eraseToAnyPublisher(),
            appear: appear.eraseToAnyPublisher(),
            refresh: refresh.eraseToAnyPublisher(),
            logout: logout.eraseToAnyPublisher(),
            cancel: cancelAndPopVC.eraseToAnyPublisher(),
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
    
    fileprivate func render(_ state: FeedControllerState) {
        switch state {
        case .appear:
            setupUI()
            break
        case .reloadData:
            collectionView.reloadData()
            break
        case .endIndicator:
            endIndicator()
            break
        case .callParentCoordinator:
            //이거도 백 코디네이터 ㄱㄱ
            //navigationController?.popViewController(animated: false)
            coordinator?.finish()
            break
        case .callLoginCoordinator:
            do {
                try Auth.auth().signOut()
                DispatchQueue.main.async {
                    //
                    // 여기선 인제 로그인 커디네이터 불러야함.
                    self.presentLoginScene()
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
        setupLogoutBarButton()
        navigationItem.title = "Feed"
    }
    
    func setupRefreshUI() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresh
    }
    
    func presentLoginScene() {
        let controller = LoginController(viewModel: LoginViewModel(apiClient: ServiceProvider.defaultProvider()))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
    
    func setupCell(_ cell: FeedCell, index: Int, post: PostModel?) {
        if vm.isEmptyPost {
            cell.viewModel = FeedCellViewModel(post: vm.posts[index], loginUser: loginUser, apiClient: apiClient)
        } else {
            cell.viewModel = FeedCellViewModel(post: post!, loginUser: loginUser, apiClient: apiClient)
        }
        cell.coordinator = coordinator
        cell.configure()
        cell.setupBinding(with: navigationController)
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
