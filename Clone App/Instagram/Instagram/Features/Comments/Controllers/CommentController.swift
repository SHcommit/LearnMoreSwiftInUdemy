//
//  CommentController.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit
import Combine

class CommentController: UICollectionViewController {
    
    //MARK: - Constants
    private let reuseIdentifier = "CommentCellID"
    //MARK: - Properties
    private var commentInputView: CommentInputAccessoryView!
    private var viewModel: CommentViewModelType
    private let apiClient: ServiceProviderType
    
    private let appear = PassthroughSubject<Void,Never>()
    private let reloadData = PassthroughSubject<Void,Never>()
    private let cellForItem = PassthroughSubject<CommentCellInfo,Never>()
    private let didSelect = PassthroughSubject<CommentCellSelectInfo,Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Lifecycles
    init(viewModel: CommentViewModelType, apiClient: ServiceProviderType) {
        self.viewModel = viewModel
        self.apiClient = apiClient
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        CreateCommentInputView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        appear.send()
    }
    
    override func viewWillDisappear(_ aniamted: Bool) {
        super.viewWillDisappear(aniamted)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return commentInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

//MARK: - Helpers
extension CommentController {
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Comments"
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }

    func setupBindings() {
        let input = CommentViewModelInput(
            appear: appear.eraseToAnyPublisher(),
            reloadData: reloadData.eraseToAnyPublisher(),
            cellForItem: cellForItem.eraseToAnyPublisher(),
            didSelected: didSelect.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.sink { self.render($0)}.store(in: &subscriptions)
    }
    
    private func render(_ state: CommentControllerState) {
        switch state {
        case .none:
            break
        case .updateUI:
            collectionView.reloadData()
            break
        }
    }
}

//MARK: - UICollectionViewDataSource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CommentCell else { fatalError() }
        cellForItem.send((cell,indexPath.row))
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = viewModel.size(forWidth: view.frame.width, index: indexPath.row).height + 32
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}

//MARK: - UICollectionViewDelegate
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect.send((navigationController,indexPath.row))
    }
}


//MARK: - Initial subViews
extension CommentController {
    
    func CreateCommentInputView() {
        commentInputView = CommentInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        commentInputView.delegate = self
    }
    
}

//MARK: - CommentInputAccessoryViewDelegate
extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        startIndicator()
        defer {
            endIndicator()
        }
        guard let vc = tabBarController as? MainHomeTabController else {
            return
        }
        let user = vc.vm.user
        guard let postId = viewModel.post.postId else { return }
        let input = UploadCommentInputModel(comment: comment,
                                            postID: postId,
                                            user: user)
        (viewModel as? CommentViewModelNetworkServiceType)?.uploadComment(withInputModel: input)
        let uploadModel = UploadNotificationModel(uid: user.uid, profileImageUrl: user.profileURL, username: user.username, userIsFollowed: user.isFollowed)
        apiClient.notificationCase.uploadNotification(toUid: viewModel.post.ownerUid, to: uploadModel, type: .comment,post: viewModel.post)
        inputView.clearCommentTextView()
    }
}
