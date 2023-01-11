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
    private let profileImageView: UIImageView = initProfileImageView()
    private let infoLabel: UILabel = initInfoLabel()
    private var postImageView: UIImageView = initPostImageView()
    private lazy var followButton: UIButton = initFollowButton()
    
    @Published var vm: NotificationCellViewModelType?
    var initalization = PassthroughSubject<UIImageView,Never>()
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupBindings()
        $vm
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.initalization.send(self.postImageView)
            }.store(in: &subscriptions)
    }
    required init?(coder: NSCoder) {
        fatalError("구현x")
    }
}

//MARK: - Helpers
extension NotificationCell {
    func configureUI() {
        addSubviews()
        setupConstraints()
        selectionStyle = .none
        followButton.isHidden = true
    }
    
    func setupBindings() {
        let notificationInput = NotificationCellViewModelInput(initialization: initalization.eraseToAnyPublisher())
        let output = vm?.transform(with: notificationInput)
        output?.sink{ state in
            self.render(state)
        }.store(in: &subscriptions)
    }
    
    func render(_ state: NotificationCellState) {
        switch state {
        case .none: break
        case .configure: break
        case .updateImage(let image):
            print(image)
            self.profileImageView.image = image
        
        }
    }
}

//MARK: - Event handler
extension NotificationCell {
    @objc func didTapFollowButton() {
        
    }
}

//MARK: - UI
extension NotificationCell {
    func addSubviews() {
        addSubview(profileImageView)
        addSubview(infoLabel)
        addSubview(postImageView)
        addSubview(followButton)
    }
    
    func setupConstraints() {
        setupProfileImageViewConstraints()
        setupInfoLabelConstraints()
        setupPostImageViewConstraints()
        setupFollowButtonConstraints()
    }
}

//MARK: - UI properties init
extension NotificationCell {
    static func initProfileImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage()
        iv.layer.cornerRadius = 48/2
        return iv
    }

    static func initInfoLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "biiou"
        return label
    }
    
    static func initPostImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        let tap = UIGestureRecognizer(target: self, action: #selector(didTapFollowButton))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }
    func initFollowButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        return button
    }
}

//MARK: - UI properties setup constriants
extension NotificationCell {
    func setupProfileImageViewConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)])
    }
    func setupInfoLabelConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
            ])
    }
    func setupPostImageViewConstraints() {
        NSLayoutConstraint.activate([
            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -12),
            postImageView.widthAnchor.constraint(equalToConstant: 64),
            postImageView.heightAnchor.constraint(equalToConstant: 64)])
    }
    
    func setupFollowButtonConstraints() {
        NSLayoutConstraint.activate([
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            followButton.widthAnchor.constraint(equalToConstant: 100),
            followButton.heightAnchor.constraint(equalToConstant: 32)])
    }
    
    
}
