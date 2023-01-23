//
//  UploadPostController.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/10.
//

import UIKit

protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    fileprivate var photoImageView: UIImageView! = UIImageView()
    fileprivate var contentsTextView: InputTextView!
    fileprivate var charCountLabel: UILabel!
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    weak var coordinator: UploadFlowCoordinator?
    weak var didFinishDelegate: UploadPostControllerDelegate?
    var currentUserInfo: UserModel?
    
    //MARK: - Usecase
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - Lifecycle
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
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
    }
    
    func checkMaxLine(_ textView: UITextView, maxLength: Int) {
        if textView.text.count > maxLength {
            textView.deleteBackward()
        }
    }
    
}

//MARK: - Event Hanlder
extension UploadPostController {
    
    func uploadPostCompletionHandler() {
        DispatchQueue.main.async {
            self.endIndicator()
            self.didFinishDelegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    @objc func didTapCancel() {
        coordinator?.finish()
    }
    
    @objc func didTapShare() {
        startIndicator()
        Task() {
            do {
                try await uploadPostFromDidTapShareEvent()
                uploadPostCompletionHandler()
                endIndicator()
            }catch {
                endIndicator()
                uploadPostErrorHandling(error: error)
            }
        }
    }
    
    func uploadPostFromDidTapShareEvent() async throws {
        guard
            let image = selectedImage ,
            let caption = contentsTextView.text else { throw FetchPostError.invalidUserPostData }
        guard let userInfo = currentUserInfo else { throw FetchUserError.invalidUserInfo }
        
        try await apiClient.postCase.uploadPost(caption: caption, image: image, ownerProfileUrl: userInfo.profileURL, ownerUsername: userInfo.username)
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

//MARK: - ConfigureSubviewsCase
extension UploadPostController: ConfigureSubviewsCase {
    
    func configureSubviews() {
        createSubviews()
        addSubviews()
        setupLayouts()
    }
    
    func createSubviews() {
        contentsTextView = InputTextView()
        charCountLabel = UILabel()
    }
    
    func addSubviews() {
        view.addSubview(photoImageView)
        view.addSubview(contentsTextView)
        view.addSubview(charCountLabel)
    }
    
    func setupLayouts() {
        setupSubviewsLayouts()
        setupSubviewsConstraints()
    }
    
}

//MARK: - SetupSubviesLayouts
extension UploadPostController: SetupSubviewsLayouts {
    func setupSubviewsLayouts() {
        
        ///Setup photoImageView layout
        UIConfig.setupLayout(detail: photoImageView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        ///Setup contentsTextView layout
        UIConfig.setupLayout(detail: contentsTextView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.placeholderText = "Enter caption.."
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textDelegate = self
            $0.placeholderShouldCenter = false
        }
        
        ///Setup charCount layout
        UIConfig.setupLayout(detail: charCountLabel) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .lightGray
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.text = "0/100"
        }
    }
    
}

//MARK: - SetupSubveiwsConstraints
extension UploadPostController: SetupSubviewsConstraints {
    func setupSubviewsConstraints() {
        
        ///Setup photoImageView constraints
        UIConfig.setupConstraints(with: photoImageView) {
            return [$0.height.constraint(equalToConstant: UPLOAD_POST_PHOTO_IMAGE_VIEW_SIZE),
                    $0.width.constraint(equalToConstant: UPLOAD_POST_PHOTO_IMAGE_VIEW_SIZE),
                    $0.top.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    $0.centerX.constraint(equalTo: view.centerX)]
        }
        
        ///Setup contentsTextView constraints
        UIConfig.setupConstraints(with: contentsTextView) {
            return [$0.top.constraint(equalTo: photoImageView.bottom,
                                      constant: UPLOAD_POST_CONTENT_TOP_MARGIN),
                    $0.leading.constraint(equalTo: view.leading,
                                          constant: UPLOAD_POST_CONTENT_SIDE_MARGIN),
                    $0.trailing.constraint(equalTo: view.trailing,
                                           constant: -UPLOAD_POST_CONTENT_SIDE_MARGIN),
                    $0.height.constraint(equalToConstant: UPLOAD_POST_CONTENT_VIEW_SIZE)]
        }
        
        ///Setup charCountLabel constraints
        UIConfig.setupConstraints(with: charCountLabel) {
            return [$0.top.constraint(equalTo: contentsTextView.bottom,
                                      constant: UPLOAD_POST_CONTENT_SIDE_MARGIN),
                    $0.trailing.constraint(equalTo: view.trailing,
                                           constant: -UPLOAD_POST_CONTENT_SIDE_MARGIN)]
        }
    }
    
}

//MARK: - InputTextCountDelegate
extension UploadPostController: InputTextCountDelegate {
    func inputTextCount(withCount cnt: Int) {
        DispatchQueue.main.async {
            self.checkMaxLine(self.contentsTextView, maxLength: 100)
            self.charCountLabel.text = "\(cnt)/100"
        }
    }
}
