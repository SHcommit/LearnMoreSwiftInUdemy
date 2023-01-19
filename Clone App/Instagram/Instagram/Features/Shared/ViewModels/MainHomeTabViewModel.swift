//
//  MainHomeTabViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit
import Combine

class MainHomeTabViewModel {
    @Published var _user: UserInfoModel!
    fileprivate let apiClient: ServiceProviderType
    
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
    }
}

extension MainHomeTabViewModel: MainHomeTabViewModelComputedProperty {
    
    var user: UserInfoModel {
        get {
            return _user
        }
        set {
            _user = newValue
        }
    }
    
}

extension MainHomeTabViewModel: MainHomeTabViewModelType {
   
    func transform(with input: Input) -> Output {
        setupUserInfo()
        
        let updatedUser = userChains()
        
        let appear = appearChains(with: input)
        
        return Publishers
            .Merge(updatedUser,appear)
            .eraseToAnyPublisher()
    }
    
}

//MARK: - Helpers
extension MainHomeTabViewModel {
    
    func setupUserInfo() {
        if _user == nil {
            Task(priority: .high) {
                await fetchLoginUserInfo()
            }
        }
    }
    
    //MARK: - Subscription chains
    func userChains() -> Output {
        return  $_user
            .subscribe(on: DispatchQueue.main)
            .map { _ -> State in
                return .fetchUserInfoIsCompleted
            }.eraseToAnyPublisher()
    }
    
    func appearChains(with input: Input) -> Output {
        return input.appear
            .receive(on: DispatchQueue.main)
            .map { _ -> State in
                    .none
            }.eraseToAnyPublisher()
    }
    
}

//MARK: - APIs
extension MainHomeTabViewModel {
    func fetchLoginUserInfo() async {
        do {
            try await fetchUserInfoFromUserService()
        } catch {
            fetchCurrentUserInfoErrorHandling(withError: error)
        }
    }
    /// 어차피 여기서 영구저장소에서 꺼내오네
    func fetchUserInfoFromUserService() async throws {
        guard let user = try await apiClient.userCase.fetchCurrentUserInfo(type: UserInfoModel.self) else { throw FetchUserError.invalidUserInfo }
        self.user = user
    }
    func fetchCurrentUserInfoErrorHandling(withError error: Error) {
        guard let error = error as? FetchUserError else { return }
        switch error {
        case .invalidGetDocumentUserUID:
            print("DEBUG: Invalid get docuemnt specific user's uid")
            break
        case .invalidUserInfo:
            print("DEBUG: Invalid user's instance")
            break
        default :
            print("DEBUG: Unexpected error occured")
            break
        }
    }
}
