//
//  SearchUserViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/03.
//

import UIKit

class SearchUserViewModel {
    
    //MARK: - Properties
    private var users = [UserInfoModel]()
    //MARK: - LifeCycle
    init(users: [UserInfoModel] = [UserInfoModel]()) {
        self.users = users
    }
}

//MARK: - get/set
extension SearchUserViewModel {
    
    func getUserInfoModel() -> [UserInfoModel] {
        return users
    }
}

//MARK: - Return tableViewDataSource
extension SearchUserViewModel {
    
    func numberOfRowsInSection(_ section: Int = 0) -> Int {
        if section == 0 {
            return users.count
        }else {
            return 0
        }
    }
    
    func cellForRowAt(_ index: Int) -> UserInfoViewModel {
        let user = users[index]
        let userVM = UserInfoViewModel(user: user, profileImage: nil)
        DispatchQueue.main.async {
            userVM.initProfileImage()
        }
        return userVM
    }
}
