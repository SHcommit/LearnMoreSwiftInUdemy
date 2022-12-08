//
//  ProfileViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import Foundation

protocol ProfileViewModelType {
    func fetchData()
}

protocol ProfileViewModelAPIType {
    func fetchToCheckIfUserIsFollowed()
    func fetchUserStats()
    func fetchImage(profileUrl url: String) async
    func fetchImageFromUserProfileImageService(url: String) async throws
    func fetchImageErrorHandling(withError error: Error)
}
