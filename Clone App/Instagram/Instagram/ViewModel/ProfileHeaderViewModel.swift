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
    private var user: UserInfoModel
    private var profileImage : UIImage?
    
    private var isCurrentUser: Bool {
        return CURRENT_USER?.uid == user.uid
    }
    //MARK: - LifeCycle
    init(user: UserInfoModel, profileImage image: UIImage? = nil) {
        self.user = user
        self.profileImage = image
    }
    
    func initProfileImage(image: UIImage?) {
        profileImage = image
    }
    
}


//MARK: - Get data
extension ProfileHeaderViewModel {
    
    func image() -> UIImage? {
        return profileImage
    }
    
    func username() -> String {
        return user.username
    }
    
    func getUserInfo() -> UserInfoModel {
        return user
    }
    
    func profileURL() -> String {
        return user.profileURL
    }
}


//MARK: - Helpers
extension ProfileHeaderViewModel {
    func followButtonText() -> String {
        if isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
}
