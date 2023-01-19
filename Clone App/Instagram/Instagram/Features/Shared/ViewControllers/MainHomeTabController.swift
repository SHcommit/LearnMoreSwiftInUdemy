//
//  MainTabController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine
import Firebase
import YPImagePicker

class MainHomeTabController: UITabBarController {
    
    //MARK: - Properties
    var vm: MainHomeTabViewModelType
    var appear = PassthroughSubject<Void,Never>()
    var subscriptions = Set<AnyCancellable>()
    
//    private var isLogin: Bool? {
//        didSet {
//            Task() {
//                await isLoginConfigure()
//            }
//        }
//    }
    
    
    //MARK: - Lifecycle
    init(vm: MainHomeTabViewModelType) {
        self.vm = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        
    }
    
}

//MARK: - Bind
extension MainHomeTabController {
    
    fileprivate func setupBindings() {
        _=subscriptions.map{$0.cancel()}
        subscriptions.removeAll()
        
        let input = MainHomeTabViewModelInput(appear: appear.eraseToAnyPublisher())
        let output = vm.transform(with: input)
        output.sink { _ in
            print("DEBUG: MainHomeTabController's transform complete.")
        } receiveValue: {
            self.render($0)
        }.store(in: &subscriptions)
    }
    
    fileprivate func render(_ state: MainHomeTabControllerState) {
        switch state {
        case .none:
            break
        case .fetchUserInfoIsCompleted:
            configureViewControllers()
            break
        }
    }
}

//MARK: - Helpers
extension MainHomeTabController {
    
    func configure() {
        customTabBarUI()
        //isLogin = isUserLogined()
        delegate = self
    }
    
    // 유저 로그인 기능은 메인 코디네이터에서 담당할거
//    func isLoginConfigure() async {
//        guard let isLogin = isLogin else { return }
//        if !isLogin {
//            DispatchQueue.main.async {
//                self.presentLoginScene()
//            }
//        }else {
//            guard let _ = userVM else {
//                await fetchCurrentUserInfo()
//                return
//            }
//        }
//    }
    
    func configureViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        
        let feed = templateNavigationController(unselectedImage: .imageLiteral(name: "home_unselected"), selectedImage: .imageLiteral(name: "home_selected"), rootVC: FeedController(collectionViewLayout: layout))
        let searchVC = SearchController(viewModel: SearchViewModel())
        let search = templateNavigationController(unselectedImage: .imageLiteral(name: "search_unselected"), selectedImage: .imageLiteral(name: "search_selected"), rootVC: searchVC)
        
        let imageSelector = templateNavigationController(unselectedImage: .imageLiteral(name: "plus_unselected"), selectedImage: .imageLiteral(name: "plus_unselected"), rootVC: ImageSelectorController())
        let notifications = templateNavigationController(unselectedImage: .imageLiteral(name: "like_unselected"), selectedImage: .imageLiteral(name: "like_selected"), rootVC: NotificationController())
        
        let profileVC = ProfileController(viewModel: ProfileViewModel(user: vm.user))
        
        let profile = templateNavigationController(unselectedImage: .imageLiteral(name: "profile_unselected"), selectedImage: .imageLiteral(name: "profile_selected"), rootVC: profileVC)
        
        viewControllers = [feed,search,imageSelector,notifications,profile]
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
                vc.currentUserInfo = self.vm.user
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
    
    //MARK: - API. check user's membership
//    func isUserLogined() -> Bool {
//        let currentUserUid = Utils.pList.string(forKey: CURRENT_USER_UID)
//        if Auth.auth().currentUser == nil || currentUserUid == nil{
//            return false
//        }
//        return true
//    }
    
    func presentLoginScene() {
        let controller = LoginController(viewModel: LoginViewModel())
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: false, completion: nil)
    }
        
}

//MARK: - Implement AuthentificationDelegate
//extension MainHomeTabController {
    
//    /// 엥 여기서 영구저장소를 업데이트한다고?!
//    func authenticationCompletion(uid: String) async {
//        let ud = UserDefaults.standard
//        ud.synchronize()
//        ud.set(uid, forKey: CURRENT_USER_UID)
//        do{
//            try await fetchCurrentUserInfo(withUID: uid)
//            endIndicator()
//        }catch {
//            authenticationCompletionErrorHandling(error: error)
//        }
//        self.dismiss(animated: false)
//    }
//    ///얘는 uid있을 때 근데 이거도 로그인 버튼누르고 로그인 성공시에 영구저장소에 저장하면 매개변수 없앨 수 있어.
//    /// 근데 fetchCurrentUserInfo에서 어차피 영구저장소에서 가져와서 이거 없애도 될듯
//    func fetchCurrentUserInfo(withUID id: String) async throws {
//        let userInfo = try await UserService.fetchUserInfo(type: UserInfoModel.self, withUid: id)
//        guard let userInfo = userInfo else { throw FetchUserError.invalidUserInfo }
//        self.userVM = UserInfoViewModel(user: userInfo, profileImage: nil)
//    }
//
//    func authenticationCompletionErrorHandling(error: Error) {
//        switch error {
//        case FetchUserError.invalidGetDocumentUserUID:
//            print("DEBUG: Fail to get user document with UID 이경우 로그인됬는데 uid를 찾을 수 없음 -> 파이어베이스 사용자 UID 잘못 등록됨.")
//            DispatchQueue.main.async {
//                self.presentLoginScene()
//            }
//        case FetchUserError.invalidUserInfo:
//            print("DEBUG: Fail to bind userInfo")
//        default:
//            print("DEBUG: Unexpected error occured: \(error.localizedDescription)")
//        }
//    }
//}

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
