//
//  UserHelpLabelAndButton.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//

import UIKit

class UserHelpLabelAndButton {
    
    //MARK: - Properties
    private var firstLabel: UILabel?
    private var secondButton: UIButton?
    
    var getProperties : [UIView] {
        get {
            guard let firstLabel = firstLabel, let secondButton = secondButton else {
                fatalError()
            }
            return [firstLabel,secondButton]
        }
    }
    
    //MARK: - Life cycle
    init(first text: String, second title: String) {
        firstLabel = initialFirstLabel(text)
        secondButton = initialSecondButton(title)
    }
}

//MARK: - initial properties
extension UserHelpLabelAndButton {
    
    private func initialFirstLabel(_ text: String) -> UILabel {
        let lb = UILabel()
        lb.textColor = .white
        lb.text = text
        lb.font = .systemFont(ofSize: 13)
        return lb
    }
    
    private func initialSecondButton(_ text: String) -> UIButton {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle(text, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        btn.layer.cornerRadius =  5
        
        return btn
    }
    
}


//MARK: - Helpers
extension UserHelpLabelAndButton {
    
    func addTargetSecondButton(eventHandler: Selector) {
        secondButton?.addTarget(self, action: eventHandler, for: .touchUpInside)
    }
    
    
}
