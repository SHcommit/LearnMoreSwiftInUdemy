//
//  PostViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/12.
//

import UIKit

class PostViewModel {
    private var post: PostModel
    private var postImage: UIImage?
    
    init(post: PostModel) {
        self.post = post
    }
}

extension PostViewModel {
    
    func fetchPostImage() async {
        do {
            let image = try await UserProfileImageService.fetchUserProfile(userProfile: post.imageUrl)
            DispatchQueue.main.async {
                self.postImage = image
            }
        } catch {
            print("DEBUG: Unexccept Error occured: \(error.localizedDescription)")
        }
    }
    
    var image: UIImage? {
        get {
            guard let postImage = postImage else {
                return nil
            }
            return postImage
        }
    }
    
    var caption: String {
        get {
            return post.caption
        }
    }
    
}
