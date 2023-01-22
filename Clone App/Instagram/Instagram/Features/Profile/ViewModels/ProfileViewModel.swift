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
    @Published var user: UserModel
    @Published var userStats: Userstats?
    @Published var profileImage: UIImage?
    @Published var postsInfo = [PostModel]()
    @Published var posts = [UIImage]()
    fileprivate var indicatorSubject = PassthroughSubject<IndicatorState,Never>()
    fileprivate var subscriptions = Set<AnyCancellable>()
    fileprivate var tab: UITabBarController?
    
    //MARK: - Usecase
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(user: UserModel, apiClient: ServiceProviderType) {
        self.user = user
        self.apiClient = apiClient
    }
    
}

//MARK: - ProfileViewModelType
extension ProfileViewModel: ProfileViewModelType {
            
    func transform(input: Input) -> Output {
        let indicatorSubscription = indicatorSubjectChains()
        
        let appear = appearChains(with: input)
        
        let concurrencyFetchPostsNotification = bindPostsToPostsImage()
        
        let appears = Publishers.Merge(appear, concurrencyFetchPostsNotification)
        
        let headerConfigure = headerConfigureChains(with: input)
        
        let cellConfigure = cellConfigureChains(with: input)
        
        let didTapCell = didTapCellChains(with: input)
        
        let input = Publishers.Merge4(appears, headerConfigure, cellConfigure, didTapCell).eraseToAnyPublisher()
        
        return Publishers.Merge3(input,
                                 viewModelPropertiesPublisherValueChanged(),
                                 indicatorSubscription).eraseToAnyPublisher()
    }
        
}

//MARK: - ProfileViewModelComputedProperty
extension ProfileViewModel: ProfileViewModelComputedProperty {
    
    var getUser: UserModel {
        get {
            return user
        }
        set {
            user = newValue
        }
    }

    var getPostsCount: Int {
        return posts.count
    }
    
    var tabBarController: UITabBarController? {
        get {
            return tab
        }
        set {
            tab = newValue
        }
    }
    
}

//MARK: - ProfileViewModelInputChainCase
extension ProfileViewModel: ProfileViewModelInputChainCase {
    
