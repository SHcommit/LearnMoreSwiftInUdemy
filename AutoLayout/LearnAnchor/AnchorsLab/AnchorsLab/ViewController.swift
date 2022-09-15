//
//  ViewController.swift
//  AnchorsLab
//
//  Created by 양승현 on 2022/09/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

//MARK: - setupSubviews
extension ViewController {
    
    func setupViews() {
        
        let upperLeftLabel = makeLabel(withText: "upperLeft")
        let upperRightLabel = makeLabel(withText: "upperRight")
        let lowerLeftLable = makeLabel(withText: "lowerLeft")
        let button = makeButton(withText: "Pay Bill")
        let centerView = makeView()
        
        self.view.addSubview(upperLeftLabel)
        self.view.addSubview(upperRightLabel)
        self.view.addSubview(lowerLeftLable)
        self.view.addSubview(button)
        self.view.addSubview(centerView)
        
        setupUpperLeftLabelConstraints(upperLeftLabel)
        setupUpperRightLabelConstraints(upperRightLabel)
        setupLowerLeftLabelConstraints(lowerLeftLable)
        setupLowerRightButtonConstraints(button)
        setupCenterViewConatraints(centerView)
        
    }
    
    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.backgroundColor = label.text != "" ? .yellow : .red
        return label
    }
    
    func makeButton(withText text: String) -> UIButton {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.backgroundColor = .blue
        
        return button
    }
    
    func makeView() -> UIView{
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        
        return view
    }
    
}

//MARK: - setupConstraints
extension ViewController {
    
    func setupUpperLeftLabelConstraints(_ label: UILabel) {
        label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: +10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
    }
    
    func setupUpperRightLabelConstraints(_ label: UILabel) {
        label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10).isActive = true
    }
    
    func setupLowerLeftLabelConstraints(_ label: UILabel) {
        label.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10 ).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
    }
    
    func setupLowerRightButtonConstraints(_ button: UIButton) {
        button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
    }
    
    func setupCenterViewConatraints(_ view: UIView) {
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        //Option 1. 명시적으로 size 할당
            //view.heightAnchor.constraint(equalToConstant: 100).isActive = true
            //view.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        //Option 2. Size dynamically ( use pinning)
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:  -20).isActive = true
        
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
    }
}
