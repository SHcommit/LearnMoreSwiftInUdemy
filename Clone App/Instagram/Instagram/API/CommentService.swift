//
//  CommentService.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/24.
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

struct CommentService {
    
    static func uploadComment(inputModel info: UploadCommentInputModel) throws {
        let commentModel = createCommentModel(withUploadCommentInput: info)
        
        guard let _ = try? COLLECTION_POSTS.document(info.postID)
            .collection("comments")
            .addDocument(from: commentModel.self) else {
            throw CommentServiceError.failedEncoding
        }
    }
    
    static func fetchComment(postID: String, completion: @escaping([CommentModel])->Void) {
        let query = COLLECTION_POSTS.document(postID)
            .collection("comments").order(by: "timestamp", descending: true)
        var res = [CommentModel]()
        query.addSnapshotListener { (snapshot,error) in
            snapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    do {
                        let comment = try change.document.data(as: CommentModel.self)
                        res.append(comment)
                    }catch { }
                }
            }
            res.sort(by: {$0.timestamp.seconds < $1.timestamp.seconds})
            completion(res)
        }
        
    }
    
}

extension CommentService {
    
    static func createCommentModel(withUploadCommentInput info: UploadCommentInputModel) -> CommentModel {
        return CommentModel(uid: info.user.uid,
                            comment: info.comment,
                            timestamp: Timestamp(date: Date()),
                            username: info.user.username,
                            profileImageUrl: info.user.profileURL)
    }
    
}
