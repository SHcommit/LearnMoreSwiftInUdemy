//
//  MainTabController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class MainHomeTabController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureViewControllers()
        customTabBarUI()
    }
}

//MARK: - TabBar delegate
extension MainHomeTabController {
    
}


//MARK: - Helpers
extension MainHomeTabController {
    func configureViewControllers() {
        
        let feed = FeedController()
        let search = SearchController()
        let imageSelector = ImageSelectorController()
        let notifications = NotificationController()
        let profile = ProfileController()
        
        viewControllers = [feed,search,imageSelector,notifications,profile]
    }
}

//MARK: - Setup tabBar
extension MainHomeTabController {
    
    func customTabBarUI() {
        setupTabBarAppearance()
        //setupTabBarConstraints()
    }
    
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemYellow
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
//    func setupTabBarConstraints() {
//        NSLayoutConstraint.activate([
//            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
//    }
    
}
