//
//  MainHomeTabViewModelType.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import Combine

struct MainHomeTabViewModelInput{
    var appear: AnyPublisher<Void,Never>
}

typealias MainHomeTabViewModelOutput = AnyPublisher<MainHomeTabControllerState,Never>
enum MainHomeTabControllerState {
    case none
    case fetchUserInfoIsCompleted
}

protocol MainHomeTabViewModelType: MainHomeTabViewModelComputedProperty {
    typealias Input = MainHomeTabViewModelInput
    typealias Output = MainHomeTabViewModelOutput
    typealias State = MainHomeTabControllerState
    
    func transform(with input: Input) -> Output
    
}

protocol MainHomeTabViewModelComputedProperty {
    var user: UserInfoModel { get set }
}
