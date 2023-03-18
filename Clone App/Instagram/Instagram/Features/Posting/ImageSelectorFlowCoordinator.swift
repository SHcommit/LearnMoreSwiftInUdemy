//
//  ImageSelectorFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit
import YPImagePicker

class ImageSelectorFlowCoordinator: FlowCoordinator{
  
  typealias ImageSelectorFC = ImageSelectorFlowCoordinator
  
  //MARK: - Properties
  var parentCoordinator: FlowCoordinator?
  var childCoordinators = [FlowCoordinator]()
  var presenter: UINavigationController
  var imageSelectorController: ImageSelectorController!
  var picker: YPImagePicker!
  var loginOwner: UserModel
  var apiClient: ServiceProviderType
  
  //MARK: - Lifecycles
  init(presenter: UINavigationController? = nil, loginOwner: UserModel, apiClient: ServiceProviderType) {
    self.apiClient = apiClient
    self.loginOwner = loginOwner
    self.presenter = presenter ?? UINavigationController()
    imageSelectorController = ImageSelectorController(currentUser: loginOwner)
  }
  
  //MARK: - Action
  func start() {
    imageSelectorController.coordinator = self
    if ImageSelectorFC.isMainFlowCoordiantorChild(parent: parentCoordinator) {
      presenter = Utils.templateNavigationController(
        unselectedImage: .imageLiteral(name: "plus_unselected")
        , selectedImage: .imageLiteral(name: "plus_unselected"),
        rootVC: imageSelectorController)
      return
    }
    // 얘도 아직까진 기능은 구현했는데 아마 여기서 다른 sub coordinator를 호출하진 않는다.(안쓴다)
    presenter.pushViewController(imageSelectorController, animated: true)
  }
  
  func finish() {
    parentCoordinator?.removeChild(target: self)
    removeAllChild()
  }
  
}

extension ImageSelectorFlowCoordinator {
  
  func gotoPicker() {
    var config = YPImagePickerConfiguration()
    config.library.mediaType = .photo
    config.shouldSaveNewPicturesToAlbum = false
    config.startOnScreen = .library
    config.screens = [.library]
    config.hidesStatusBar = false
    config.hidesBottomBar = false
    config.library.maxNumberOfItems = 1
    
    let picker = YPImagePicker(configuration: config)
    self.picker = picker
    imageSelectorController.present(picker, animated: true)
  }
  
  func gotoUploadPost(loginOwner: UserModel, items: [YPMediaItem]) {
    picker.dismiss(animated: false) {
      guard let selectedImage = items.singlePhoto?.image else {
        self.gotoFeedPage()
        return
      }
      
      let child = UploadFlowCoordinator(
        presenter: self.presenter,
        loginOwner: loginOwner,
        selectedImg: selectedImage,
        apiClient: self.apiClient)
      self.holdChildByAdding(coordinator: child)
    }
  }
  
  func gotoFeedPage() {
    guard let mainFlow = parentCoordinator as? MainFlowCoordinator else {
      return
    }
    mainFlow.gotoFeedPage()
  }
}
