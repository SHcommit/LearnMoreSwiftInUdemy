//
//  NotificationsController+.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit

//MARK: - Helpers
extension NotificationController {
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notificaitons"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCellReusableId)
        tableView.separatorStyle = .none
    }
    
    func setupBindings() {
        let input = NotificationsViewModelInput(viewWillAppear: viewWillAppear.eraseToAnyPublisher(), specificCellInit: specificCellInit.eraseToAnyPublisher())
        
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
