//
//  FeedViewModelType.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/21.
//

import Combine

protocol FeedViewModelConvenience {
    typealias Input = FeedViewModelInput
    typealias Output = FeedViewModelOutput
    typealias State = FeedControllerState
}

struct FeedViewModelInput {
    
    var initData: AnyPublisher<Void,Never>
    var appear: AnyPublisher<Void,Never>
    var refresh: AnyPublisher<Void,Never>
    //이땐 로그인 커디네이터한테 전달. 자시은 디스미스하고
    var logout: AnyPublisher<Void,Never>
    var initCell: AnyPublisher<Int,Never>
    
}

typealias FeedViewModelOutput = AnyPublisher<FeedControllerState,Never>
enum FeedControllerState {
    case none
    case reloadData
    case endIndicator
    case appear
    case callLoginCoordinator
}

protocol FeedViewModelType: FeedViewModelComputedProperty, FeedViewModelConvenience {
    
    func transform(with input: Input) -> Output
}

protocol FeedViewModelComputedProperty {
    var count: Int { get }
    
    var isEmptyPost: Bool { get }
    
    var posts: [PostModel] { get }
    
    var getPost: PostModel? { get }
}
