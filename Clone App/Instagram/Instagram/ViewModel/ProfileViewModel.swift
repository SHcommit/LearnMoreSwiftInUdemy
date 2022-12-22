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
    @Published var postsInfo = [PostModel]()
    @Published var posts = [UIImage]()
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Lifecycles
    init(user: UserInfoModel) {
        self.user = user
    }
    
}

//MARK: - ProfileViewModelType
extension ProfileViewModel: ProfileViewModelType {
            
    func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput {
        
        let appear = appearChains(with: input)
        
        let concurrencyFetchPostsNotification = bindPostsToPostsImage()
        
        let appears = Publishers.Merge(appear, concurrencyFetchPostsNotification)
        
        let headerConfigure = headerConfigureChains(with: input)
        
        let cellConfigure = cellConfigureChains(with: input)
        
        let didTapCell = didTapCellChains(with: input)
        
        let input = Publishers.Merge4(appears, headerConfigure, cellConfigure, didTapCell).eraseToAnyPublisher()
        
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

    var getPostsCount: Int {
        get {
            return posts.count
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
                return .none
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
            .tryMap { [unowned self] (cell, index) -> ProfileControllerState in
                cell.postIV.image = posts[index]
                return .none
            }.mapError { error -> ProfileErrorType in
                return error as? ProfileErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func didTapCellChains(with input: ProfileViewModelInput) -> ProfileViewModelOutput {
        return input.didTapCell
            .receive(on: RunLoop.main)
            .tryMap { index in
                let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
                feed.post = self.postsInfo[index]
                return .showSpecificUser(feed: feed)
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
    
    func bindPostsToPostsImage() -> ProfileViewModelOutput {
        $postsInfo
            .sink { users in
                self.fetchPostsConcurrency()
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
            await [fetchImage(profileUrl: user.profileURL),
                   fetchSpecificUserPostsInfo()]
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
    
    func fetchSpecificUserPostsInfo() async {
        do {
            self.postsInfo = try await PostService.fetchSpecificUserPostsInfo(type: PostModel.self, forUser: user.uid)
        } catch let error {
            guard let error = error as? FetchPostError else { return }
            fetchPostsErrorHandling(with: error)
        }
    }
    
    func fetchSpecificPost(with url: String) async -> UIImage {
        do {
            return try await UserProfileImageService.fetchUserProfile(userProfile: url)
        }catch {
            print("DEBUG: 각각의 상황에 대한 오류 처리 해야 함 :\(error.localizedDescription)")
            return UIImage()
        }
    }
    
    func fetchPostsConcurrency() {
        Task() {
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
    
    
    
    func fetchImageErrorHandling(withError error: Error) {
        switch error {
        case FetchUserError.invalidUserProfileImage :
            print("DEBUG: Failure invalid user profile image instance")
        default:
            print("DEBUG: Unexpected error occured  :\(error.localizedDescription)")
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
