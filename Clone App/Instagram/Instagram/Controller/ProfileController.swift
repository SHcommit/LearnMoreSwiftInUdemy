//
//  ProfileController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    //MARK: - properties
    let vm: ProfileViewModel
    var user: UserInfoModel
    private var userStats: Userstats? {
        didSet {
            collectionView.reloadData()
        }
    }
    var profileImage: UIImage? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    init(user: UserInfoModel) {
        self.user = user
        vm = ProfileViewModel(userInfoModel: user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        navigationItem.title = user.username
    }
    
    convenience init(profileVM: ProfileHeaderViewModel) {
        self.init(user: profileVM.getUserInfo())
        profileImage = profileVM.image()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserStats()
        collectionView.reloadData()
    }

}

//MARK: - Helpers
extension ProfileController {
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: CELLREUSEABLEID)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: COLLECTIONHEADERREUSEABLEID)
    }
    
    func observe() {
        vm.$user.recei
        
    }
    
}

//MARK: - API
extension ProfileController {
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowd(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
            
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.userStats = stats
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLREUSEABLEID, for: indexPath) as? ProfileCell else { fatalError() }
        cell.backgroundColor = .systemPink
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: COLLECTIONHEADERREUSEABLEID, for: indexPath) as? ProfileHeader else { fatalError() }
        headerView.delegate = self
        headerView.userVM = ProfileHeaderViewModel(user: self.user, profileImage: self.profileImage, userStats: userStats )
        return headerView
    }

    
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

//MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: UserInfoModel) {
        
        if user.isCurrentUser {
            print("DEBUG: Show edit profile here..")
        }else if user.isFollowed {
            DispatchQueue.main.async {
                UserService.unfollow(uid: user.uid) { _ in
                    self.user.isFollowed = false
                    UserService.fetchUserStats(uid: user.uid) { stats in
                        self.userStats = stats
                        self.collectionView.reloadData()
                    }
                }
            }
        }else {
            DispatchQueue.main.async {
                UserService.follow(uid: user.uid) { _ in
                    self.user.isFollowed = true
                    UserService.fetchUserStats(uid: user.uid) { stats in
                        self.userStats = stats
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
