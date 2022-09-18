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
        
        setupSubViews()
    }
    
    func setupSubViews() {
        let titleLabel = makeLabel(withText: title)
        let onOffSwitch = makeSwitch(isOn: isOn)
        
        addSubview(titleLabel)
        addSubview(onOffSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            onOffSwitch.topAnchor.constraint(equalTo: topAnchor),
            onOffSwitch.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 31)
    }
    
}
