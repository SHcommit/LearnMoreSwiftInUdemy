//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/05.
//

import UIKit
import FirebaseFirestore

class ProfileHeaderViewModel {
    
    //MARK: - Properties
    @Published var user: UserInfoModel
    @Published var profileImage : UIImage?
    @Published var userStats: Userstats?
    
    //MARK: - LifeCycle
    init(user: UserInfoModel, profileImage image: UIImage? = nil, userStats: Userstats? = nil) {
        self.user = user
        self.userStats = userStats
        self.profileImage = profileImage
    }
    
    func initProfileImage(image: UIImage?) {
        profileImage = image
    }
    
}


//MARK: - Get data
extension ProfileHeaderViewModel {
    
    func profileURL() -> String {
        return user.profileURL
    }
    
    func image() -> UIImage? {
        return profileImage
    }
    
    func username() -> String {
        return user.username
    }
    
    func getUserInfo() -> UserInfoModel {
        return user
    }
    
    func numberOfFollowers() -> NSAttributedString {
        return attributedStatText(value: userStats?.followers ?? 0, label: "followers")
    }
    
    func numberOfFollowing() -> NSAttributedString {
        return attributedStatText(value: userStats?.following ?? 0, label: "following")
    }
    
    func numberOfPosts() -> NSAttributedString {
        //guard let userStats = userStats else { fatalError() }
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
