//
//  FeedController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Firebase

class FeedController: UICollectionViewController {
    
    private let reuseIdentifier = "FeedCell"
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier  )
        setupUI()
        
    }
}

//MARK: - Helpers
extension FeedController {
    
    func setupUI() {
        view.backgroundColor = .white
        setupLogoutBarButton()
        navigationItem.title = "Feed"
    }
}

//MARK: - UICollectionView DataSource
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCell else {
            fatalError()
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = view.frame.width
        var cellHeight = cellWidth + 8 + 40 + 8
        
        cellHeight += 50
        cellHeight += 60
        
        return CGSize(width: view.frame.width, height: cellHeight)
    }
 }


//MARK: - UINavigationController configure
extension FeedController {
    func setupLogoutBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleLogout)
                                                       )
    }
}


//MARK: - Event handler
extension FeedController {
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.presentLoginScene()
            }
        } catch {
            print("Failed to sign out")
        }
    }
}
