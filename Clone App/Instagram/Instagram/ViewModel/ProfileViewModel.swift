//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/04.
//

import UIKit
import Combine
/**
    일단 profileImage경우 메인 홈 컨트롤러에서 비동기적으로 업데이트했는데 VM이 하도록 했다.
    그리고 Controller에선 setupBindings를 통해 profileImage값이 바뀌면 sink로 현재 label등이 바뀌도록할것이다.
    searchViewController에서 tableView(didSelectedRowAt)요고더 profileVC랑 연관있음.
 */
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
extension ProfileViewModel {
    func fetchData() {
        fetchToCheckIfUserIsFollowed()
        fetchUserStats()
        Task() {
            await fetchImage(profileUrl: user.profileURL)
        }
    }
}

//MARK: - API
extension ProfileViewModel {
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
        DispatchQueue.main.async {
            self.profileImage = image
        }
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
