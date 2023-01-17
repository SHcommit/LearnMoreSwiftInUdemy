//
//  CommentInputAccesoryView.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String)
}

class CommentInputAccessoryView: UIView {
    
    //MARK: - Properties
    private var commentTextView: InputTextView!
    private var postButton: UIButton!
    weak var delegate: CommentInputAccessoryViewDelegate?
    
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
        backgroundColor = .white
        configureSubviews()
        setupDivider()
    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
    
    private func setupDivider() {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .lightGray
        addSubview(divider)
        UIConfig.setupConstraints(with: divider) {
            [$0.top.constraint(equalTo: top),
             $0.leading.constraint(equalTo: leading),
             $0.trailing.constraint(equalTo: trailing),
             $0.height.constraint(equalToConstant: 0.5)]
        }
    }
    
}

//MARK: - Event Handler
extension CommentInputAccessoryView {
    @objc func didTapPost() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
}

//MARK: - ConfigureSubviewsCase
extension CommentInputAccessoryView: ConfigureSubviewsCase{
   
    func configureSubviews() {
        createSubviews()
        addSubviews()
        setupLayouts()
    }
    
    func createSubviews() {
        commentTextView = InputTextView()
        postButton = UIButton()
    }
    
    func addSubviews() {
        addSubview(commentTextView)
        addSubview(postButton)
    }
    
    func setupLayouts() {
        setupSubviewsLayouts()
        setupSubviewsConstraints()
    }
    
    
}

//MARK: - SetupSubviewsLayouts
extension CommentInputAccessoryView: SetupSubviewsLayouts {
   
    func setupSubviewsLayouts() {
        
        /// Setup commentTextView layout
        UIConfig.setupLayout(detail: commentTextView) {
            $0.placeholderText = "Enter comment.."
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.isScrollEnabled = false
            $0.placeholderShouldCenter = true
        }
        
        /// Setup postButton layout
        UIConfig.setupLayout(detail: postButton) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle("Post", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            $0.addTarget(self, action: #selector(self.didTapPost), for: .touchUpInside)
            $0.setTitleColor(.lightText, for: .highlighted)
        }
    }
    
}

//MARK: - SetupSubviewsConstraints
extension CommentInputAccessoryView: SetupSubviewsConstraints {
   
    func setupSubviewsConstraints() {
        
        ///Setup textView constraints
        UIConfig.setupConstraints(with: commentTextView) {
            [$0.leading.constraint(equalTo: leading, constant: 8),
             $0.top.constraint(equalTo: top, constant: 8),
             $0.trailing.constraint(equalTo: postButton.leading, constant: -8),
             $0.bottom.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)]
        }
    
        ///Setup postButton constraints
        UIConfig.setupConstraints(with: postButton) {
            [$0.trailing.constraint(equalTo: trailing, constant: -8),
             $0.top.constraint(equalTo: top),
             $0.width.constraint(equalToConstant: 50),
             $0.height.constraint(equalToConstant: 50)]
        }
    }
    
}

