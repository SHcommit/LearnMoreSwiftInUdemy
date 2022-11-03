//
//  SearchUserViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/03.
//

import Foundation

class SearchUserViewModel {
    
    //MARK: - Properties
    private var users = [UserInfoModel]()
    
    //MARK: - LifeCycle
    init(users: [UserInfoModel] = [UserInfoModel]()) {
        self.users = users
    }
}


//MARK: - get/set UserInfo
extension SearchUserViewModel{
    
    
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
    
    func cellForRowAt(_ index: Int) -> UserInfoModel {
        return users[index]
    }
}
