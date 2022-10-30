//
//  MainTabController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Firebase

class MainHomeTabController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        customTabBarUI()
        checkIfUserIsLoggedIn()
    }
    
}


//MARK: - Helpers
extension MainHomeTabController {
    func configureViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let profileLayout = layout
        
        let feed = templateNavigationController(unselectedImage: .imageLiteral(name: "home_unselected"), selectedImage: .imageLiteral(name: "home_selected"), rootVC: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: .imageLiteral(name: "search_unselected"), selectedImage: .imageLiteral(name: "search_selected"), rootVC: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: .imageLiteral(name: "plus_unselected"), selectedImage: .imageLiteral(name: "plus_unselected"), rootVC: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: .imageLiteral(name: "like_unselected"), selectedImage: .imageLiteral(name: "like_selected"), rootVC: NotificationController())
        
        
        let profile = templateNavigationController(unselectedImage: .imageLiteral(name: "profile_unselected"), selectedImage: .imageLiteral(name: "profile_selected"), rootVC: ProfileController(collectionViewLayout: profileLayout))
        
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

//MARK: - API. check user's membership
extension MainHomeTabController {
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.view.isHidden = true
                self.presentLoginScene()
            }
        }
    }
}

//MARK: - Refactoring
extension UIImage {
    static func imageLiteral(name: String) -> UIImage {
        return UIImage(imageLiteralResourceName: name)
    }
    
}
