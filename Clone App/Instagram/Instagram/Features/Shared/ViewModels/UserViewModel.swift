//
//  UserInfoViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/01.
//

import UIKit

class UserViewModel {
    
    //MARK: - Properties
    private var user: UserModel
    private var userStats: Userstats?
    private var profileImage : UIImage?
    private let apiClient: ServiceProviderType
    
    //MARK: - LifeCycle
    init(user: UserModel, profileImage image: UIImage? = nil, stats: Userstats? = nil, apiClient: ServiceProviderType) {
        self.user = user
        profileImage = image
        userStats = stats
        self.apiClient = apiClient
    }
    
}

extension UserViewModel {
    
    var getUser: UserModel {
        return user
    }
    
    
    var stats: Userstats {
        get {
            guard let userStats = userStats else { return Userstats(followers: -1, following: -1) }
            return userStats
        }
        set(value) {
            userStats = value
        }
    }
    
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
    
    func userInfoModel() -> UserModel {
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

//MARK: - Helpers
extension UserViewModel {
    
    func isValidImage() -> Bool {
        if profileImage == nil {
           return false
        }
        return true
    }
}

//MARK: - API
extension UserViewModel {
    
    func fetchImage() async {
        if isValidImage() { return }
        do {
            try await fetchProfileFromImageService()
        } catch {
            fetchImageErrorHandling(error: error)
        }
    }
    
    func fetchProfileFromImageService() async throws {
        let image = try await apiClient.imageCase.fetchUserProfile(userProfile: profileURL())
        DispatchQueue.main.async {
            self.profileImage = image
        }
    }
    
    func fetchImageErrorHandling(error: Error) {
        switch error {
        case FetchUserError.invalidUserProfileImage:
            print("DEBUG: Failure invalid user profile image instance")
            break
        default:
            print("DEBUG: Failure occured unexpected error: \(error.localizedDescription)")
        }
    }
    

    func fetchUserStats() {
        Task() {
            let userStats = try await apiClient.userCase.fetchUserStats(uid: user.uid)
            DispatchQueue.main.async {
                self.userStats = userStats
            }
        }
    }

}
