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
    
    
    let appear = PassthroughSubject<Void,Never>()
    let numberOfItems = PassthroughSubject<Int,Never>()
    let cellForItem = PassthroughSubject<UICollectionViewCell,Never>()
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
}

//MARK: - Helpers
extension CommentController {
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

//MARK: - UICollectionViewDataSource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cellForItem.send(cell)
        cell.backgroundColor = .red
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAy indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
}
