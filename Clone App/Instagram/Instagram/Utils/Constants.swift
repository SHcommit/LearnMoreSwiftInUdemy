//
//  Constants.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/31.
//

import Firebase

//MARK: - Constant properties
let USERPROFILEIMAGEMEGABYTE = Int64(1*400*400)
let FIRESTORE_USERS = "users"
let COLLECTION_USERS = Firestore.firestore().collection(FIRESTORE_USERS)
let FIRESTORE_DB = Firestore.firestore()
let CURRENT_USER = Auth.auth().currentUser
let STORAGE = Storage.storage()
let AUTH = Auth.auth()


//MARK: - profile subview's ID
let COLLECTIONHEADERREUSEABLEID = "UserProfileCollectionHeaderView"
let CELLREUSEABLEID = "CollectionViewCell"
