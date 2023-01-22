//
//  FlowCoordinatorUtils.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

//MARK: - Utils
extension FlowCoordinator {
    
    static func isMainFlowCoordiantorChild(parent: FlowCoordinator?) -> Bool {
        guard let parent = parent else {
            print("DEBUG: parent's info is nil")
            return false
        }
        if parent is MainFlowCoordinator {
            return true
        }
        return false
    }
    
    // holding + child's coordinator start
    func holdChildByAdding<Element>(coordinator: Element) where Element: FlowCoordinator {
        ConfigCoordinator.setupChild(detail: coordinator) {
            self.addChild(target: $0)
            $0.parentCoordinator = self
            $0.start()
        }
    }
    
}

//MARK: - Update child coordinator from popped view controller by executed presenter.

typealias UtilChildState = UpdateChildCoordinatorState<UIViewController>

enum UpdateChildCoordinatorState<T> where T: UIViewController {
    
    case profile(T)
    case comment(T)
    case feed(T)
    case search(T)
    
    //추후 구현해야함.
    //case uploadPost(T)
    //case login(T)
    //case register(T)
    //case notification(T)
    //case imageSelector(T)
    
    var updateState: Void {
        switch self {
        case .comment(let targetVC):
            updateChildCommentCoordinatorFromPoppedVC(targetVC)
            return
        case .feed(let targetVC):
            updateChildFeedCoordinatorFromPoppedVC(targetVC)
            return
        case .profile(let targetVC):
            updateChildProfileFlowFromPoppedVC(targetVC)
            return
        case .search(let targetVC):
            updateChildSearchCoordinatorFromPoppedVC(targetVC)
            return
        }
    }
    
    static func poppedChildFlow(coordinator type: UpdateChildCoordinatorState) {
        type.updateState
    }
    
}

//MARK: - UpdateChildCoordinatorState Helpers
extension UpdateChildCoordinatorState {
    
    fileprivate func updateChildProfileFlowFromPoppedVC(_ vc: UIViewController) {
        guard let profileVC = vc as? ProfileController,
              let child = profileVC.coordinator else {
            return
        }
        child.finish()
    }
    
    fileprivate func updateChildCommentCoordinatorFromPoppedVC(_ vc: UIViewController) {
        guard let commentVC = vc as? CommentController,
              let child = commentVC.coordinator else {
            return
        }
        child.finish()
    }
    
    fileprivate func updateChildFeedCoordinatorFromPoppedVC(_ vc: UIViewController) {
        guard let feedVC = vc as? FeedController,
              let child = feedVC.coordinator else {
            return
        }
        child.finish()
    }
    
    fileprivate func updateChildSearchCoordinatorFromPoppedVC(_ vc: UIViewController) {
        guard let feedVC = vc as? SearchController,
              let child = feedVC.coordinator else {
            return
        }
        child.finish()
    }
    
}


struct ConfigCoordinator {
    
    static func setupChild<T>(detail target : T, apply: @escaping (T)->Void) where T: FlowCoordinator {
        apply(target)
    }
    
    static func setupVC<T>(detail target: T, apply: @escaping (T)->Void) where T: UIViewController {
        apply(target)
    }
    
}

