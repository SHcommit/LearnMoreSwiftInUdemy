//
//  ApiConstants.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import Foundation
import Firebase

enum FirestoreCollectionType {
  case followers
  case following
  case notifications
  case posts
  case users
}
extension FirestoreCollectionType: CustomStringConvertible {
  var description: String {
    switch self {
    case .followers: return "followers"
    case .following: return "following"
    case .notifications: return "notifications"
    case .posts: return "posts"
    case .users: return "users"
    }
  }
  
}

/// FirestoreConstant
struct FSConstants {
  
  private static var db: Firestore {
    return Firestore.firestore()
  }
  
  static func ref(_ info: FirestoreCollectionType)-> CollectionReference {
    return db.collection(info.description)
  }
  
  static var auth: Auth {
    return Auth.auth()
  }
  
  static var user: User? {
    return auth.currentUser
  }
}
