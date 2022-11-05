//
//  UserInfoViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/01.
//

import UIKit

class UserInfoViewModel {
    
    //MARK: - Properties
    private var user: UserInfoModel
    private var profileImage : UIImage?
    
    //MARK: - LifeCycle
    init(user: UserInfoModel, profileImage image: UIImage? = nil) {
        self.user = user
        profileImage = image
    }
    
}

extension UserInfoViewModel {
    
    //MARK: - Get user value
    func username() -> String {
        return user.username
    }
    
    func fullname() -> String {
        return user.fullname
    }
    
    func profileURL() -> String {
        return user.profileURL
    }
    
    func userInfoModel() -> UserInfoModel {
        return user
    }
    
    func email() -> String {
        return user.email
    }
    
    func uid() -> String {
        return user.uid
    }
    
    func image() -> UIImage? {
        return profileImage
    }
    
}

//MARK: - API
extension UserInfoViewModel {
    func fetchImage(completion: @escaping () -> Void) {
        if let _ = profileImage {
            return
        }
        let url = profileURL()
        UserService.fetchUserProfile(userProfile: url) { image in
            guard let image = image else { return }
            self.profileImage = image
            completion()
        }
    }
}
