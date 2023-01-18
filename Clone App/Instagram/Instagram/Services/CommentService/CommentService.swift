//
//  CommentService.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/24.
//

import Foundation
import Firebase


struct CommentService: CommentServiceType {
    
    static func uploadComment(inputModel info: UploadCommentInputModel) throws {
        let commentModel = createCommentModel(withUploadCommentInput: info)
        guard let _ = try? FSConstants.ref(.posts)
            .document(info.postID)
            .collection("comments")
            .addDocument(from: commentModel.self) else {
            throw CommentServiceError.failedEncoding
        }
    }
    
    static func fetchComment(postID: String, completion: @escaping([CommentModel])->Void) {
        let query = FSConstants.ref(.posts)
            .document(postID)
            .collection("comments")
            .order(by: "timestamp", descending: true)
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
