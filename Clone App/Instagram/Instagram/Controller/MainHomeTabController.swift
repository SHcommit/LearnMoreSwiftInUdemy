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
    }
    
    func isLoginConfigure() async {
        guard let isLogin = isLogin else { return }
        if !isLogin {
            DispatchQueue.main.async {
                self.presentLoginScene()
            }
        }else {
            guard let userVM = userVM else {
                await fetchCurrentUserInfo()
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
        
        Task() {
            await fetchImage(profileVC: profileVC, profileUrl: userVM.profileURL())
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
    
    func fetchImage(profileVC vc: ProfileController, profileUrl url: String) async {
        do {
            let image = try await UserProfileImageService.fetchUserProfile(userProfile: url)
            DispatchQueue.main.async {
                vc.profileImage = image
            }
        } catch {
            fetchImageErrorHandling(withError: error)
        }
    }
    func fetchImageErrorHandling(withError error: Error) {
        switch error {
        case FetchUserError.invalidUserProfileImage :
            print("DEBUG: Failure invalid user profile image instance")
        default:
            print("DEBUG: Unexpected error occured  :\(error.localizedDescription)")
        }
    }

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
            print("DEBUG: Fail to get user document with UID.")
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
        let controller = LoginController()
        controller.authDelegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
        
}

//MARK: - Implement AuthentificationDelegate
extension MainHomeTabController: AuthentificationDelegate {
    func authenticationCompletion(uid: String) async {
        guard let appDelegaet = UIApplication.shared.delegate as? AppDelegate else  { return }
        appDelegaet.pList.set(uid, forKey: CURRENT_USER_UID)
        
        do{
            let userInfo = try await UserService.fetchUserInfo(withUid: uid)
            guard let userInfo = userInfo else { return }
            self.userVM = UserInfoViewModel(user: userInfo, profileImage: nil)
        }catch FetchUserError.invalidGetDocumentUserUID {
            print("DEBUG: Fail to get user document with UID.")
        }catch {
            print("DEBUG: Ocurred error \(error.localizedDescription)")
        }
        self.dismiss(animated: false)
    }
    
}
