//
//  UploadPostController.swift
//  Instagram
//
//  Created by μμΉν on 2022/11/10.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    private let photoImageView: UIImageView = initPhotoImageView()
    private lazy var contentsTextView: InputTextView = initContentsTextView()
    private var charCountLabel: UILabel = initCharCountLabel()
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    weak var didFinishDelegate: UploadPostControllerDelegate?
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    var currentUserInfo: UserInfoModel?
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
    
    func checkMaxLine(_ textView: UITextView, maxLength: Int) {
        if textView.text.count > maxLength {
            textView.deleteBackward()
        }
    }
    
}

//MARK: - Event Hanlder
extension UploadPostController {
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc func didTapShare() {
        startIndicator(indicator: indicator)
        Task() {
            do {
                try await uploadPostFromDidTapShareEvent()
                uploadPostCompletionHandler()
            }catch {
                endIndicator(indicator: indicator)
                uploadPostErrorHandling(error: error)
            }
        }
    }
    
    func uploadPostFromDidTapShareEvent() async throws {
        guard
            let image = selectedImage ,
            let caption = contentsTextView.text else { throw FetchPostError.invalidUserPostData }
        guard let userInfo = currentUserInfo else { throw FetchUserError.invalidUserInfo }
        
        try await PostService.uploadPost(caption: caption, image: image, ownerProfileUrl: userInfo.profileURL, ownerUsername: userInfo.username)
    }
    
    func uploadPostCompletionHandler() {
        DispatchQueue.main.async {
            self.endIndicator(indicator: self.indicator)
            self.didFinishDelegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    func uploadPostErrorHandling(error: Error) {
        switch error {
        case FetchUserError.invalidGetDocumentUserUID:
            print("DEBUG: didTapShare error occured. Invalid get docuemnt user uid")
        case FetchPostError.failToRequestUploadImage:
            print("DEBUG: didTapShare error occured. Fail to request user's uploadImage post")
        case FetchPostError.failToRequestPostData:
            print("DEBUG: didTapShare error occured. Fail to request post data")
        case FetchPostError.invalidUserPostData:
            print("DEBUG: didTapShare error occured. Fail to bind user's Feed post")
        default:
            print("DEBUG: didTapShare unexcept error occured : \(error.localizedDescription) ")
        }
    }
}

//MARK: - Setup subviews
extension UploadPostController {
    
    func setupSubviews() {
        view.addSubview(photoImageView)
        view.addSubview(contentsTextView)
        view.addSubview(charCountLabel)
    }
    
    func setupSubviewsConstraints() {
        setupPhotoImageViewConstraints()
        setupContentsTextViewConstraints()
        setupCharCountLabelConstraints()
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
        return iv
    }
    
    func initContentsTextView() -> InputTextView {
        let tv = InputTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.placeholderText = "Enter caption.."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textDelegate = self
        tv.placeholderShouldCenter = false
        return tv
    }
    
    static func initCharCountLabel() -> UILabel {
        let lb = UILabel()
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "0/100"
        return lb
    }
}

extension UploadPostController: InputTextCountDelegate {
    func inputTextCount(withCount cnt: Int) {
        DispatchQueue.main.async {
            self.checkMaxLine(self.contentsTextView, maxLength: 100)
            self.charCountLabel.text = "\(cnt)/100"
        }
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
            contentsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UPLOAD_POST_CONTENT_SIDE_MARGIN),
            contentsTextView.heightAnchor.constraint(equalToConstant: UPLOAD_POST_CONTENT_VIEW_SIZE)])
    }
    
    func setupCharCountLabelConstraints() {
        NSLayoutConstraint.activate([
            charCountLabel.topAnchor.constraint(equalTo: contentsTextView.bottomAnchor, constant: UPLOAD_POST_CONTENT_SIDE_MARGIN),
            charCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UPLOAD_POST_CONTENT_SIDE_MARGIN)])
    }
    
}
