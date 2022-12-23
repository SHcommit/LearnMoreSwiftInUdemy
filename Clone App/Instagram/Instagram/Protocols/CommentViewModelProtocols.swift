//
//  CommentControllerInput.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit
import Combine

struct CommentViewModelInput {
    
    let appear: AnyPublisher<Void,Never>
    
    //추후 셀 커스텀하면 그거에맞게 변경
    let cellForItem: AnyPublisher<UICollectionViewCell,Never>    
}

protocol CommentViewModelGetSet {
    
}
