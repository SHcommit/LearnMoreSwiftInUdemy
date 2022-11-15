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
        setupUI()
    }
    
}

//MARK: - Helpers
extension FeedController {
    
    func setupUI() {
        setupNavigationUI()
        setupRefreshUI()
        view.backgroundColor = .white
    }
    
    func setupNavigationUI() {
        setupLogoutBarButton()
        navigationItem.title = "Feed"
    }
    
    func setupRefreshUI() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresh
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
                var posts = try await PostService.fetchPosts()
                posts.sort() {
                    $0.timestamp.seconds > $1.timestamp.seconds
                }
                
                DispatchQueue.main.async {
                    self.posts = posts
                    print("DEBUG: Did refresh feed posts")
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
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
    
    @objc func handleRefresh() {
        posts.removeAll()
        collectionView.reloadData()
        fetchPosts()
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
        DispatchQueue.main.async {
            cell.configure()
        }
        Task() {
            await cell.viewModel?.fetchPostImage()
            await cell.viewModel?.fetchUserProfile()
            DispatchQueue.main.async {
                cell.configurePostImage()
                cell.configureProfileImage()
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
