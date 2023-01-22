//
//  ProfileHeaderViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/13.
//

import UIKit
import Combine

/**
    Summary :  Input은 없다.
     ProfileController에서 viewModel에서 사용자의 정보, 프로필, 팔로우 개수를 받아오면
    viewModel의 inner publisher properties의 값이 갱신된다. 이 점을 이용해서 ProfileHeaderViewModelOutput을 통해 ProfileHeader's subViews를 갱신한다.
 
     Input은 그저 viewModel _user, _profileImage, _userStats에 각각의 값이 갱신될 때마다.
    각각의 publisher input stream에 대해서 Publisher<ProfileHeaderState, ProfileHeaderErrorType>
    흐름으로 바꾼 후 transform()함수를 통해 ProfileHeader의 render에서 UI를 업데이트 하도록 했다.
 */

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader)
}

///VM 각각의 properties에 대해서, 값이 바뀌면 publisher의 input stream을 ProfileHeaderState로, Never에서 커스텀 에러타입으로 변경하도록 chaining구성.
protocol ProfileHeaderVMInnerPublisherChainType {
    
    func userChains() -> ProfileHeaderViewModelOutput

    func profileImageChains() -> ProfileHeaderViewModelOutput

    func userStatsChains() -> ProfileHeaderViewModelOutput
    
}

typealias ProfileHeaderViewModelOutput = AnyPublisher<ProfileHeaderState,ProfileHeaderErrorType>

/// ProfileHeaderViewModel의 각각의 publisher에 대해서 먼저 들어오는 데이터에 대한 UI업데이트 case 를 구현했다.
enum ProfileHeaderState {
    case none,
         configureUserInfoUI,
         configureProfile,
         configureFollowUI
}

enum ProfileHeaderErrorType: Error {
    case fail
    var errorDescription: String {
        switch self {
        case .fail:
            return "none"
        }
    }

}

protocol ProfileHeaderViewModelType: ProfileHeaderViewModelComputedProperty, ProfileHeaderViewModelHelperType {
    
    func transform() -> ProfileHeaderViewModelOutput
    
}

protocol ProfileHeaderViewModelHelperType {
    
    func followButtonText() -> String
    
    func followButtonBackgroundColor() -> UIColor
    
    func followButtonTextColor() -> UIColor
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString
    
}

protocol ProfileHeaderViewModelComputedProperty {
    
    var user: UserModel { get set }
    
    var profileImage: UIImage? { get set }
    
    var userStats: Userstats? { get set }
    
    var profileURL: String { get set }
    
    var userName: String { get set }
    
    var numberOfFollowers: NSAttributedString { get }
    
    var numberOfFollowing: NSAttributedString { get }
    
    var numberOfPosts: NSAttributedString { get }
}
