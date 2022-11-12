//
//  FeedController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Firebase

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    private var posts = [PostModel]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FEEDCELLRESUIDENTIFIER  )
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUI()
    }
    
}

//MARK: - Helpers
extension FeedController {
    
    func setupUI() {
        setupNavigationUI()
        view.backgroundColor = .white
    }
    
    func setupNavigationUI() {
        setupLogoutBarButton()
        navigationItem.title = "Feed"
    }
    
    func presentLoginScene() {
        let controller = LoginController()
        controller.authDelegate = tabBarController as? MainHomeTabController
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
    
}

//MARK: - API
extension FeedController {
    func fetchPosts() {
        Task() {
            do {
                let posts = try await PostService.fetchPosts()
                DispatchQueue.main.async {
                    self.posts = posts
                    self.collectionView.reloadData()
                }
            } catch {
                switch error {
                default:
                    print("DEBUG: Unexpected error occured: \(error.localizedDescription)")
                }
            }
        }
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

//MARK: - UICollectionView DataSource
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FEEDCELLRESUIDENTIFIER, for: indexPath) as? FeedCell else {
            fatalError()
        }
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        Task() {
            await cell.viewModel?.fetchPostImage()
            DispatchQueue.main.async {
                cell.configure()
            }
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
