//
//  ProfileController.swift
//  Instagram
//
//  Created by μμΉν on 2022/09/30.
//

import UIKit
import Combine

class ProfileController: UICollectionViewController {
    
    //MARK: - properties
    let viewModel: ProfileViewModelType
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - ProfileViewModel input properties
    let appear = PassthroughSubject<Void,ProfileErrorType>()
    let cellConfigure = PassthroughSubject<(ProfileCell,index: Int), ProfileErrorType>()
    let headerConfigure = PassthroughSubject<ProfileHeader, ProfileErrorType>()
    let didTapCell = PassthroughSubject<Int,ProfileErrorType>()
    
    //MARK: - Lifecycle
    init(viewModel: ProfileViewModelType) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        navigationItem.title = viewModel.getUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appear.send()
    }

}

//MARK: - Helpers
extension ProfileController {
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: CELLREUSEABLEID)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: COLLECTIONHEADERREUSEABLEID)
    }
    
    func setupBindings() {
        let input = ProfileViewModelInput(appear: appear.eraseToAnyPublisher(),
                                          cellConfigure: cellConfigure.eraseToAnyPublisher(),
                                          headerConfigure: headerConfigure.eraseToAnyPublisher(),
                                          didTapCell: didTapCell.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output
            .receive(on: RunLoop.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.outputErrorHandling(with: error)
                    break
                }
            } receiveValue: { state in
                self.render(state)
            }.store(in: &subscriptions)
    }
    
    func render(_ state: ProfileControllerState) {
        switch state {
        case .none:
            break
        case .reloadData:
            collectionView.reloadData()
            break
        case .showSpecificUser(feed: let feed):
            feed.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: feed, action: #selector(feed.cancel))
            navigationController?.pushViewController(feed, animated: true)
        }
    }
    
    func outputErrorHandling(with error: ProfileErrorType) {
        switch error {
        case .failed:
            print(ProfileErrorType.failed.errorDiscription + " : \(error.localizedDescription)")
        case .invalidUserProperties:
            print(ProfileErrorType.invalidUserProperties.errorDiscription + " : \(error.localizedDescription)")
        case .invalidInstance:
            print(ProfileErrorType.invalidInstance.errorDiscription + " : \(error.localizedDescription)")
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getPostsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLREUSEABLEID, for: indexPath) as? ProfileCell else { fatalError() }
        cellConfigure.send((cell,indexPath.row))
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: COLLECTIONHEADERREUSEABLEID, for: indexPath) as? ProfileHeader else { fatalError() }
        
        headerConfigure.send(headerView)
        return headerView
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-2)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height/7 * 2)
    }
        
    
}



//MARK: - UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCell.send(indexPath.row)
    }
}
