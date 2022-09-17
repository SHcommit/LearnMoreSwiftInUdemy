//
//  ViewController.swift
//  CHCRLab
//
//  Created by 양승현 on 2022/09/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
    }


}

//MARK: - makeContents
extension ViewController {
    
    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.backgroundColor = .yellow
        
        return label
    }
    
    func makeTextField(withPlaceHolderText text: String) -> UITextField {
        let textField  = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = text
        textField.backgroundColor = .lightGray
        
        return textField
    }
}


//MARK: - setupSubviews
extension ViewController {
    
    func setupViews() {
        let nameLabel = makeLabel(withText: "Name")
        let textField = makeTextField(withPlaceHolderText: "Input user's name")
        
        setupNameLabelConstraint(label: nameLabel)
        setupTextFieldConstraint(tf: textField, targetConstraint: nameLabel)
    }
    
}

// MARK: - 제약 추가해야쥥,..
extension ViewController {
    
    func setupNameLabelConstraint(label: UILabel) {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)])
        
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
    }
    
    func setupTextFieldConstraint(tf: UITextField, targetConstraint label: UILabel ) {
        view.addSubview(tf)
        
        NSLayoutConstraint.activate([
            tf.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            tf.firstBaselineAnchor.constraint(equalTo: label.firstBaselineAnchor),
            tf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)])
        
    }
}
