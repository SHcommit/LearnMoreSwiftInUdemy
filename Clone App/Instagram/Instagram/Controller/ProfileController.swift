//
//  ProfileController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    //MARK: - properties
    private var user: UserInfoModel
    var profileImage: UIImage? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    init(user: UserInfoModel) {
        self.user = user
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        guard let profileImage = profileImage else {
            DispatchQueue.main.async {
                headerView.userVM = ProfileHeaderViewModel(user: self.user)
            }
            return headerView    
        }
        headerView.userVM = ProfileHeaderViewModel(user: self.user, profileImage: profileImage)
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
