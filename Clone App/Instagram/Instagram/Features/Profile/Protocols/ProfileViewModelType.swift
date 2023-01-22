//
//  ProfileViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import UIKit
import Combine

protocol ProfileViewModelConvenience {
    typealias Input = ProfileViewModelInput
    typealias Output = ProfileViewModelOutput
    typealias State = ProfileControllerState
}

protocol ProfileViewModelComputedProperty {
    
    var getUser: UserModel { get set }
    
    var getPostsCount: Int { get }
    
    var tabBarController: UITabBarController? { get set }
    
}

protocol ProfileViewModelType: ProfileViewModelComputedProperty, ProfileViewModelConvenience {
    
    /**
     Summary : ProfileViewController, view의 이벤트 Input에 대한 로직 처리후 output로 반환
     
     - parameter input: ProfileViewModelInput's UpStream Publisher from ProfileController's event.
     - returns: ProfileViewModelOutput. Update ProfileController's view with Ouptut's each state.
     - warning:
        ProfileViewModel은 ProfileController가 초기화와 동시에 Dependency Injection으로 인해 같이 초기화 된다.
        이때 VM의 역할은 collectionView cell, header 등 전부 데이터 처리를 담당한다. 그래서 VM의 변수 userStats,
        profileImage 가 @Published로 존재하는데 이 값들이 async await를 통해 서버에서 파싱된 이후에는 바로 ProfileController의 view를
        reload해야한다.
        그래서 transform의 output에는 ProfileVMInnerPropertiesPublisherChainType 에 있는
        viewModelPropertiesPublisherValueChanged() 를 통해 **기존의 Input 타입 이외에도 Output을 하는 publisher가 늘어난다**.
    
     # Notes: #
     1.  기존의 Input 타입 이외에도 Output을 하는 publisher가 추가됨.
     */
    func transform(input: Input) -> Output
    
}

enum ProfileErrorType: Error {
    
    case invalidInstance,
         failed,
         invalidUserProperties
        
    var errorDiscription: String {
        switch self {
        case .failed:
            return "DEBUG: failed"
        case .invalidInstance:
            return "DEBUG: InvalidInstance"
        case .invalidUserProperties:
            return "DEBUG: ProfileViewModel's user properties invalid"
        }
    }
}

/**
 TODO : ProfileController의 Event를 각각의 Input Publisher로 처리
 
 - Param appear : ProfileController LifeCycle 시작될 경우
 - Param cellConfigure : collectionView cell UI configure
 - Param headerConfigure : collectionView header UI configure
 */
struct ProfileViewModelInput {
    
    let appear: AnyPublisher<Void,ProfileErrorType>
    
    let cellConfigure: AnyPublisher<(ProfileCell, index: Int),ProfileErrorType>
    
    let headerConfigure: AnyPublisher<ProfileHeader, ProfileErrorType>
    
    let didTapCell: AnyPublisher<Int, ProfileErrorType>
    
}

typealias ProfileViewModelOutput = AnyPublisher<ProfileControllerState, ProfileErrorType>
                                                  
enum ProfileControllerState {
    
    case reloadData,
         showSpecificUser(postOwner: PostModel),
         startIndicator,
         endIndicator,
         none
}

protocol ProfileViewModelInputChainCase: ProfileViewModelConvenience {
    
    /// appear Input publisher's stream chains
    func appearChains(with input: Input) -> Output
    
    /// headerConfigure Input publisher's stream chains
    func headerConfigureChains(with input: Input) -> Output
    
    /// cellConfigure Input publisher's stream chains
    func cellConfigureChains(with input: Input) -> Output
    
    /// present specific user's detail profileController
    func didTapCellChains(with input: Input) -> Output
}

//MARK: - ViewModel 's inner publisher's upstream chaining funcs
protocol ProfileVMInnerPropertiesPublisherChainType: ProfileViewModelConvenience {
    
    func viewModelPropertiesPublisherValueChanged() -> Output
    
    func userChains() -> Output
    
    func profileImageChains() -> Output
    
    func userStatsChains() -> Output
    
    //각각 동시에 받은 이미지 cell에 갱신.
    func bindPostsToPostsImage() -> Output
    
}

protocol ProfileViewModelAPIType {
    //MARK: - configure
    
    func fetchDataConcurrencyConfigure()
    
    func fetchPostsConcurrencyConfigure()
    
    //MARK: - ProfileVM API Types
    
    func fetchToCheckIfUserIsFollowed() async -> Bool
    
    func fetchUserStats() async -> Userstats
    
    func fetchImage(profileUrl url: String) async -> UIImage

    func fetchSpecificUserPostsInfo() async -> [PostModel]

    func fetchSpecificPost(with url: String) async -> UIImage

}

protocol ProfileViewModelAPIErrorHandlingType {
    
    func fetchImageErrorHandling(withError error: Error)
    
    func fetchUserStatsErrorHandling(with error: FetchUserStatsError)
    
    func fetchToCheckIfUserIsFollowedErrorHandling(with error: CheckUserFollowedError)
    
    func followErrorHandling(with error: Error)
    
    func unFollowErrorHandling(error: Error)
}
