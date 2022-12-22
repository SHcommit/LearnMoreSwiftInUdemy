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
                self.fetchData()
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
            return
        }
        switch user.isFollowed {
        case true:
            Task() {
                await unFollow(someone: self.getUser.uid)
                let userStats = await fetchUserStats(uid: self.getUser.uid)
                DispatchQueue.main.async {
                    self.user.isFollowed = false
                    self.userStats = userStats
                }
            }
            break
        case false:
            Task() {
                await follow(someone: getUser.uid)
                let userStats = await fetchUserStats(uid: self.getUser.uid)
                DispatchQueue.main.async {
                    self.user.isFollowed = true
                    self.userStats = userStats
                }
            }
            break
        }
    }
    
    func fetchUserStats(uid: String) async -> Userstats {
        do {
            return try await UserService.fetchUserStats(uid: uid)
        }catch {
            fetchUserStatsErrorHandling(with: error as! FetchUserStatsError)
            return Userstats(followers: 0, following: 0)
        }
    }
    
    func follow(someone uid: String) async {
        do {
            try await UserService.follow(someone: uid)
        }catch {
           followErrorHandling(with: error)
        }
    }
    
    
    func unFollow(someone uid: String) async {
        do {
            try await UserService.unfollow(someone: self.getUser.uid)
        }catch {
            unFollowErrorHandling(error: error)
        }
    }
    
}


//MARK: - ProfileViewModelAPIType
extension ProfileViewModel: ProfileViewModelAPIType {
    
    func fetchData() {
        Task() {
            user.isFollowed = await fetchToCheckIfUserIsFollowed()
            userStats = await fetchUserStats()
            profileImage = await fetchImage(profileUrl: user.profileURL)
        }
    }
    
    func fetchToCheckIfUserIsFollowed() async -> Bool {
        do{
            return try await UserService.checkIfUserIsFollowd(uid: user.uid)
        }catch {
            fetchToCheckIfUserIsFollowedErrorHandling(with: error as! CheckUserFollowedError)
            return false
        }
    }
    
    func fetchUserStats() async -> Userstats {
        do {
            return try await UserService.fetchUserStats(uid: user.uid)
            
        }catch {
            fetchUserStatsErrorHandling(with: error as! FetchUserStatsError)
            return Userstats(followers: 0, following: 0)
        }
        
    }
    
    func fetchImage(profileUrl url: String) async -> UIImage {
        do {
            return try await UserProfileImageService.fetchUserProfile(userProfile: url)
        } catch {
            fetchImageErrorHandling(withError: error)
            return UIImage()
        }
    }
}

//MARK: - ProfileViewModelAPIErrorHandlingType
extension ProfileViewModel: ProfileViewModelAPIErrorHandlingType {
    func fetchImageErrorHandling(withError error: Error) {
        switch error {
        case FetchUserError.invalidUserProfileImage :
            print("DEBUG: Failure invalid user profile image instance")
        default:
            print("DEBUG: Unexpected error occured  :\(error.localizedDescription)")
        }
    }
    
    func fetchUserStatsErrorHandling(with error: FetchUserStatsError) {
        switch error {
        case .invalidSpecificUSerFollowingDocuemnt:
            print("DEBUG: \(FetchUserStatsError.invalidSpecificUSerFollowingDocuemnt)")
        case .invalidSpecificUserFollowersDocument:
            print("DEBUG: \(FetchUserStatsError.invalidSpecificUSerFollowingDocuemnt)")
        }
    }
    
    func fetchToCheckIfUserIsFollowedErrorHandling(with error: CheckUserFollowedError) {
        switch error {
        case .invalidCurrentUserUIDInUserDefaultsStandard:
            print("DEBUG: \(CheckUserFollowedError.invalidCurrentUserUIDInUserDefaultsStandard)")
            break
        case .invalidSpecificUserInfo:
            print("DEBUG: \(CheckUserFollowedError.invalidSpecificUserInfo)")
        }
    }

    func followErrorHandling(with error: Error) {
        guard let error = error as? FollowServiceError else { return }
        switch error {
        case .invalidCurrentUserUIDInUserDefaultsStandard:
            print("DEBUG: \(FollowServiceError.invalidCurrentUserUIDInUserDefaultsStandard) : \(error.localizedDescription)")
        case .failedFollowerToSetData:
            print("DEBUG: \(FollowServiceError.failedFollowerToSetData) : \(error.localizedDescription)")
        case .failedFollowingToSetData:
            print("DEBUG: \(FollowServiceError.failedFollowingToSetData) : \(error.localizedDescription)")
        }
    }
    
    func unFollowErrorHandling(error: Error) {
        guard let error = error as? UnFollowServiceError else { return }
        switch error {
        case .invalidCurrentUserUIDInUserDefaultsStandard:
            print("DEBUG: \(UnFollowServiceError.invalidCurrentUserUIDInUserDefaultsStandard) : \(error.localizedDescription)")
            break
        case .failedUnFollowLoginUserFromSpecificUser:
            print("DEBUG: \(UnFollowServiceError.failedUnFollowLoginUserFromSpecificUser) : \(error.localizedDescription)")
            break
        case .failedUnFollowSpecificUserFromLoginUser:
            print("DEBUG: \(UnFollowServiceError.failedUnFollowSpecificUserFromLoginUser) : \(error.localizedDescription)")
            break
        }
    }
    
}
