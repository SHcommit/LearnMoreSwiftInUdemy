//
//  MainTabController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Firebase
import YPImagePicker

class MainHomeTabController: UITabBarController {
    
    //MARK: - Properties
    private var userVM: UserInfoViewModel? {
        didSet {
            configureViewControllers()
        }
    }
    
    var getUserVM: UserInfoViewModel? {
        get {
            return self.userVM
        }
        set (newUser) {
            self.userVM = newUser
        }
    }
    
    private var isLogin: Bool? {
        didSet {
            isLoginConfigure()
        }
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        
    }
    
} 

//MARK: - Helpers
extension MainHomeTabController {
    
    func configure() {
        customTabBarUI()
        isLogin = isUserLogined()
        delegate = self
    }
    
    func isLoginConfigure() {
        guard let isLogin = isLogin else { return }
        if !isLogin {
            DispatchQueue.main.async {
                self.presentLoginScene()
            }
        }else {
            guard let userVM = userVM else {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.pList.synchronize()
                guard let currentUserUID = appDelegate.pList.string(forKey: CURRENT_USER_UID) else { return }
                        
                fetchUserInfo(withUID: currentUserUID)
                return
            }
        }
    }
    
    func configureViewControllers() {
        guard let userVM = userVM else { return }
        
        let layout = UICollectionViewFlowLayout()
        
        let feed = templateNavigationController(unselectedImage: .imageLiteral(name: "home_unselected"), selectedImage: .imageLiteral(name: "home_selected"), rootVC: FeedController(collectionViewLayout: layout))

        let search = templateNavigationController(unselectedImage: .imageLiteral(name: "search_unselected"), selectedImage: .imageLiteral(name: "search_selected"), rootVC: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: .imageLiteral(name: "plus_unselected"), selectedImage: .imageLiteral(name: "plus_unselected"), rootVC: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: .imageLiteral(name: "like_unselected"), selectedImage: .imageLiteral(name: "like_selected"), rootVC: NotificationController())
        
        let profileVC = ProfileController(user: userVM.userInfoModel())
        DispatchQueue.main.async {
            UserService.fetchUserProfile(userProfile: userVM.profileURL()) { image in
                profileVC.profileImage = image
            }
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

//MARK: - Event Handler
extension MainHomeTabController {
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let vc = UploadPostController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
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
    func fetchUserInfo(withUID uid: String) {
        UserService.fetchUserInfo(withUid: uid) { userInfo in
            guard let userInfo = userInfo else { return }
            self.userVM = UserInfoViewModel(user: userInfo, profileImage: nil)
        }
    }
    
    //MARK: - API. check user's membership
    func isUserLogined() -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        appDelegate.pList.synchronize()
        let currentUserUid = appDelegate.pList.string(forKey: CURRENT_USER_UID)
        
        if Auth.auth().currentUser == nil || currentUserUid == nil{
            return false
        }
        return true
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
    func authenticationCompletion(uid: String) {
        guard let appDelegaet = UIApplication.shared.delegate as? AppDelegate else  { return }
        appDelegaet.pList.set(uid, forKey: CURRENT_USER_UID)
        
        UserService.fetchUserInfo(withUid: uid) { userInfo in
            guard let userInfo = userInfo else { return }
            self.userVM = UserInfoViewModel(user: userInfo, profileImage: nil)
        }
        self.dismiss(animated: false)
    }
    
}

//MAKR: -  UITabBarControllerDelegate
extension MainHomeTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            didFinishPickingMedia(picker)
        }
        return true
    }
}
