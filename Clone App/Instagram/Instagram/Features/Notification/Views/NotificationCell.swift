//
//  NotificationCell.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/10.
//

import UIKit
import Combine

class NotificationCell: UITableViewCell {
    
    //MARK: - Constants
    typealias InitElement = (profile: UIImageView, post: UIImageView)
    
    //MARK: - Properties
    fileprivate var profileImageView: UIImageView!
    fileprivate var infoLabel: UILabel!
    fileprivate var postImageView: UIImageView!
    fileprivate var followButton: UIButton!
    @Published var vm: NotificationCellViewModelType?
    internal var initalization = PassthroughSubject<InitElement,Never>()
    fileprivate var subscriptions = Set<AnyCancellable>()
    internal var delegate = NotificationCellDelegate()
    
    //MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
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
            }.store(in: &subscriptions)
        
    }
}

//MARK: - Helpers
extension NotificationCell {
    
    //MARK: - Binding helpers
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
            lazyConfigure()
            break
        case .updatedFollow:
            updateFollowButtonUI()
            break
        }
    }
    
    //MARK: - UI helpers
    private func configureUI() {
        selectionStyle = .none
    }
    
    private func lazyConfigure() {
        guard let vm = vm else { return }
        followButton.isHidden = !vm.shouldHidePostImage
        postImageView.isHidden = vm.shouldHidePostImage
        if !followButton.isHidden {
            bringSubviewToFront(followButton)
            updateFollowButtonUI()
        } else {
            bringSubviewToFront(postImageView)
        }
    }
    
    ///NotificationsController setup cell's delegate completion call
    func updateFollowButtonUI() {
        guard let vm = vm else { return }
        followButton.setTitle(vm.followButtonText, for: .normal)
        followButton.backgroundColor = vm.followButtonBackgroundColor
        followButton.setTitleColor(vm.followButtonTextColor, for: .normal)
    }
}

//MARK: - Event handler
extension NotificationCell {
    
    @objc func didTapFollowButton() {
        guard let vm = vm else { return }
        if vm.userIsFollowed {
            delegate.send(with: (self,vm.notification.specificUserInfo.uid,.wantsToUnfollow))
        } else {
            delegate.send(with: (self,vm.notification.specificUserInfo.uid, .wantsToFollow))
        }
    }
    
    @objc func didTapPostArea() {
        guard let postId = vm?.notification.postId else { return }
        delegate.send(with: (self, postId, .wantsToViewPost))
    }
    
}


//MARK: - ConfigureSubviewsLayoutCase
extension NotificationCell: ConfigureSubviewsCase {
    
    func configureSubviews() {
        createSubviews()
        addSubviews()
        setupLayouts()
    }
    
    func createSubviews() {
        profileImageView = UIImageView()
        infoLabel = UILabel()
        postImageView = UIImageView()
        followButton = UIButton()
    }
    
    func addSubviews() {
        addSubview(profileImageView)
        _=[infoLabel, postImageView, followButton].map{contentView.addSubview($0)}
    }
    
    func setupLayouts() {
        setupSubviewsLayouts()
        setupSubviewsConstraints()
    }
}

//MARK: - Setup UI layout
extension NotificationCell: SetupSubviewsLayouts {
    
    func setupSubviewsLayouts() {
        
        /// Setup profileImageView layout
        UIConfig.setupLayout(detail: profileImageView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .lightGray
            $0.image = UIImage()
            $0.layer.cornerRadius = 48/2
        }
        
        /// Setup infoLable layout
        UIConfig.setupLayout(detail: infoLabel) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.numberOfLines = 0
        }
        
        /// Setup postImageView layout
        UIConfig.setupLayout(detail: postImageView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .lightGray
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapPostArea))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tap)
        }
        
        /// Setup followButton layout
        UIConfig.setupLayout(detail: followButton) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle("Loading", for: .normal)
            $0.layer.cornerRadius = 3
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 0.5
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(self, action: #selector(self.didTapFollowButton), for: .touchUpInside)
        }
        
    }
}

//MARK: - Setup UI constriants
extension NotificationCell: SetupSubviewsConstraints {
    
    func setupSubviewsConstraints() {
        
        /// Setup profileImageView constraints
        UIConfig.setupConstraints(with: profileImageView) {
            return [$0.width.constraint(equalToConstant: 48),
                    $0.height.constraint(equalToConstant: 48),
                    $0.centerY.constraint(equalTo: centerY),
                    $0.leading.constraint(equalTo: leading, constant: 12)]
        }
        
        /// Setup profileImageView constraints
        UIConfig.setupConstraints(with: postImageView) {
            return [$0.centerY.constraint(equalTo: centerY),
                    $0.trailing.constraint(equalTo: trailing,constant: -12),
                    $0.width.constraint(equalToConstant: 64),
                    $0.height.constraint(equalToConstant: 64)]
        }
        
        /// Setup followButton constraints
        UIConfig.setupConstraints(with: followButton) {
            return [$0.centerY.constraint(equalTo: centerY),
                    $0.trailing.constraint(equalTo: trailing, constant: -12),
                    $0.width.constraint(equalToConstant: 88),
                    $0.height.constraint(equalToConstant: 32)]
        }
        
        /// Setup infoLabel constraints
        UIConfig.setupConstraints(with: infoLabel) {
            return [$0.centerY.constraint(equalTo: profileImageView.centerY),
                    $0.leading.constraint(equalTo: profileImageView.trailing,
                                          constant: 8),
                    $0.trailing.constraint(equalTo: followButton.leading,
                                           constant: -4)]
        }
        
    }
    
}
