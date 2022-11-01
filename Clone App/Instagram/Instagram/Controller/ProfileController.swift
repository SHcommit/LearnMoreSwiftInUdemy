//
//  ProfileController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    //MARK: - properties
    private let collectionHeaderReusableID = "UserProfileCollectionHeaderView"
    private let cellReusableId = "CollectionViewCell"
    private var user: UserInfoModel? {
        didSet {
            collectionView.reloadData()
            navigationItem.titleView?.reloadInputViews()
        }
    }
    private var profileImage: UIImage? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        initialUser()
    }
}

//MARK: - Helpers
extension ProfileController {
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellReusableId)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHeaderReusableID)
    }
    
    func initialUser() {
        UserService.fetchCurrentUserInfo() { user in
            guard let user = user else { return }
            self.user = user
            self.navigationItem.title = user.username
            UserService.fetchUserProfile(userProfile: user.profileURL) { image in
                self.profileImage = image
            }
        }
    }
}


//MARK: - UICollectionViewDataSource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableId, for: indexPath) as? ProfileCell else { fatalError() }
        cell.backgroundColor = .systemPink
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHeaderReusableID, for: indexPath) as? ProfileHeader else { fatalError() }
        
        guard let user = user else { return headerView }
        guard let profileImage = profileImage else { return headerView }
        headerView.userVM = UserInfoViewModel(user: user, profileImage: profileImage)
        
        return headerView
    }

    
}

//MARK: - UICollectionViewDelegate
extension ProfileController {
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-2)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height/7 * 2)
    }
    
}
