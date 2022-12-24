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
    
    
    let appear = PassthroughSubject<Void,Never>()
    let numberOfItems = PassthroughSubject<Int,Never>()
    let cellForItem = PassthroughSubject<CommentCell,Never>()
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
        commentInputViewConstraints()
    }
    
}

//MARK: - UICollectionViewDataSource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CommentCell else { fatalError() }
        cellForItem.send(cell)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
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
        print("DEBUG: comment: \( comment )")
        inputView.clearCommentTextView()
    }
}
