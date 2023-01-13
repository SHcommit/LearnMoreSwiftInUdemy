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
    private lazy var commentInputView = initCommentInputView()
    
    private var viewModel: CommentViewModelType
    
    let appear = PassthroughSubject<Void,Never>()
    let reloadData = PassthroughSubject<Void,Never>()
    let cellForItem = PassthroughSubject<CommentCellInfo,Never>()
    let didSelect = PassthroughSubject<CommentCellSelectInfo,Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Lifecycles
    init(viewModel: CommentViewModelType) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
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
    
    func configureUI() {
        

    }
    
    func addSubviews() {
        view.addSubview(commentInputView)
        
    }
    
    func constraintsSubviews() {
        
        
    }
    
    
    func setupBindings() {
        let input = CommentViewModelInput(appear: appear.eraseToAnyPublisher(),
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
        return viewModel.comments.count
        
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
    
    func initCommentInputView() -> CommentInputAccessoryView {
        let iv = CommentInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }
    
}

//MARK: - Constraint subview's auto layout
extension CommentController {
    
    func  commentInputViewConstraints() {
        NSLayoutConstraint.activate([
            commentInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

//MARK: - CommentInputAccessoryViewDelegate
extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        indicator.startAnimating()
        guard let vc = tabBarController as? MainHomeTabController else { return }
        guard let user = vc.getUserVM?.userInfoModel() else { return }
        guard let postId = viewModel.post.postId else { return }
        let input = UploadCommentInputModel(comment: comment,
                                            postID: postId,
                                            user: user)
        (viewModel as? CommentViewModelNetworkServiceType)?.uploadComment(withInputModel: input)
        let uploadModel = UploadNotificationModel(uid: user.uid, profileImageUrl: user.profileURL, username: user.username, userIsFollowed: user.isFollowed)
        NotificationService.uploadNotification(toUid: viewModel.post.ownerUid, to: uploadModel, type: .comment,post: viewModel.post)
        inputView.clearCommentTextView()
        indicator.stopAnimating()
    }
}
