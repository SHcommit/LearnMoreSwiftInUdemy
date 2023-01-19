//
//  CommentServiceType.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import Foundation
import Firebase

enum CommentServiceError: Error {
    case failedEncoding
    case failedDecoding
    
    var errorDescription: String {
        switch self {
        case .failedEncoding: return "Failed encoding wrong encodable data structure"
        case .failedDecoding: return "Failed decoding wrong decodable data"
        }
    }
}

protocol CommentServiceType {
    
    func uploadComment(inputModel info: UploadCommentInputModel) throws
    
    func fetchComment(postID: String, completion: @escaping([CommentModel])->Void)
    
}

extension CommentService {
    
    func createCommentModel(withUploadCommentInput info: UploadCommentInputModel) -> CommentModel {
        let comment = deleteLineBreaksInComment(with: info.comment)
        return CommentModel(uid: info.user.uid,
                            comment: comment,
                            timestamp: Timestamp(date: Date()),
                            username: info.user.username,
                            profileImageUrl: info.user.profileURL)
    }
    
    func deleteLineBreaksInComment(with comment: String) -> String {
        return comment.replacingOccurrences(of: "\n\n*", with: "\n", options: .regularExpression)
    }
}

