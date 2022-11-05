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
        if image == nil {
            fetchImage() { image in
                self.profileImage = image
            }
        }else {
            profileImage = image
        }
        
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
    
}


//MARK: - Helpers
extension ProfileHeaderViewModel {
    func followButtonText() -> String {
        if isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    func followButtonBackgroundColor() -> UIColor {
        return isCurrentUser ? .white : .systemBlue
    }
    
    func followButtonTextColor() -> UIColor {
        return isCurrentUser ? .black : .white
    }
}


//MARK: - API
extension ProfileHeaderViewModel {
    func fetchImage(completion: @escaping (UIImage)-> Void) {
        if let _ = profileImage {
            return
        }
        let url = profileURL()
        UserService.fetchUserProfile(userProfile: url) { image in
            guard let image = image else { return }
            completion(image)
        }
    }

}
