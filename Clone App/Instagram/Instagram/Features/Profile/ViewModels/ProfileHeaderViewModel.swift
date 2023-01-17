//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/05.
//

import UIKit
import Combine
import FirebaseFirestore

final class ProfileHeaderViewModel {
    
    //MARK: - Properties
    @Published private var _user: UserInfoModel
    @Published private var _profileImage : UIImage?
    @Published private var _userStats: Userstats?
    
    //MARK: - LifeCycle
    init(user: UserInfoModel, profileImage: UIImage? = nil, userStats: Userstats? = nil) {
        _user = user
        _userStats = userStats
        _profileImage = profileImage
    }
    
}

//MARK: - ProfileHeaderViewModelType
extension ProfileHeaderViewModel: ProfileHeaderViewModelType {
    
    func transform() -> ProfileHeaderViewModelOutput {
        let user = userChains()
        let userStats = userStatsChains()
        let profileImage = profileImageChains()
        
        return Publishers
            .Merge3(user.eraseToAnyPublisher(),
                                 userStats.eraseToAnyPublisher(),
                                 profileImage.eraseToAnyPublisher())
            .eraseToAnyPublisher()
    }
    
}

//MARK: - ProfileHeaderViewModelInnerPublisherChainType
extension ProfileHeaderViewModel: ProfileHeaderVMInnerPublisherChainType {
    
    func userChains() -> ProfileHeaderViewModelOutput {
        return $_user
            .receive(on: RunLoop.main)
            .setFailureType(to: ProfileHeaderErrorType.self)
            .tryMap { _ -> ProfileHeaderState in
                return .configureUserInfoUI
            }.mapError { error -> ProfileHeaderErrorType in
                return error as? ProfileHeaderErrorType ?? .fail
            }.eraseToAnyPublisher()
    }
    
    func profileImageChains() -> ProfileHeaderViewModelOutput {
        return $_userStats
            .receive(on: RunLoop.main)
            .setFailureType(to: ProfileHeaderErrorType.self)
            .tryMap { _ -> ProfileHeaderState in
                return .configureFollowUI
            }.mapError { error in
                return error as? ProfileHeaderErrorType ?? .fail
            }.eraseToAnyPublisher()

    }
    
    func userStatsChains() -> ProfileHeaderViewModelOutput {
        return $_profileImage
            .receive(on: RunLoop.main)
            .setFailureType(to: ProfileHeaderErrorType.self)
            .tryMap { _ -> ProfileHeaderState in
                return .configureProfile
            }.mapError { error -> ProfileHeaderErrorType in
                return error as? ProfileHeaderErrorType ?? .fail
            }.eraseToAnyPublisher()
    }
    
}

//MARK: - ProfileHeaderViweModelComputedProperty
extension ProfileHeaderViewModel: ProfileHeaderViewModelComputedProperty {
    
    var user: UserInfoModel {
        get {
            return _user
        }
        set {
            _user = newValue
        }
    }
    
    var profileImage: UIImage? {
        get {
            return _profileImage
        }
        set {
            _profileImage = newValue
        }
    }
    
    var userStats: Userstats? {
        get  {
            return _userStats
        }
        set {
            _userStats = newValue
        }
    }
    
    var profileURL: String {
        get {
            user.profileURL
        }
        set {
            user.profileURL = newValue
        }
    }
    
    var userName: String {
        get {
            user.username
        }
        set {
            user.username = newValue
        }
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: userStats?.followers ?? 0, label: "followers")
    }
    
    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: userStats?.following ?? 0, label: "following")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: 5, label: "posts")
    }

}

//MARK: - Helpers
extension ProfileHeaderViewModel {
    
    func followButtonText() -> String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    func followButtonBackgroundColor() -> UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    func followButtonTextColor() -> UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n" ,attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
}
