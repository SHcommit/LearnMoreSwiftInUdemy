//
//  UserInfoViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/01.
//

import UIKit

class UserInfoViewModel {
    
    //MARK: - Properties
    fileprivate var user: UserInfoModel
    private var profileImage : UIImage?
    
    //MARK: - LifeCycle
    init(user: UserInfoModel, profileImage image: UIImage?) {
        self.user = user
        self.profileImage = image
    }
    
}

extension UserInfoViewModel {
    
    //MARK: - Get user value
    func getUserName() -> String {
        return user.username
    }
    
    func getUserFullName() -> String {
        return user.fullname
    }
    
    
    func getUserProfileURL() -> String {
        return user.profileURL
    }
    func getUserInfoModel() -> UserInfoModel {
        return user
    }
    
    func getUserEmail() -> String {
        return user.email
    }
    
    func getUserUID() -> String {
        return user.uid
    }
    
    //MARK: - Set user value
    
    func setUserProfile(iv: UIImageView) {
        iv.image = profileImage
    }
    
    
}
