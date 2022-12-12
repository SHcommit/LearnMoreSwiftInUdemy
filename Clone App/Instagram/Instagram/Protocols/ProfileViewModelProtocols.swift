//
//  ProfileViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import Foundation
import Combine

protocol ProfileViewModelType {
    
    var getUser: UserInfoModel { get set }
    
    func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput
    
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

struct ProfileViewModelInput {
    let appear: AnyPublisher<Void,ProfileErrorType>
    let cellConfigure: AnyPublisher<ProfileCell,ProfileErrorType>
    let headerConfigure: AnyPublisher<ProfileHeader, ProfileErrorType>
}

typealias ProfileViewModelOutput = AnyPublisher<ProfileControllerState, ProfileErrorType>
                                                  
enum ProfileControllerState {
    case reloadData,
         none
}

protocol ProfileViewModelInputChainCase {
    
    func appearChains(with input: ProfileViewModelInput) -> ProfileViewModelOutput
    
    func headerConfigureChains(with input: ProfileViewModelInput) -> ProfileViewModelOutput
    
    func cellConfigureChains(with input: ProfileViewModelInput) -> ProfileViewModelOutput
    
}

protocol ProfileVMInnerPropertiesPublisherChainType {
    
    //MARK: - ViewModel 's inner publisher's upstream chaining funcs
    
    // 프로퍼티들 중 값이 변했는지 체크
    func viewModelPropertiesPublisherValueChanged() -> ProfileViewModelOutput
    
    func userChains() -> ProfileViewModelOutput
    
    func profileImageChains() -> ProfileViewModelOutput
    
    func userStatsChains() -> ProfileViewModelOutput
    
}

protocol ProfileViewModelAPIType {
    
    func fetchData()
    
    func fetchToCheckIfUserIsFollowed()
    
    func fetchUserStats()
    
    func fetchImage(profileUrl url: String) async
    
    func fetchImageFromUserProfileImageService(url: String) async throws
    
    func fetchImageErrorHandling(withError error: Error)
}
