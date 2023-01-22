//
//  CommentControllerInput.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit
import Combine

protocol CommentViewModelConvenience {
    typealias Input = CommentViewModelInput
    typealias Output = CommentViewModelOutput
    typealias State = CommentControllerState
}

typealias CommentCellInfo = (cell: CommentCell, index: Int)
typealias CommentCellSelectInfo = (nav: UINavigationController?, index: Int)

struct CommentViewModelInput {
    
    let appear: AnyPublisher<Void,Never>
    let reloadData: AnyPublisher<Void,Never>
    let cellForItem: AnyPublisher<CommentCellInfo,Never>
    let didSelected: AnyPublisher<CommentCellSelectInfo,Never>
    
}

typealias CommentViewModelOutput = AnyPublisher<CommentControllerState,Never>

enum CommentControllerState {
    
    case none
    case updateUI
    
}

protocol CommentViewModelComputedPropery {
    
    var post: PostModel { get set }
    var comments: [CommentModel] { get set }
    var count: Int { get }
    
}

protocol CommentViewModelType: CommentViewModelComputedPropery, CommentViewModelConvenience {
    
    func transform(input: Input) -> Output
    
    func size(forWidth width: CGFloat, index: Int) -> CGSize
    
}

protocol CommentViewModelInputCase: CommentViewModelConvenience {
    
    func newCommentChains() -> Output
    
    func appearChains(with input: Input) -> Output
    
    func reloadDataChains(with input: Input) -> Output
    
    func cellForItemChains(with input: Input) -> Output
    
    func didSelectedChains(with input: Input) -> Output
    
}

protocol CommentViewModelNetworkServiceType {
    
    func uploadComment(withInputModel input: UploadCommentInputModel )
    
    func fetchComments()
    
    func fetchUserImage(with imageView: UIImageView, index: Int)
    
    func fetchProfileFromImageService(index: Int) async throws -> UIImage
    
    func fetchImageErrorHandling(error: Error)
    
}
