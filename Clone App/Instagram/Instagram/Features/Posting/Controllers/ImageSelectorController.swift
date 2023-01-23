//
//  ImageSelectedController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import YPImagePicker

class ImageSelectorController: UIViewController {
    weak var coordinator: ImageSelectorFlowCoordinator?
    fileprivate var currentUser: UserModel
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "imageSelector"
        showPicker()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ImageSelectorController {
    func showPicker() {
        coordinator?.gotoPicker()
        guard let picker = coordinator?.picker else { return }
        didFinishPickingMedia(picker)
    }
}

//MARK: - Event Handler
extension ImageSelectorController {
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            self.coordinator?.gotoUploadPost(loginOwner: self.currentUser, items: items)
        }
    }
}
