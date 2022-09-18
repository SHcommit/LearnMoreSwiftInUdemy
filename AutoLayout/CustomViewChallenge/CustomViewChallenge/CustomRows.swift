//
//  CustomRow.swift
//  CustomViewChallenge
//
//  Created by 양승현 on 2022/09/18.
//  Copyright © 2022 Rasmusson Software Consulting. All rights reserved.
//

import UIKit

class RowView: UIView {
    
    var title: String
    var isOn: Bool
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
        
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubViews()
    }
    
    func setupSubViews() {
        
        let titleLabel = makeLabel(withText: title)
        let onOffSwitch = makeSwitch(isOn: isOn)
        
        addSubview(titleLabel)
        addSubview(onOffSwitch)
        setupRowViewConstraint(leading: titleLabel, trailing: onOffSwitch)
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 31)
    }
}

//MARK: - setup subview's constraint
extension RowView {
    
    func setupRowViewConstraint(leading label: UILabel, trailing onOffSwitch: UISwitch) {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            onOffSwitch.topAnchor.constraint(equalTo: topAnchor),
            onOffSwitch.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
}
 

class CrossView: UIView {
    
    let centerTitle: String
    let startTitle: String
    let endTitle: String
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
    init(center title: String, left startTitle: String, right endTitle: String) {
        centerTitle = title
        self.startTitle = startTitle
        self.endTitle = endTitle
        super.init(frame: .zero)
        setupSubViews()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSubViews() {
        let upperLabel = makeBoldLabel(withText: centerTitle)
        let startLabel = makeLabel(withText: startTitle)
        let progressView = makeProgressView()
        let endLabel = makeLabel(withText: endTitle)
        
        var stackView = makeStackView(withOrientation: .horizontal)
        stackView.addArrangedSubview(startLabel)
        stackView.addArrangedSubview(progressView)
        stackView.addArrangedSubview(endLabel)
        addSubview(upperLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            upperLabel.topAnchor.constraint(equalTo: topAnchor),
            upperLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 61)
    }

}
