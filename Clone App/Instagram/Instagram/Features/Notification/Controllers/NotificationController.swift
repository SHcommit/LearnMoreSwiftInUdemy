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
    
    //MARK: - Properties
    fileprivate let appear = PassthroughSubject<Void,Never>()
    fileprivate var specificCellInit = PassthroughSubject<(cell: NotificationCell, index: Int),Never>()
    var vm: NotificationsViewModelType = NotificationsViewModel()
    fileprivate var subscriptions = Set<AnyCancellable>()
    var delegateSubscription = Set<AnyCancellable>()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
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
        return 80
    }
    
}

//MARK: - UITableViewDelegate
extension NotificationController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = vm.notifications[indexPath.row].specificUserInfo.uid
        Task(priority: .medium) {
            guard let user = try? await UserService
                .fetchUserInfo(type: UserInfoModel.self, withUid: uid) else {
                print("DEBUG: Failure get user info")
                return
            }
            let controller = ProfileController(viewModel: ProfileViewModel(user: user))
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
}

//MARK: - Helpers
extension NotificationController {
    
    func setupBindings() {
        let input = NotificationsViewModelInput(appear: appear.eraseToAnyPublisher(), specificCellInit: specificCellInit.eraseToAnyPublisher())
        
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
    
    private func render(_ state: NotificationsControllerState) {
        switch state {
        case .none:
            break
        case .updateTableView:
            tableView.reloadData()
            break
        case .viewWillAppear:
            _=delegateSubscription.map{$0.cancel()}
            _=subscriptions.map{$0.cancel()}
            setupBindings()
        }
    }
    
}

//MARK: - Notification cell's delegate
extension NotificationController {
    func setupNotificationCellDelegate(_ cell: NotificationCell) {
        cell.delegate.receive()
            .sink { _ in
                print("complete")
            } receiveValue:  { element in
                switch element.type {
                case .wantsToUnfollow:
                    Task(priority: .high) {
                        do{
                            try await UserService.unfollow(someone: element.uid)
                            DispatchQueue.main.async {
                                element.cell.vm?.userIsFollowed = false
                                element.cell.updateFollowButtonUI()
                            }
                        } catch {
                            print("DEBUG: \(error.localizedDescription)")
                        }
                    }
                    break
                case .wantsToFollow:
                    Task(priority: .high) {
                        do {
                            try await UserService.follow(someone: element.uid)
                            DispatchQueue.main.async {
                                element.cell.vm?.userIsFollowed = true
                                element.cell.updateFollowButtonUI()
                            }
                        }catch {
                            print("DEBUG: \(error.localizedDescription)")
                        }
                    }
                    break
                case .wantsToViewPost:
                    Task(priority: .high) {
                        do {
                            let post = try await PostService.fetchPost(withPostId: element.uid)
                            DispatchQueue.main.async {
                                let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
                                controller.post = post
                                controller.post?.postId = element.uid
                                controller.setupPrevBarButton()
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        } catch {
                            print("DEBUG: \(error.localizedDescription)")
                        }
                    }
                    break
                }
            }.store(in: &delegateSubscription)
    }
}

//MARK: - Config
extension NotificationController {
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notificaitons"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCellReusableId)
        tableView.separatorStyle = .none
    }
}

