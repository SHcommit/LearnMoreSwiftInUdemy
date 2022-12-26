//
//  PostViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/12.
//

import UIKit
import Firebase
import Combine

class PostViewModel {
    //MARK: - Properties
    var post: PostModel
    private var postImage: UIImage?
    private var userProfile: UIImage?
    var likeChanged = PassthroughSubject<Void,Never>()
    
    //MARK: - LifeCycles
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
    
    func fetchUserProfile() async {
        do {
            guard let image = try? await UserProfileImageService.fetchUserProfile(userProfile: post.ownerImageUrl) else { throw FetchUserError.invalidUserProfileImage }
            DispatchQueue.main.async {
                self.userProfile = image
            }
        } catch FetchUserError.invalidUserProfileImage {
            print("DEBUG: Failure fetch owner profile image in PostViewModel")
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
    
    var postedUserProfile: UIImage? {
        get {
            guard let profile = userProfile else {
                print("DEBUG: postVM's userProfile can't bind.")
                return nil
            }
            return profile
        }
    }
    
    var caption: String {
        get {
            return post.caption
        }
    }
    
    var username: String {
        get {
            return post.ownerUsername
        }
    }
    
    var postTime: Timestamp {
        get {
            return post.timestamp
        }
    }
    
    var ownerImageUrl: String {
        get {
            return post.ownerImageUrl
        }
    }
    
    var likes: Int {
        get {
            return post.likes
        }
    }
    
    var postLikes: String {
        get {
            return likes < 2 ? "\(likes) like" : "\(likes) likes"
        }
    }
    
    var didLike: Bool {
        get {
            guard let didLike = post.didLike else { return false }
            return didLike
        }
    }

    func setupLike(button: UIButton) {
        if !didLike {
            button.setImage(.imageLiteral(name: "like_selected"), for: .normal)
            button.tintColor = .red
            post.likes += 1
        }else {
            button.setImage(.imageLiteral(name: "like_unselected"), for: .normal)
            button.tintColor = .black
            post.likes -= 1
        }
    }
}
