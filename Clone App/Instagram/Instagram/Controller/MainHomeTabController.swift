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
            Task() {
                await isLoginConfigure()
            }
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
    
    func isLoginConfigure() async {
        guard let isLogin = isLogin else { return }
        if !isLogin {
            DispatchQueue.main.async {
                self.presentLoginScene()
            }
        }else {
            guard let _ = userVM else {
                await fetchCurrentUserInfo()
                return
            }
        }
    }
    
    func configureViewControllers() {
        guard let userVM = userVM else { return }
        
        let layout = UICollectionViewFlowLayout()
        let feedVC = FeedController(collectionViewLayout: layout)
        feedVC.fetchPosts()
        let feed = templateNavigationController(unselectedImage: .imageLiteral(name: "home_unselected"), selectedImage: .imageLiteral(name: "home_selected"), rootVC: feedVC)
        let searchVC = SearchController(viewModel: SearchViewModel())
        let search = templateNavigationController(unselectedImage: .imageLiteral(name: "search_unselected"), selectedImage: .imageLiteral(name: "search_selected"), rootVC: searchVC)
        
        let imageSelector = templateNavigationController(unselectedImage: .imageLiteral(name: "plus_unselected"), selectedImage: .imageLiteral(name: "plus_unselected"), rootVC: ImageSelectorController())
        let notifications = templateNavigationController(unselectedImage: .imageLiteral(name: "like_unselected"), selectedImage: .imageLiteral(name: "like_selected"), rootVC: NotificationController())
        
        let profileVC = ProfileController(viewModel: ProfileViewModel(user: userVM.userInfoModel()))
        
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
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let vc = UploadPostController()
                vc.selectedImage = selectedImage
                vc.didFinishDelegate = self
                vc.currentUserInfo = self.userVM?.userInfoModel()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
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
    
    func fetchUserInfo(withUID uid: String) async {
        do{
            try await fetchUserInfoFromUserService(withUID: uid)
        }catch {
            fetchUserInfoErrorHandling(withError: error)
        }
    }
    func fetchUserInfoErrorHandling(withError error: Error) {
        switch error {
        case FetchUserError.invalidUserInfo:
            print("DEBUG: Fail to bind userInfo instance.")
        case FetchUserError.invalidGetDocumentUserUID:
            print("DEBUG: Fail to get user document with UID.")
        default:
            print("DEBUG: An error occured: \(error.localizedDescription)")
        }

    }
    
    func fetchCurrentUserInfo() async {
        do {
            try await fetchUserInfoFromUserService()
        } catch {
            fetchCurrentUserInfoErrorHandling(withError: error)
        }
    }
    func fetchUserInfoFromUserService(withUID uid: String? = nil) async throws {
        guard let uid = uid else {
            guard let userInfo = try await UserService.fetchCurrentUserInfo() else { throw FetchUserError.invalidUserInfo }
            DispatchQueue.main.async {
                self.userVM = UserInfoViewModel(user: userInfo)
            }
            return
        }
        guard let userInfo = try await UserService.fetchUserInfo(withUid: uid) else { throw FetchUserError.invalidUserInfo }
        self.userVM = UserInfoViewModel(user: userInfo, profileImage: nil)
    }
    func fetchCurrentUserInfoErrorHandling(withError error: Error) {
        switch error {
        case FetchUserError.invalidUserInfo:
            print("DEBUG: Fail to bind userInfo instance.")
        case FetchUserError.invalidGetDocumentUserUID:
            print("DEBUG: Fail to get user document with UID. 이경우 로그인됬는데 uid를 찾을 수 없음 -> 파이어베이스 사용자 UID 잘못 등록됨.")
            DispatchQueue.main.async {
                self.presentLoginScene()
            }
        case SystemError.invalidCurrentUserUID:
            print("DEBUG: Fail to find user's UID value")
        case SystemError.invalidAppDelegateInstance:
            print("DEBUG: Fail to bind AppDelegate instance")
        default:
            print("DEBUG: An error occured: \(error.localizedDescription)")
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
        let controller = LoginController(viewModel: LoginViewModel())
        controller.authDelegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
        
}

//MARK: - Implement AuthentificationDelegate
extension MainHomeTabController: AuthentificationDelegate {
    
    func authenticationCompletion(uid: String) async {
        let ud = UserDefaults.standard
        ud.synchronize()
        ud.set(uid, forKey: CURRENT_USER_UID)
        do{
            try await fetchCurrentUserInfo(withUID: uid)
            endIndicator(indicator: indicator)
        }catch {
            authenticationCompletionErrorHandling(error: error)
        }
        self.dismiss(animated: false)
    }
    
    func fetchCurrentUserInfo(withUID id: String) async throws {
        let userInfo = try await UserService.fetchUserInfo(withUid: id)
        guard let userInfo = userInfo else { throw FetchUserError.invalidUserInfo }
        self.userVM = UserInfoViewModel(user: userInfo, profileImage: nil)
    }
    
    func authenticationCompletionErrorHandling(error: Error) {
        switch error {
        case FetchUserError.invalidGetDocumentUserUID:
            print("DEBUG: Fail to get user document with UID 이경우 로그인됬는데 uid를 찾을 수 없음 -> 파이어베이스 사용자 UID 잘못 등록됨.")
            DispatchQueue.main.async {
                self.presentLoginScene()
            }
        case FetchUserError.invalidUserInfo:
            print("DEBUG: Fail to bind userInfo")
        default:
            print("DEBUG: Unexpected error occured: \(error.localizedDescription)")
        }
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


//MARK: - UploadPostControllerDelegate
extension MainHomeTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true)
        guard let feedNavi = viewControllers?.first as? UINavigationController else { return }
        guard let feedVC = feedNavi.viewControllers.first as? FeedController else { return }
        feedVC.handleRefresh()
        
    }
    
    
}