    func appearChains(with input: Input) -> Output {
        return input.appear
            .receive(on: RunLoop.main)
            .tryMap { _ -> ProfileControllerState in
                self.fetchDataConcurrencyConfigure()
                return .reloadData
            }.mapError{ error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func headerConfigureChains(with input: Input) -> Output {
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
    
    func cellConfigureChains(with input: Input) -> Output {
        return input.cellConfigure
            .receive(on: RunLoop.main)
            .tryMap { [unowned self] (cell, index) -> ProfileControllerState in
                cell.postIV.image = posts[index]
                return .none
            }.mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func didTapCellChains(with input: Input) -> Output {
        return input.didTapCell
            .receive(on: RunLoop.main)
            .tryMap { index in
                let postOwner = self.postsInfo[index]
                return .showSpecificUser(postOwner: postOwner)
            }.mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func indicatorSubjectChains() -> Output {
        indicatorSubject
            .subscribe(on: DispatchQueue.main)
            .setFailureType(to: ProfileErrorType.self)
            .map { indicatorState -> ProfileControllerState in
                switch indicatorState {
                case .start:
                    return .startIndicator
                case .end:
                    return .endIndicator
                }
            }.eraseToAnyPublisher()
    }
}
    
//MARK: - ProfileVMInnerPropertiesPublisherChainType
extension ProfileViewModel: ProfileVMInnerPropertiesPublisherChainType {
    
    func viewModelPropertiesPublisherValueChanged() -> Output {
        return Publishers.Merge3(userChains(),
                                 profileImageChains(),
                                 userStatsChains()).eraseToAnyPublisher()
    }
    
    func userChains() -> Output {
        return $user
            .setFailureType(to: ProfileErrorType.self)
            .tryMap { _ -> ProfileControllerState in return .reloadData }
            .mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .invalidUserProperties
            }.eraseToAnyPublisher()
    }
    
    func profileImageChains() -> Output {
        return $profileImage
            .compactMap{ $0 }
            .setFailureType(to: ProfileErrorType.self)
            .tryMap{ _ -> ProfileControllerState in return .reloadData }
            .mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .invalidUserProperties
            }.eraseToAnyPublisher()
    }
    
    func userStatsChains() -> Output {
        return $userStats
            .compactMap { $0 }
            .setFailureType(to: ProfileErrorType.self)
            .tryMap{ _ -> ProfileControllerState in return .reloadData }
            .mapError{ error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .invalidUserProperties
            }.eraseToAnyPublisher()
    }
    
    func bindPostsToPostsImage() -> Output {
        $postsInfo
            .sink { users in
                self.fetchPostsConcurrencyConfigure()
            }.store(in: &subscriptions)
        
        return $posts
            .setFailureType(to: ProfileErrorType.self)
            .receive(on: RunLoop.main)
            .tryMap { _ -> ProfileControllerState in return .reloadData }
            .mapError{ error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .invalidInstance
            }.eraseToAnyPublisher()
        
    }
    
}

//MARK: - ProfileHeaderDelegate
extension ProfileViewModel: ProfileHeaderDelegate {
    
    func header(_ profileHeader: ProfileHeader) {
        indicatorSubject.send(.start)
        if user.isCurrentUser {
            print("DEBUG: Show edit profile here..")
            indicatorSubject.send(.end)
            return
        }
        guard let tab = tabBarController as? MainHomeTabController else { indicatorSubject.send(.end); return }
        let currentUser = tab.vm.user
        switch user.isFollowed {
        case true:
            Task() {
                await unFollow(someone: self.getUser.uid)
                let userStats = await fetchUserStats(uid: self.getUser.uid)
                DispatchQueue.main.async {
                    self.user.isFollowed = false
                    self.userStats = userStats
                    self.indicatorSubject.send(.end)
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
                    self.indicatorSubject.send(.end)
                }
                let uploadNoti = UploadNotificationModel(
                    uid: currentUser.uid,
                    profileImageUrl: currentUser.profileURL,
                    username: currentUser.username,
                    userIsFollowed: currentUser.isFollowed)
                apiClient.notificationCase.uploadNotification(
                    toUid: user.uid,
                    to: uploadNoti,
                    type: .follow,post: nil)
            }
            break
        }
    }
    
    func fetchUserStats(uid: String) async -> Userstats {
        do {
            return try await apiClient.userCase.fetchUserStats(uid: uid)
        }catch {
            fetchUserStatsErrorHandling(with: error as! FetchUserStatsError)
            return Userstats(followers: 0, following: 0)
        }
    }
    
    func follow(someone uid: String) async {
        do {
            try await apiClient.userCase.follow(someone: uid)
        }catch {
           followErrorHandling(with: error)
        }
    }
    
    
    func unFollow(someone uid: String) async {
        do {
            try await apiClient.userCase.unfollow(someone: self.getUser.uid)
        }catch {
            unFollowErrorHandling(error: error)
        }
    }
    
}

//MARK: - ProfileViewModelAPIType
extension ProfileViewModel: ProfileViewModelAPIType {
    
    func fetchDataConcurrencyConfigure() {
        Task(priority: .medium) {
            async let isFollow = fetchToCheckIfUserIsFollowed()
            async let stats = fetchUserStats()
            async let image = fetchImage(profileUrl: user.profileURL)
            async let postsInfo = fetchSpecificUserPostsInfo()
    
            let res = await (isFollow, stats, image, postsInfo)
            DispatchQueue.main.async {
                self.user.isFollowed = res.0
                self.userStats = res.1
                self.profileImage = res.2
                self.postsInfo = res.3
            }
       }
    }
    
    func fetchPostsConcurrencyConfigure() {
        Task(priority: .medium) {
            posts = await withTaskGroup(of: UIImage.self) { group in
                var images = [UIImage]()
                
                postsInfo.forEach { post in
                    group.addTask{
                        return await self.fetchSpecificPost(with: post.imageUrl)
                    }
                }
                
                for await img in group {
                    images.append(img)
                }
                return images
            }
        }
    }
    
    func fetchToCheckIfUserIsFollowed() async -> Bool {
        do{
            return try await apiClient.userCase.checkIfUserIsFollowd(uid: user.uid)
        }catch {
            fetchToCheckIfUserIsFollowedErrorHandling(with: error as! CheckUserFollowedError)
            return false
        }
    }
    
    func fetchUserStats() async -> Userstats {
        do {
            return try await apiClient.userCase.fetchUserStats(uid: user.uid)
            
        }catch {
            fetchUserStatsErrorHandling(with: error as! FetchUserStatsError)
            return Userstats(followers: 0, following: 0)
        }
        
    }

    func fetchImage(profileUrl url: String) async -> UIImage {
        do {
            return try await apiClient.imageCase.fetchUserProfile(userProfile: url)
        } catch {
            fetchImageErrorHandling(withError: error)
            return UIImage()
        }
    }
    
    func fetchSpecificUserPostsInfo() async -> [PostModel] {
        do {
            return try await apiClient.postCase.fetchSpecificUserPostsInfo(forUser: user.uid)
        } catch let error {
            guard let error = error as? FetchPostError else { return [PostModel]() }
            fetchPostsErrorHandling(with: error)
            return [PostModel]()
        }
    }
    
    func fetchSpecificPost(with url: String) async -> UIImage {
        do {
            return try await apiClient.imageCase.fetchUserProfile(userProfile: url)
        }catch {
            print("DEBUG: 각각의 상황에 대한 오류 처리 해야 함 :\(error.localizedDescription)")
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

    func fetchPostsErrorHandling(with error: FetchPostError) {
        switch error {
        case .invalidPostsGetDocuments:
            print("DEBUG: " + FetchPostError.invalidPostsGetDocuments.errorDescription + " : " + "\(error.localizedDescription)")
        case .failToEncodePost:
            print("DEBUG: " + FetchPostError.failToEncodePost.errorDescription + " : " + "\(error.localizedDescription)")
        case .failToRequestPostData:
            print("DEBUG: " + FetchPostError.failToRequestPostData.errorDescription + " : " + "\(error.localizedDescription)")
        case .invalidUserPostData:
            print("DEBUG: " + FetchPostError.invalidUserPostData.errorDescription + " : " + "\(error.localizedDescription)")
        default:
            print("DEBUG: failed fetch Posts : \(error.localizedDescription)")
        }
    }
    
}
