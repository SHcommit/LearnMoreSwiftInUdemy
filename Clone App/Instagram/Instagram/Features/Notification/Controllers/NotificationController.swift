//
//  NotificationController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine

class NotificationController: UITableViewController {
    
    //MARK: - Constants
    fileprivate let NotificationCellReusableId = "NotificationCell"
    fileprivate let cellHeight = CGFloat(80)
    
    //MARK: - Properties
    fileprivate let refresher = UIRefreshControl()
    fileprivate let appear = PassthroughSubject<Void,Never>()
    fileprivate var specificCellInit = PassthroughSubject<(cell: NotificationCell, index: Int),Never>()
    fileprivate var refresh = PassthroughSubject<Void,Never>()
    fileprivate var vm: NotificationViewModelType
    fileprivate var subscriptions = Set<AnyCancellable>()
    fileprivate var delegateSubscription = Set<AnyCancellable>()
    fileprivate var user: UserModel
    weak var coordinator: NotificationFlowCoordinator?
    
    //MARK: - Usecase
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(vm: NotificationViewModelType ,user: UserModel,apiClient: ServiceProviderType) {
        self.vm = vm
        self.apiClient = apiClient
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefresher()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appear.send()
    }
}

//MARK: - UITableViewDataSource
extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _=delegateSubscription.map{$0.cancel()}
        return vm.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCellReusableId, for: indexPath) as! NotificationCell
        specificCellInit.send((cell,indexPath.row))
        setupNotificationCellDelegate(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}

//MARK: - UITableViewDelegate
extension NotificationController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startIndicator()
        let uid = vm.notifications[indexPath.row].specificUserInfo.uid
        Task(priority: .medium) {
            guard let user = try? await apiClient.userCase
                .fetchUserInfo(type: UserModel.self, withUid: uid) else {
                print("DEBUG: Failure get user info")
                endIndicator()
                return
            }
            let controller = ProfileController(viewModel: ProfileViewModel(user: user, apiClient: ServiceProvider.defaultProvider()))
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
                self.endIndicator()
            }
        }
    }
    
}

//MARK: - Actions
extension NotificationController {
    @objc func handleRefresh() {
        vm.notifications.removeAll()
        refresh.send()
    }
}

//MARK: - Helpers
extension NotificationController {
    
    func setupBindings() {
        let input = NotificationViewModelInput(appear: appear.eraseToAnyPublisher(), specificCellInit: specificCellInit.eraseToAnyPublisher(),
            refresh: refresh.eraseToAnyPublisher())
        
        let output = vm.transform(with: input)
        output.sink { completion in
            switch completion {
            case .finished:
                print("DEBUG: NotificationsController subscription completion.")
            case.failure(_): break
            }
        } receiveValue: {
            self.render($0)
        }.store(in: &subscriptions)
    }
    
    fileprivate func render(_ state: NotificationControllerState) {
        switch state {
        case .none:
            break
        case .updateTableView:
            tableView.reloadData()
            break
        case .appear:
            setupDefaultNotificationControllerBindings()
        case .refresh :
            setupDefaultNotificationControllerBindings()
            refresher.endRefreshing()
        }
    }
    
    func setupDefaultNotificationControllerBindings() {
        _=delegateSubscription.map{$0.cancel()}
        _=subscriptions.map{$0.cancel()}
        setupBindings()
    }
    
}

//MARK: - Notification cell's delegate
extension NotificationController {
    
    func setupNotificationCellDelegate(_ cell: NotificationCell) {
        cell.delegate.receive()
            .sink {
                print("DEBUG: \($0)")
            } receiveValue:  { [unowned self] element in
                switch element.type {
                case .wantsToUnfollow:
                    wantsToUnfollow(with: element)
                    break
                case .wantsToFollow:
                    wantsToFollow(with: element)
                    break
                case .wantsToViewPost:
                    wantsToViewPost(with: element)
                    break
                }
            }.store(in: &delegateSubscription)
    }
    
    private func wantsToUnfollow(with element: NotificationCellDelegate.Element) {
        startIndicator()
        Task(priority: .high) {
            do{
                try await apiClient.userCase.unfollow(someone: element.uid)
                DispatchQueue.main.async {
                    element.cell.vm?.userIsFollowed = false
                    element.cell.updateFollowButtonUI()
                    self.endIndicator()
                }
            } catch {
                print("DEBUG: \(error.localizedDescription)")
                endIndicator()
            }
        }
    }
    
    private func wantsToFollow(with element: NotificationCellDelegate.Element) {
        startIndicator()
        Task(priority: .high) {
            do {
                try await apiClient.userCase.follow(someone: element.uid)
                DispatchQueue.main.async {
                    element.cell.vm?.userIsFollowed = true
                    element.cell.updateFollowButtonUI()
                    self.endIndicator()
                }
            }catch {
                print("DEBUG: \(error.localizedDescription)")
                endIndicator()
            }
        }
    }
    
    private func wantsToViewPost(with element: NotificationCellDelegate.Element) {
        Task(priority: .high) {
            startIndicator()
            do {
                let post = try await apiClient.postCase.fetchPost(withPostId: element.uid)
                DispatchQueue.main.async { [self] in
                    let vm = FeedViewModel(post: post,apiClient: apiClient)
                    let controller = FeedController(
                        user: user, apiClient: apiClient,
                        vm: vm, UICollectionViewFlowLayout())
                    vm.post?.postId = element.uid
                    controller.setupPrevBarButton()
                    self.endIndicator()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            } catch {
                print("DEBUG: \(error.localizedDescription)")
                endIndicator()
            }
        }
    }
}

//MARK: - Config
extension NotificationController {
    fileprivate func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notificaitons"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCellReusableId)
        tableView.separatorStyle = .none
    }
    
    fileprivate func configureRefresher() {
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
}
