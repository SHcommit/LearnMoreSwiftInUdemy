//
//  ImageSelectorFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class ImageSelectorFlowCoordinator: FlowCoordinator{
    
    typealias ImageSelectorFC = ImageSelectorFlowCoordinator
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var imageSelectorController: ImageSelectorController!
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController? = nil) {
        self.presenter = presenter ?? UINavigationController()
        imageSelectorController = ImageSelectorController()
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
    
        // 중요 //
        
        // 얘도 나중에 sub coordinator 호출하면 parent가 mainFlow인지 반드시 검사 해야한다.
        // parent일땐 자기자신을 삭제하면 안됨.
        
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}
