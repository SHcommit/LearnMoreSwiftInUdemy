//
//  ProfileHeader.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    private let profileIV: UIImageView = initialProfileIV()
    private let nameLabel: UILabel = initialNameLabel()
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemMint
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implement")
    }
}




//MARK: - Initial subviews
extension ProfileHeader {
    
    static func initialProfileIV() -> UIImageView {
        let iv = UIImageView()
        iv.image = UIImage(imageLiteralResourceName: "moscow")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.layer.cornerRadius = 80/2
        return iv
    }
    
    static func initialNameLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        guard let userUID = Auth.auth().currentUser?.uid else {
            fatalError("Fail to bind user UID")
        }
        let db = Firestore.firestore()
        
        let usersCollection = db.collection(firestoreUsers)
        
        usersCollection.document(userUID).getDocument { document, error in
            guard error == nil else { fatalError("Fail to get firestore document") }
            guard let document = document else { return }
            
            do {
                
                let info: UserInfoModel = try document.data(as: UserInfoModel.self)
                let eee = try JSONEncoder().encode(info)
                print()
                ///print(eee)
                
                
                guard let jsonData = String(data: eee, encoding: .utf8) else { return }
                print(jsonData)
                //print(info)
            } catch let e{
                print("Fail : \(e.localizedDescription)")
            }
        }
        return lb
    }
}



//MARK: - Setup subviews
extension ProfileHeader {
    func setupSubview() {
        addSubviews()
        setupSubviewsConstraints()
    }
    
    func addSubviews() {
        addSubview(profileIV)
        addSubview(nameLabel)
    }
    
    func setupSubviewsConstraints() {
        setupPostIVConstraints()
        setupNameLabelConstraints()
    }
    
}

//MARK: - Setup subviews constraints
extension ProfileHeader {
    
    func setupPostIVConstraints() {
        NSLayoutConstraint.activate([
            profileIV.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileIV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileIV.widthAnchor.constraint(equalToConstant: 80),
            profileIV.heightAnchor.constraint(equalToConstant: 80)])
    }
    
    func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileIV.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: profileIV.leadingAnchor)])
    }
    
}
