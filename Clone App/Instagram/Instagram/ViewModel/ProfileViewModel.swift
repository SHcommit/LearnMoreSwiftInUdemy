//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/04.
//

import UIKit
import Combine

protocol ProfileViewModelType {
    func fetchData()
}

protocol ProfileViewModelAPIType {
    func fetchToCheckIfUserIsFollowed()
    func fetchUserStats()
    func fetchImage(profileUrl url: String) async
    func fetchImageFromUserProfileImageService(url: String) async throws
    func fetchImageErrorHandling(withError error: Error)
}

class ProfileViewModel {
    //MARK: - Properties
    @Published var user: UserInfoModel
    @Published var userStats: Userstats?
    @Published var profileImage: UIImage?
    
    //MARK: - Lifecycles
    init(userInfo: UserInfoModel) {
        user = userInfo
        fetchData()
    }
}

//MARK: - Helpers
extension ProfileViewModel: ProfileViewModelType {
    func fetchData() {
        fetchToCheckIfUserIsFollowed()
        fetchUserStats()
        Task() {
            await fetchImage(profileUrl: user.profileURL)
        }
    }
}

//MARK: - API
extension ProfileViewModel: ProfileViewModelAPIType {
    func fetchToCheckIfUserIsFollowed() {
        UserService.checkIfUserIsFollowd(uid: user.uid) { [unowned self] isFollowed in
            user.isFollowed = isFollowed
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { [unowned self] stats in
            userStats = stats
        }
    }
    
    func fetchImage(profileUrl url: String) async {
        do {
            try await fetchImageFromUserProfileImageService(url: url)
        } catch {
            fetchImageErrorHandling(withError: error)
        }
    }
    
    func fetchImageFromUserProfileImageService(url: String) async throws {
        let image = try await UserProfileImageService.fetchUserProfile(userProfile: url)
        profileImage = image
    }
    
    func fetchImageErrorHandling(withError error: Error) {
        switch error {
        case FetchUserError.invalidUserProfileImage :
            print("DEBUG: Failure invalid user profile image instance")
        default:
            print("DEBUG: Unexpected error occured  :\(error.localizedDescription)")
        }
    }
    
}
