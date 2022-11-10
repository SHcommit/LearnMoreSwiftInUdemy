//
//  UploadPostController.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/10.
//

import UIKit

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}

//MARK: - Helpers
extension UploadPostController {
    func configureUI() {
        navigationItem.title =  "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .done, target: self, action: #selector(didTapShare))

    }
}


//MARK: - Event Hanlder
extension UploadPostController {
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc func didTapShare() {
        print("DEBUG: tap share event handing please ...")
    }
}
