//
//  PostModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/12.
//

import UIKit
import Firebase

struct PostModel: Codable {
    var caption: String
    var timestamp: Timestamp
    var likes: Int
    var imageUrl: String
    var ownerUid: String
    var postId: String?
    
//    enum CodingKeys: String, CodingKey {
//        case caption
//        case timestamp
//        case likes
//        case imageUrl
//        case ownerUid
//        case postId
//    }
    
}

//extension PostModel: Decodable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        caption = try container.decode(String.self, forKey: .caption)
//        timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
//        likes = try container.decode(Int.self, forKey: .likes)
//        imageUrl = try container.decode(String.self, forKey: .imageUrl)
//        ownerUid = try container.decode(String.self, forKey: .ownerUid)
//        postId = try container.decodeIfPresent(String.self, forKey: .postId) ?? ""
//    }
//}
//
//
//extension PostModel: Encodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(caption, forKey: .caption)
//        try container.encode(timestamp, forKey: .timestamp)
//        try container.encode(likes, forKey: .likes)
//        try container.encode(imageUrl, forKey: .imageUrl)
//        try container.encode(ownerUid, forKey: .ownerUid)
//    }
//}
