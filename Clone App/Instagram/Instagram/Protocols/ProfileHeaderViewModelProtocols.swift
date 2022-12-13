//
//  ProfileHeaderViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/13.
//

import UIKit
import Combine

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader)
}


protocol ProfileHeaderViewModelGetSetType {
    
    var user: UserInfoModel { get set }
    
    var profileImage: UIImage? { get set }
    
    var userStats: Userstats? { get set }
}


struct ProfileHeaderViewModelInput {
    
    let user: AnyPublisher<UserInfoModel,Never>
    let profileImage: AnyPublisher<UIImage,Never>
    let userStats: AnyPublisher<Userstats,Never>
    
}


typealias ProfileHeaderViewModelOutput = AnyPublisher<ProfileHeaderState,ProfileHeaderErrorType>
                                                        
enum ProfileHeaderState {
    case none,
         configureUserInfoUI,
         configureProfile(UIImage),
         configureFollowUI((followers: Int,following: Int))
         
}

enum ProfileHeaderErrorType: Error {
    case fail

    var errorDescription: String {
        switch self {
        case .fail:
            return "none"
        }
    }

}

protocol ProfileHeaderViewModelType: ProfileHeaderViewModelGetSetType {
    
    func transform(input: ProfileHeaderViewModelInput)
}
