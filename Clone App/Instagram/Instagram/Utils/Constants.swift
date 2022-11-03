//
//  Constants.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/31.
//

import Firebase

//MARK: - Constant properties
let USERPROFILEIMAGEMEGABYTE = Int64(1*1024*1024)
let FIRESTORE_USERS = "users"
let COLLECTION_USERS = Firestore.firestore().collection(FIRESTORE_USERS)
let FIRESTORE_DB = Firestore.firestore()
let CURRENT_USER = Auth.auth().currentUser
let STORAGE = Storage.storage()
let AUTH = Auth.auth()


//MARK: - profile subview's ID
let COLLECTIONHEADERREUSEABLEID = "UserProfileCollectionHeaderView"
let CELLREUSEABLEID = "CollectionViewCell"


//MARK:  - FeedVieController subview's Identifier
let FEEDCELLRESUIDENTIFIER = "FeedCell"

//MARK: - SearchController subview's Identifier
let REUSE_SEARCH_TABLE_CELL_IDENTIFIER = "UserCell"
