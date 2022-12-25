//
//  CommentControllerInput.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit
import Combine

typealias CommentCellInfo = (cell: CommentCell, index: Int)

struct CommentViewModelInput {
    
    let appear: AnyPublisher<Void,Never>
    let reloadData: AnyPublisher<Void,Never>
    let cellForItem: AnyPublisher<CommentCellInfo,Never>
}

typealias CommentViewModelOutput = AnyPublisher<CommentControllerState,Never>

enum CommentControllerState {
    case none
    case updateUI
}

protocol CommentViewModelComputedPropery {
    
    var post: PostModel { get set }
    var comments: [CommentModel] { get set }
    
}

protocol CommentViewModelType: CommentViewModelComputedPropery {
    
    func transform(input: CommentViewModelInput) -> CommentViewModelOutput
    
    func size(forWidth width: CGFloat, index: Int) -> CGSize
    
}

protocol CommentViewModelInputCase {
    
    func newCommentChains() -> CommentViewModelOutput
    
    func appearChains(with input: CommentViewModelInput) -> CommentViewModelOutput
    
    func reloadDataChains(with input: CommentViewModelInput) -> CommentViewModelOutput
    
    func cellForItemChains(with input: CommentViewModelInput) -> CommentViewModelOutput
    
}

protocol CommentViewModelNetworkServiceType {
    
    func uploadComment(withInputModel input: UploadCommentInputModel )
    
    func fetchComments()
    
    func fetchUserImage(with imageView: UIImageView, index: Int)
    
    func fetchProfileFromImageService(index: Int) async throws -> UIImage
    
    func fetchImageErrorHandling(error: Error)
    
}
