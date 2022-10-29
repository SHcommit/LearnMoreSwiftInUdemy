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
        print(userUID)
        let db = Firestore.firestore()
        
        let firestoreUserInfo = db.collection(firestoreUsers)
//        firestoreUserInfo.getDocuments() { querySnapshot, error in
//            guard error == nil else {
//                return print("Error getting documents: \(String(describing: error))")
//            }
//            guard let documents = querySnapshot?.documents else { return }
//            for info in documents {
//                let userInfo = info.data()
//                print(userInfo)
//            }
//        }
        
        let userInfo = firestoreUserInfo.document(userUID).getDocument { documentSnapshot, error in
            guard error == nil else { fatalError("nooooooo") }
            guard let document = documentSnapshot else { return }
            print("try11")
            
            do {
                let a: UserInfoViewModel = try document.data(as: UserInfoViewModel.self)
                print(a)
            } catch let e{
                print("Fail : \(e.localizedDescription)")
            }
            print("end11")
            
            if documentSnapshot?.exists != nil {

                let t = documentSnapshot?.data()
//                    let user = try? JSONDecoder().decode(UserInfoViewModel.self, from: documentSnapshot?.data())
//                    print(user)
//                } catch let e {
//                    print("Fail: \(e.localizedDescription)")
//                }
                //print(documentSnapshot?.data())
            }
        }
        
        
        
//        db.collection("YOUR_COLLECTION").getDocuments()
//                            { (QuerySnapshot, err) in
//                                if err != nil
//                                {
//                                    print("Error getting documents: \(String(describing: err))");
//                                }
//                                else
//                                {
//                                    //For-loop
//                                    for document in QuerySnapshot!.documents
//                                    {
//                                        //let document = QuerySnapshot!.documents
//                                        let data = document.data()
//
//                                        let data1 = data["YOUR_DATA1"] as? String
//                                        let data2 = data["YOUR_DATA2"] as? String
//
//                                        //Now you can access your data1 and data2 like this:
//                                        //example code:
//                                        txtfield_data1.text = data1
//                                        txtfield_data2.text = data2
//                                    }

        
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
