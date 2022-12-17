//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/04.
//

import UIKit
import Combine

class ProfileViewModel {
    //MARK: - Properties
    @Published var user = UserInfoModel(email: "", fullname: "", profileURL: "", uid: "", username: "")
    @Published var userStats: Userstats?
    @Published var profileImage: UIImage?
    
    //MARK: - Lifecycles
    init(user: UserInfoModel) {
        self.user = user
        fetchData()
    }
    
}

//MARK: - ProfileViewModelType
extension ProfileViewModel: ProfileViewModelType {
            
    func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput {
        
        let appear = appearChains(with: input)
        
        let headerConfigure = headerConfigureChains(with: input)
        
        let cellConfigure = cellConfigureChains(with: input)
        
        let input = Publishers.Merge3(appear, headerConfigure, cellConfigure).eraseToAnyPublisher()
        
        return Publishers.Merge(input,
                                viewModelPropertiesPublisherValueChanged()).eraseToAnyPublisher()
    }
        
}

//MARK: - ProfileViewModel Get/Set
extension ProfileViewModel {
    
    var getUser: UserInfoModel {
        get {
            return user
        }
        set {
            user = newValue
        }
    }

}

//MARK: - ProfileViewModelInputChainCase
extension ProfileViewModel: ProfileViewModelInputChainCase {
    
    func appearChains(with input: ProfileViewModelInput) -> ProfileViewModelOutput {
        return input.appear
            .receive(on: RunLoop.main)
            .tryMap { _ -> ProfileControllerState in
                return .reloadData
            }.mapError{ error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func headerConfigureChains(with input: ProfileViewModelInput) -> ProfileViewModelOutput {
        return input.headerConfigure
            .receive(on: RunLoop.main)
            .tryMap { [unowned self] headerView -> ProfileControllerState in
                headerView.delegate = self
                headerView.viewModel = ProfileHeaderViewModel(user: user, profileImage: profileImage, userStats: userStats)
                return .none
            }.mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func cellConfigureChains(with input: ProfileViewModelInput) -> ProfileViewModelOutput {
        return input.cellConfigure
            .receive(on: RunLoop.main)
            .tryMap { cell -> ProfileControllerState in
                cell.backgroundColor = .systemPink
                return .none
            }.mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
}
    
//MARK: - ProfileVMInnerPropertiesPublisherChainType
extension ProfileViewModel: ProfileVMInnerPropertiesPublisherChainType {
    
    func viewModelPropertiesPublisherValueChanged() -> ProfileViewModelOutput {
        return Publishers.Merge3(userChains(),
                                 profileImageChains(),
                                 userStatsChains()).eraseToAnyPublisher()
    }
    
    func userChains() -> ProfileViewModelOutput {
        return $user
            .setFailureType(to: ProfileErrorType.self)
            .tryMap { _ -> ProfileControllerState in return .reloadData }
            .mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .invalidUserProperties
            }.eraseToAnyPublisher()
    }
    
    func profileImageChains() -> ProfileViewModelOutput {
        return $profileImage
            .compactMap{ $0 }
            .setFailureType(to: ProfileErrorType.self)
            .tryMap{ _ -> ProfileControllerState in return .reloadData }
            .mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .invalidUserProperties
            }.eraseToAnyPublisher()
    }
    
    func userStatsChains() -> ProfileViewModelOutput {
        return $userStats
            .compactMap { $0 }
            .setFailureType(to: ProfileErrorType.self)
            .tryMap{ _ -> ProfileControllerState in return .reloadData }
            .mapError{ error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .invalidUserProperties
            }.eraseToAnyPublisher()
    }

}

//MARK: - ProfileHeaderDelegate
extension ProfileViewModel: ProfileHeaderDelegate {
    
    func header(_ profileHeader: ProfileHeader) {
        if user.isCurrentUser {
            print("DEBUG: Show edit profile here..")
        }else if user.isFollowed {
            DispatchQueue.main.async {
                UserService.unfollow(uid: self.getUser.uid) { _ in
                    self.user.isFollowed = false
                    UserService.fetchUserStats(uid: self.getUser.uid) { stats in
                        self.userStats = stats
                    }
                }
            }
        }else {
            DispatchQueue.main.async {
                UserService.follow(uid: self.getUser.uid) { _ in
                    self.user.isFollowed = true
                    UserService.fetchUserStats(uid: self.getUser.uid) { stats in
                        self.userStats = stats
                    }
                }
            }
        }
    }
    
}


//MARK: - ProfileViewModelAPIType
extension ProfileViewModel: ProfileViewModelAPIType {
    
    
    func fetchData() {
        fetchToCheckIfUserIsFollowed()
        fetchUserStats()
        Task() {
            await fetchImage(profileUrl: user.profileURL)
        }
    }
    
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
    
    func fetchPosts() async throws {
        let posts = try await PostService.fetchPosts(type: UserInfoModel.self, forUser: user.uid)
        
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
