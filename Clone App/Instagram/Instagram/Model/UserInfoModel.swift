//
//  UserInfoViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/28.
//

struct UserInfoModel: Codable {
    var email: String
    var fullname: String
    var profileURL: String
    var uid: String
    var username: String
    var isFollowed = false
    var isCurrentUser: Bool {
        return CURRENT_USER?.uid == uid
    }
    
    enum CodingKeys: String,CodingKey {
        case email
        case fullname
        case profileURL = "profileImageUrl"
        case uid
        case username
    }
}

//MARK: - Decodable
extension UserInfoModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        fullname = try container.decode(String.self, forKey: .fullname)
        profileURL = try container.decode(String.self, forKey: .profileURL)
        uid = try container.decode(String.self, forKey: .uid)
        username = try container.decode(String.self, forKey: .username)
    }

}

//MARK: - Encodable
extension UserInfoModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(uid, forKey: .uid)
        try container.encode(profileURL, forKey: .profileURL)
        try container.encode(fullname, forKey: .fullname)
        try container.encode(username, forKey: .username)
    }
}
