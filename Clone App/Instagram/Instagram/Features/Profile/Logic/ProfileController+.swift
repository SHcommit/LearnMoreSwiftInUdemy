//
//  ProfileController+.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/12.
//

import UIKit

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
