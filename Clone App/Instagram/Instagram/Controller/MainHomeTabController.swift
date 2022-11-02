//
//  MainTabController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Firebase

class MainHomeTabController: UITabBarController {
    
    //MARK: - Properties
    private var userVM: UserInfoViewModel? {
        didSet {
            configureViewControllers()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
    }
    
}

//MARK: - Helpers
extension MainHomeTabController {
    
    func configure() {
        customTabBarUI()
        fetchUserInfo()
        checkIfUserIsLoggedIn()
    }
    
    func configureViewControllers() {
        guard let userVM = userVM else { return }
        
        let layout = UICollectionViewFlowLayout()
        
        let feed = templateNavigationController(unselectedImage: .imageLiteral(name: "home_unselected"), selectedImage: .imageLiteral(name: "home_selected"), rootVC: FeedController(collectionViewLayout: layout))

        let search = templateNavigationController(unselectedImage: .imageLiteral(name: "search_unselected"), selectedImage: .imageLiteral(name: "search_selected"), rootVC: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: .imageLiteral(name: "plus_unselected"), selectedImage: .imageLiteral(name: "plus_unselected"), rootVC: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: .imageLiteral(name: "like_unselected"), selectedImage: .imageLiteral(name: "like_selected"), rootVC: NotificationController())
        
        var profileVC = ProfileController(user: userVM.getUserInfoModel())
        UserService.fetchUserProfile(userProfile: userVM.getUserProfileURL()) { image in
            profileVC.profileImage = image
        }
        let profile = templateNavigationController(unselectedImage: .imageLiteral(name: "profile_unselected"), selectedImage: .imageLiteral(name: "profile_selected"), rootVC: profileVC)
        
        viewControllers = [feed,search,imageSelector,notifications,profile]
    }
    
    
}

//MARK: - Setup NavigationController Helpers
extension MainHomeTabController {
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        setupNavigationAppearance(nav: nav)
        return nav
    }
    
    func setupNavigationAppearance(nav: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
    }
    
}

//MARK: - Setup tabBar UI
extension MainHomeTabController {
    
    func customTabBarUI() {
        setupTabBarAppearance()
        setupTabBarTintColor()
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func setupTabBarTintColor() {
        tabBar.tintColor = .black
    }
    
}

//MARK: - API.
extension MainHomeTabController {
    
    //MARK: - API. About User
    func fetchUserInfo() {
        UserService.fetchCurrentUserInfo() { userInfo in
            guard let userInfo = userInfo else { return }
            self.userVM = UserInfoViewModel(user: userInfo, profileImage: nil)
        }
    }
    
    
    
    //MARK: - API. check user's membership
    func checkIfUserIsLoggedIn() {
        if CURRENT_USER == nil {
            self.view.isHidden = true
            self.presentLoginScene()
        }
    }
    
    func presentLoginScene() {
        let controller = LoginController()
        controller.authDelegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
    
        
}

//MARK: - Implement AuthentificationDelegate
extension MainHomeTabController: AuthentificationDelegate {
    func authenticationCompletion() {
        fetchUserInfo()
        self.dismiss(animated: false)
    }
    
    
}
