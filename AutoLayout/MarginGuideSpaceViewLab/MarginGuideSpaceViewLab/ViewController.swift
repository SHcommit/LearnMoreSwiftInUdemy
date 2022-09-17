//
//  ViewController.swift
//  MarginGuideSpaceViewLab
//
//  Created by 양승현 on 2022/09/17.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubviews()
    }


}

// MARK: - make controls
extension ViewController {
    
    func makeButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.text = title
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btn.backgroundColor = color
        return btn
    }
    
}


//MARK: - setupSubviews

extension ViewController {
    
    func setupSubviews() {
        
        let leadingGuide = UILayoutGuide()
        let okButton = makeButton(title: "Ok", color: .darkBlue)
        let middleGuide = UILayoutGuide()
        let cancelButton = makeButton(title: "Cancel", color: .darkGreen)
        let trailingGuide = UILayoutGuide()
        
        view.addSubview(okButton)
        view.addSubview(cancelButton)
        view.addLayoutGuide(leadingGuide)
        view.addLayoutGuide(middleGuide)
        view.addLayoutGuide(trailingGuide)
        
        let margins = view.layoutMarginsGuide
        
        margins.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor).isActive = true
        leadingGuide.trailingAnchor.constraint(equalTo:okButton.leadingAnchor).isActive = true
        
        okButton.trailingAnchor.constraint(equalTo: middleGuide.leadingAnchor).isActive = true
        middleGuide.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor).isActive = true
        
        
        cancelButton.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor).isActive = true
        trailingGuide.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        okButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        
        leadingGuide.widthAnchor.constraint(equalTo: middleGuide.widthAnchor).isActive = true
        leadingGuide.widthAnchor.constraint(equalTo: trailingGuide.widthAnchor).isActive = true
        
        // vertical position
        
//        NSLayoutConstraint.activate([
//            leadingGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            middleGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            trailingGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
//
        
        //  bottom position
        NSLayoutConstraint.activate([
            leadingGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            middleGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            trailingGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
            ])
        
        // 레이블이나 버튼은 text에 따라서 자동으로 width, height 지정되는데 layoutGuide는 그렇지 않다. 그래서 heightAnchor를 1로 임시로 지정해주면 AutoLayout가 그들의 크기를 아 수 있다.
        NSLayoutConstraint.activate([
            leadingGuide.heightAnchor.constraint(equalToConstant: 1),
            middleGuide.heightAnchor.constraint(equalToConstant: 1),
            trailingGuide.heightAnchor.constraint(equalToConstant: 1)])
    }
    
}

extension UIColor {
    
    static let darkBlue = UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1)
    static let darkGreen = UIColor(red: 48/255, green: 209/255, blue: 88/255, alpha: 1)
    
}
