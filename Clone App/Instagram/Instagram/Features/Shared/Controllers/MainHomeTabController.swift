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
    weak var coordinator: MainFlowCoordinator?
    
    //MARK: - Lifecycle
    init(vm: MainHomeTabViewModelType) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configure()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            break
        }
    }
}

//MARK: - Helpers
extension MainHomeTabController {
    
    func configure() {
        customTabBarUI()
        delegate = self
    }
    
}

//MARK: - Event Handler
extension MainHomeTabController {
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let vc = UploadPostController(apiClient: ServiceProvider.defaultProvider())
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
    
//    func presentLoginScene() {
//        let controller = LoginController(viewModel: LoginViewModel(apiClient: ServiceProvider.defaultProvider()))
//        let nav = UINavigationController(rootViewController: controller)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav,animated: false, completion: nil)
//    }
        
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
