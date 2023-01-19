//
//  FeedController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine
import Firebase

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    var posts = [PostModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var subscriptions = Set<AnyCancellable>()
    
    // specific user's specific CollectionViewcell post info
    var post: PostModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FEEDCELLRESUIDENTIFIER  )
        fetchPosts()
        checkIfUserLikePosts()
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
        let controller = LoginController(viewModel: LoginViewModel())
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
    func checkIfUserLikePosts() {
        self.posts.forEach { post in
            Task() {
                let didLike = await PostService.checkIfUserLikedPost(post: post)
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
}

//MARK: - API
extension FeedController {
    func fetchPosts() {
        guard post == nil else { return }
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
    
    @objc func cancel() {
        navigationController?.popViewController(animated: false)
    }
}

//MARK: - UICollectionView DataSource
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post != nil ? 1 : posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FEEDCELLRESUIDENTIFIER, for: indexPath) as? FeedCell else {
            fatalError()
        }
        guard let tab = tabBarController as? MainHomeTabController else { fatalError() }
        let user = tab.vm.user
        if let post = post {
            cell.viewModel = FeedViewModel(post: post, user: user)
        }else {
            cell.viewModel = FeedViewModel(post: posts[indexPath.row], user: user)
        }
        cell.configure()
        cell.setupBinding(with: navigationController)
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
        guard let _ = navigationItem.leftBarButtonItem else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(handleLogout))
            return
        }
        
    }
    
    func setupPrevBarButton() {
        let back = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = back
    }
    
}
