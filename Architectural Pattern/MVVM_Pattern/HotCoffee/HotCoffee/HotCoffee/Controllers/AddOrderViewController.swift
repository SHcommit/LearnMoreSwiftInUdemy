//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/02.
//

import UIKit

class AddOrderNewController : UIViewController {
    var tableView   : UITableView!
    var segmentCtrl : UISegmentedControl!
    var emailTF     : UITextField!
    var personTF    : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawOrderScene()
        self.setupNavigationBar()
    }
}

extension AddOrderNewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "tempCell"
        return cell
    }
}

//MARK: - setupSubviews
extension AddOrderNewController {
    func drawOrderScene(){
        setupTableView()
        setupSegmentCtrl()
        setupEmailTF()
        setupPersonTF()
    }
    
    func setupNavigationBar(){
        let rightBar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        self.navigationItem.rightBarButtonItem = rightBar
    }
    func setupTableView(){
        self.tableView       = UITableView()
        tableView.delegate   = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        //layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive   = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        //superView x축 기준으로 가운데 정렬
        tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    func setupSegmentCtrl () {
        self.segmentCtrl = UISegmentedControl()
        segmentCtrl.insertSegment(withTitle: "small", at: 0, animated: true)
        segmentCtrl.insertSegment(withTitle: "medium", at: 1, animated: true)
        segmentCtrl.insertSegment(withTitle: "large", at: 2, animated: true)
        segmentCtrl.selectedSegmentIndex = 0
        self.view.addSubview(segmentCtrl)
        
        segmentCtrl.translatesAutoresizingMaskIntoConstraints = false
        segmentCtrl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive               = true
        segmentCtrl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        
    }
    
    func setupEmailTF() {
        self.emailTF               = UITextField()
        emailTF.placeholder        = "이메일"
        emailTF.textAlignment      = .center
        emailTF.layer.borderColor  = UIColor.lightGray.cgColor
        emailTF.layer.borderWidth  = 1
        emailTF.layer.cornerRadius = 3
        emailTF.sizeToFit()
        view.addSubview(emailTF)
        
        //layout
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        emailTF.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1).isActive    = true
        emailTF.topAnchor.constraint(equalTo: self.segmentCtrl.bottomAnchor, constant: 100).isActive = true
        emailTF.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive    = true
        

    }
    func setupPersonTF(){
        self.personTF               = UITextField()
        personTF.placeholder        = "사용자"
        personTF.textAlignment      = .center
        personTF.layer.borderWidth  = 1
        personTF.layer.borderColor  = UIColor.lightGray.cgColor
        personTF.layer.cornerRadius = 3
        personTF.sizeToFit()
        view.addSubview(personTF)
        
        //layout
        personTF.translatesAutoresizingMaskIntoConstraints = false
        personTF.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 1).isActive  = true
        personTF.topAnchor.constraint(equalTo: self.emailTF.bottomAnchor, constant: 20).isActive  = true
        personTF.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        
        
    }
}

//MARK: - Event Handler
extension AddOrderNewController {
    @objc func save(_ sender: Any) {
        
    }
}
