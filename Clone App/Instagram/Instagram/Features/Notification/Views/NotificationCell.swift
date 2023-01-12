//
//  NotificationCell.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/10.
//

import UIKit
import Combine

class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    private lazy var profileImageView = UIImageView()
    private let infoLabel = UILabel()
    private lazy var postImageView = UIImageView()
    private lazy var followButton = UIButton()
    
    //MARK: - Combine properties
    @Published var vm: NotificationCellViewModelType?
    var initalization = PassthroughSubject<(profile: UIImageView, post: UIImageView),Never>()
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Delegate
    var delegate = NotificationCellDelegate()
    
    //MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayouts()
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("구현x")
    }
    override func prepareForReuse() {
        _=subscriptions.map{$0.cancel()}
        $vm
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                initalization.send((profileImageView, postImageView))
                lazyConfigure()
            }.store(in: &subscriptions)
    }
}

//MARK: - Helpers
extension NotificationCell {
    
    func setupBindings() {
        let notificationInput = NotificationCellViewModelInput(initialization: initalization.eraseToAnyPublisher())
        let output = vm?.transform(with: notificationInput)
        output?
            .receive(on: DispatchQueue.main)
            .sink{ state in
            self.render(state)
        }.store(in: &subscriptions)
    }
    
    private func render(_ state: NotificationCellState) {
        switch state {
        case .none: break
        case .configure(let attrText):
            //image는 vm안에서 비동기로함.
            infoLabel.attributedText = attrText
            break
        }
    }
    
    private func addSubviews() {
        _=[profileImageView, infoLabel,
           postImageView,followButton].map{contentView.addSubview($0)}
    }
    
    private func setupLayouts() {
        setupProfileImageViewLayout()
        setupInfoLabelLayout()
        setupPostImageView()
        setupFollowButton()
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    private func lazyConfigure() {
        guard let vm = vm else { return }
        followButton.isHidden = !vm.shouldHidePostImage
        postImageView.isHidden = vm.shouldHidePostImage
        if !followButton.isHidden {
            bringSubviewToFront(followButton)
        } else {
            bringSubviewToFront(postImageView)
        }
        
        followButton.setTitle(vm.followButtonText, for: .normal)
        followButton.backgroundColor = vm.followButtonBackgroundColor
        followButton.setTitleColor(vm.followButtonTextColor, for: .normal)
    }
}

//MARK: - Event handler
extension NotificationCell {
    
    @objc func didTapProfile() {
        print("tap profile")
    }
    
    @objc func didTapFollowButton() {
        guard let id = vm?.notification.id else { return }
        delegate.send(with: (self,id, .follow))
    }
    
    @objc func didTapPostArea() {
        //guard let postId = vm?.notification.postId else { return }
        delegate.send(with: (self, "임시", .comment))
    }
    
}


//MARK: - Setup UI layout
extension NotificationCell {
    
    private func setupProfileImageViewLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .lightGray
        profileImageView.image = UIImage()
        profileImageView.layer.cornerRadius = 48/2
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
        
        setupProfileImageViewConstraints()
    }

    private func setupInfoLabelLayout() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.boldSystemFont(ofSize: 14)
        infoLabel.numberOfLines = 0
        
        setupInfoLabelConstraints()
    }
    
    private func setupPostImageView(){
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPostArea))
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tap)

        setupPostImageViewConstraints()
    }
    
    private func setupFollowButton() {
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setTitle("Loading", for: .normal)
        followButton.layer.cornerRadius = 3
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 0.5
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        followButton.setTitleColor(.black, for: .normal)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        setupFollowButtonConstraints()
    }
}

//MARK: - Setup UI constriants
extension NotificationCell {
    
    private func setupProfileImageViewConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)])
    }
    
    private func setupPostImageViewConstraints() {
        NSLayoutConstraint.activate([
            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -12),
            postImageView.widthAnchor.constraint(equalToConstant: 64),
            postImageView.heightAnchor.constraint(equalToConstant: 64)])
    }
    
    private func setupFollowButtonConstraints() {
        NSLayoutConstraint.activate([
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            followButton.widthAnchor.constraint(equalToConstant: 88),
            followButton.heightAnchor.constraint(equalToConstant: 32)])
    }
    
    private func setupInfoLabelConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            infoLabel.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -4)
            ])
    }
    
}
