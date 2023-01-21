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

struct ConfigCoordinator {
    
    static func setupChild<T>(detail target : T, apply: @escaping (T)->Void) where T: FlowCoordinator {
        apply(target)
    }
    
    static func setupVC<T>(detail target: T, apply: @escaping (T)->Void) where T: UIViewController {
        apply(target)
    }
    
}
