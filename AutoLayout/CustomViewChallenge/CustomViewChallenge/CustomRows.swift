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
    var subTitle: String?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, isOn: Bool, subTitle: String) {
        self.title = title
        self.isOn = isOn
        self.subTitle = subTitle
        
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
        
        guard let subTitle = subTitle else {
            return
        }
        
        let subTitleLabel = makeSubLabel(withText: subTitle)
        addSubview(subTitleLabel)
        setupRowDetailViewConstraint(view: subTitleLabel, targetAnchor: titleLabel)
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
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            onOffSwitch.topAnchor.constraint(equalTo: topAnchor),
            onOffSwitch.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8)])
    }
    
    func setupRowDetailViewConstraint(view: UILabel, targetAnchor upperView: UILabel) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 32),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)])
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
        
        startLabel.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        progressView.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        endLabel.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        var stackView = makeStackView(withOrientation: .horizontal)
        stackView.addArrangedSubview(startLabel)
        stackView.addArrangedSubview(progressView)
        stackView.addArrangedSubview(endLabel)
        addSubview(upperLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            upperLabel.topAnchor.constraint(equalTo: topAnchor),
            upperLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
    }
}
