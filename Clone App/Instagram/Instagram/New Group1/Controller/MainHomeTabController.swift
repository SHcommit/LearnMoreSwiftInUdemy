//
//  MainTabController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit

class MainHomeController: UIViewController {
    
    var tabBar: UITabBar?
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
        view.backgroundColor = .red
    }
}

//MARK: - TabBar delegate
extension MainHomeController: UITabBarDelegate {
    
}


//MARK: - Helpers
extension MainHomeController {
    func configureViewControllers() {
        
        let feed = FeedController()
        let search = SearchController()
        let imageSelector = ImageSelectorController()
        let notifications = NotificationController()
        let 
    }
}

//MARK: - Setup tabBar
extension MainHomeController {
    
    func setupTabBarUI() {
        initialTabBar()
        setupTabBarAppearance()
        setupTabBarConstraints()
    }
    
    func initialTabBar() {
        tabBar = UITabBar()
        guard let tabBar = tabBar else {
            return
        }
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        tabBar?.standardAppearance = appearance
        tabBar?.scrollEdgeAppearance = appearance
    }
    
    func setupTabBarConstraints() {
        guard let tabBar = tabBar else {
            return
        }
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
}
