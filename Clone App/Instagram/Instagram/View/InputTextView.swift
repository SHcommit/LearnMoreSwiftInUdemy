//
//  InputTextView.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/10.
//

import UIKit

protocol InputTextCountDelegate {
    func inputTextCount(withCount cnt: Int)
}

class InputTextView: UITextView {
    
    //MARK: - Properties
    let placeholderLabel: UILabel = initPlaceholderLabel()
    var textDelegate: InputTextCountDelegate?
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
        
    }
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                NSLayoutConstraint.activate([
                    placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                    placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
            }else {
                NSLayoutConstraint.activate([
                    placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
                    placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8)])
            }
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InputTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if text.isEmpty {
            placeholderLabel.isHidden = false
        }else {
            placeholderLabel.isHidden = true
        }
        textDelegate?.inputTextCount(withCount: text.count)
    }
    
    
}

//MARK: - Setup subviews
extension InputTextView {
    
    func configureUI() {
        delegate = self
        addSubviews()
        setupSubviewConstraints()
    }
    
    func addSubviews() {
        addSubview(placeholderLabel)
    }
    
    func setupSubviewConstraints() {
        setupPlaceholderLabelConstraints()
    }
}

//MARK: - init properties
extension InputTextView {
    
    static func initPlaceholderLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .lightGray
        return lb
    }
    
}

//MARK: - AutoLaoout Constraints
extension InputTextView {
    
    func setupPlaceholderLabelConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: INPUT_TEXT_VIEW_DEFAULT_MARGIN*2),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: INPUT_TEXT_VIEW_DEFAULT_MARGIN*2)])
    }
    
}
