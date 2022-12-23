//
//  CommentInputAccesoryView.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit

class CommentInputAccessoryView: UIView {
    
    //MARK: - Properties
    private lazy var commentTextView: InputTextView = initCommentTextView()
    private lazy var postButton: UIButton = initPostButton()
    //MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implement.")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}

//MARK: - Helpers
extension CommentInputAccessoryView {
    
    func configureUI() {
        autoresizingMask = .flexibleHeight
        addSubviews()
        constraintsSubviews()
        
        setupDivider()
    }
    
    func addSubviews() {
        addSubview(commentTextView)
        addSubview(postButton)
    }
    
    func constraintsSubviews() {
        commentTextViewConstraints()
        postButtonConstraints()
    }
    
    func setupDivider() {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .lightGray
        addSubview(divider)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: topAnchor),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5)])
    }
}

//MARK: - Event Handler
extension CommentInputAccessoryView {
    @objc func didTapPost() {
        
    }
}

//MARK: - Init subViews
extension CommentInputAccessoryView {
    func initCommentTextView() -> InputTextView {
        let tv = InputTextView()
        tv.placeholderText = "Enter comment.."
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeholderShouldCenter = true
        //tv.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return tv
    }
    
    func initPostButton() -> UIButton {
        let pb = UIButton()
        pb.translatesAutoresizingMaskIntoConstraints = false
        pb.setTitle("Post", for: .normal)
        pb.setTitleColor(.black, for: .normal)
        pb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        pb.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        //pb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return pb
    }
}

//MARK: - Constraint subview's auto layout
extension CommentInputAccessoryView {
    
    func commentTextViewConstraints() {
        NSLayoutConstraint.activate([
            commentTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            commentTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            commentTextView.rightAnchor.constraint(equalTo: postButton.leftAnchor, constant: -8),
            commentTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)])
    }
    
    func postButtonConstraints() {
        NSLayoutConstraint.activate([
            postButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            postButton.topAnchor.constraint(equalTo: topAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 50),
            postButton.heightAnchor.constraint(equalToConstant: 50)])
    }
}
