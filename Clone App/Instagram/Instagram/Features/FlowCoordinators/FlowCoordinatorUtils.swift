//
//  FlowCoordinatorUtils.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

struct ConfigCoordinator {
    
    static func setupChild<T>(detail target : T, apply: @escaping (T)->Void) where T: FlowCoordinator {
        apply(target)
    }
    
    static func setupVC<T>(detail target: T, apply: @escaping (T)->Void) where T: UIViewController {
        apply(target)
    }
    
}
