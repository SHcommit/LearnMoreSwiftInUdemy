//
//  UploadPostController.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/10.
//

import UIKit

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    private let photoImageView: UIImageView = initPhotoImageView()
    private let contentsTextView: UITextView = initContentsTextView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}

//MARK: - Helpers
extension UploadPostController {
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title =  "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .done, target: self, action: #selector(didTapShare))
        
        setupSubviews()
        setupSubviewsConstraints()

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

//MARK: - Setup subviews
extension UploadPostController {
    
    func setupSubviews() {
        view.addSubview(photoImageView)
        view.addSubview(contentsTextView)
    }
    
    func setupSubviewsConstraints() {
        setupPhotoImageViewConstraints()
        setupContentsTextViewConstraints()
    }
}

//MARK: - Init properties
extension UploadPostController {
    
    static func initPhotoImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.image = UIImage(imageLiteralResourceName: "girl-1")
        return iv
    }
    
    static func initContentsTextView() -> UITextView {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }
}


//MARK: - AutoLayout subview's constraint
extension UploadPostController {
    
    func setupPhotoImageViewConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.heightAnchor.constraint(equalToConstant: UPLOAD_POST_PHOTO_IMAGE_VIEW_SIZE),
            photoImageView.widthAnchor.constraint(equalToConstant: UPLOAD_POST_PHOTO_IMAGE_VIEW_SIZE),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    func setupContentsTextViewConstraints() {
        NSLayoutConstraint.activate([
            contentsTextView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: UPLOAD_POST_CONTENT_TOP_MARGIN),
            contentsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UPLOAD_POST_CONTENT_SIDE_MARGIN),
            contentsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UPLOAD_POST_CONTENT_SIDE_MARGIN),
            contentsTextView.heightAnchor.constraint(equalToConstant: UPLOAD_POST_CONTENT_VIEW_SIZE)])
    }
    
}
