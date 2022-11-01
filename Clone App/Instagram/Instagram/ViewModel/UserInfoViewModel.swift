//
//  UserInfoViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/01.
//

import UIKit

struct UserInfoViewModel {
    
    //MARK: - Properties
    private var user: UserInfoModel
    private var profileImage : UIImage?
    
    //MARK: - LifeCycle
    init(user: UserInfoModel, profileImage image: UIImage?) {
        self.user = user
        self.profileImage = image
    }
    
}

extension UserInfoViewModel {
    
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
    
    func setUserProfile(iv: UIImageView) {
        iv.image = profileImage
    }
}
