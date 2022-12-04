//
//  ProfileController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine

class ProfileController: UICollectionViewController {
    
    //MARK: - properties
    let vm: ProfileViewModel
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Lifecycle
    init(user: UserInfoModel) {
        vm = ProfileViewModel(userInfo: user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        navigationItem.title = user.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.fetchUserStats()
    }

}

//MARK: - Helpers
extension ProfileController {
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: CELLREUSEABLEID)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: COLLECTIONHEADERREUSEABLEID)
    }
    
    func setupBindings() {
        vm.$user.sink { _ in
            self.collectionView.reloadData()
        }.store(in:&subscriptions)
        
        vm.$userStats.sink{ _ in
            self.collectionView.reloadData()
        }.store(in: &subscriptions)
        
        vm.$profileImage.sink{ _ in
            self.collectionView.reloadData()
        }.store(in: &subscriptions)
        
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
        headerView.userVM = ProfileHeaderViewModel(user: self.vm.user, profileImage: self.vm.profileImage, userStats: vm.userStats )
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
                    self.vm.user.isFollowed = false
                    UserService.fetchUserStats(uid: user.uid) { stats in
                        self.vm.userStats = stats
                        self.collectionView.reloadData()
                    }
                }
            }
        }else {
            DispatchQueue.main.async {
                UserService.follow(uid: user.uid) { _ in
                    self.vm.user.isFollowed = true
                    UserService.fetchUserStats(uid: user.uid) { stats in
                        self.vm.userStats = stats
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
