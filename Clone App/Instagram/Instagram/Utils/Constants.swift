//
//  Constants.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/31.
//

import Firebase

// Constant properties

//MARK: - profile subview's ID
let COLLECTIONHEADERREUSEABLEID = "UserProfileCollectionHeaderView"
let CELLREUSEABLEID = "CollectionViewCell"


//MARK:  - FeedVieController subview's Identifier
let FEEDCELLRESUIDENTIFIER = "FeedCell"

//MARK: - SearchController subview's Identifier
let REUSE_SEARCH_TABLE_CELL_IDENTIFIER = "UserCell"
let SEARCHED_USER_CELL_PROFILE_WIDTH: CGFloat = 60
let SEARCHED_USER_CELL_PROFILE_MARGIN: CGFloat = 7
let SEARCHED_USER_CELL_FONT_SIZE: CGFloat = 16
let SEARCHED_USER_CELL_STACKVIEW_SPACING: CGFloat = 4


//MARK: - UserService
typealias FiresotreCompletion = (Error?) -> Void
let FIRESTORE_USERS = "users"
let COLLECTION_USERS = Firestore.firestore().collection(FIRESTORE_USERS)
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let FIRESTORE_DB = Firestore.firestore()
let STORAGE = Storage.storage()
let AUTH = Auth.auth()
let USERPROFILEIMAGEMEGABYTE = Int64(1*1024*1024)


//MARK: - UserDefaults
let CURRENT_USER_UID = "currentUserUID"


//MARK: - UploadPostController
let UPLOAD_POST_PHOTO_IMAGE_VIEW_SIZE: CGFloat = 180

let UPLOAD_POST_CONTENT_TOP_MARGIN: CGFloat = 16
let UPLOAD_POST_CONTENT_SIDE_MARGIN: CGFloat = 12
let UPLOAD_POST_CONTENT_VIEW_SIZE: CGFloat = 64


//MARK: - InputTextView
let INPUT_TEXT_VIEW_DEFAULT_MARGIN: CGFloat = 4


//MARK: - PostService
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
