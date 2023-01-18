//
//  ServiceProvider.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import Foundation


class ServiceProvider {
    let userCase: UserServiceType
    let authCase: AuthServiceType
    let imageCase: UserProfileImageServiceType
    let postCase: PostServiceType
    let notificationCase: NotificationServiceType
    let commentCase: CommentServiceType
    
    init(userCase: UserServiceType, authCase: AuthServiceType,
         imageCase: UserProfileImageServiceType, postCase: PostServiceType,
         notificationCase: NotificationServiceType, commentCase: CommentServiceType) {
        self.userCase = userCase
        self.authCase = authCase
        self.imageCase = imageCase
        self.postCase = postCase
        self.notificationCase = notificationCase
        self.commentCase = commentCase
    }
    
    static func defaultProvider() -> ServiceProvider  {
        return ServiceProvider(userCase: UserService(),
                               authCase: AuthService(),
                               imageCase: UserProfileImageService(),
                               postCase: PostService(),
                               notificationCase: NotificationService(),
                               commentCase: CommentService())
    }
}
