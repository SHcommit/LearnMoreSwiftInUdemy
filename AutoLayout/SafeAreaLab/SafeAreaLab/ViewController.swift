//
//  ViewController.swift
//  SafeAreaLab
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



//MARK: - setupSubveiws
extension ViewController {
    
    func setupViews() {
        
        let topLabel = makeLabel(withText: "top")
        let bottomLabel = makeLabel(withText: "bottom")
        let leadingLabel = makeLabel(withText: "leading")
        let trailingLabel = makeLabel(withText: "trailing")
        
        setupTopLabelConstraints(label: topLabel)
        setupBottomLabelConstraints(label: bottomLabel)
        setupLeadingLabelConstraints(label: leadingLabel)
        setupTrailingLabelConstraints(label: trailingLabel)
    }
}


// MARK: - makeControls
extension ViewController {
    
    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }
    
}

// MARK: - setupConstraints
extension ViewController {
    
    func setupTopLabelConstraints(label: UILabel) {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
    }
    
    func setupBottomLabelConstraints(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    func setupLeadingLabelConstraints(label: UILabel) {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    func setupTrailingLabelConstraints(label: UILabel) {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:8),
                                     label.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
    }
}
