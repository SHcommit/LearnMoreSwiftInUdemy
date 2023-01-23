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
    var placeholderLabel: UILabel!
    var textDelegate: InputTextCountDelegate?
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
        
    }
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                UtilsUI.setupConstraints(with: placeholderLabel) {
                    [$0.leading.constraint(equalTo: leading,constant: 8),
                     $0.centerY.constraint(equalTo: centerY)]
                }
            }else {
                UtilsUI.setupConstraints(with: placeholderLabel) {
                    [$0.leading.constraint(equalTo: leading,constant: 8)]
                }
            }
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureSubviews()
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

//MARK: - ConfigureSubviewsCase
extension InputTextView: ConfigureSubviewsCase {
    func configureSubviews() {
        delegate = self
        createSubviews()
        addSubviews()
        setupLayouts()
    }
    
    func createSubviews() {
        placeholderLabel = UILabel()
    }
    
    func addSubviews() {
        addSubview(placeholderLabel)
    }
    
    func setupLayouts() {
        setupSubviewsLayouts()
        setupSubviewsConstraints()
    }
    
}

//MARK: - SetupSubviewsLayouts
extension InputTextView: SetupSubviewsLayouts {
    
    func setupSubviewsLayouts() {
        
        ///Setup placeholderLabel layout
        UtilsUI.setupLayout(detail: placeholderLabel) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .lightGray
        }
    }
    
}

//MARK: - SetupSubviewsConstraints
extension InputTextView: SetupSubviewsConstraints {
    
    func setupSubviewsConstraints() {
    
        ///Setup placeholderLabel constraints
        UtilsUI.setupConstraints(with: placeholderLabel) {
            [$0.top.constraint(equalTo: top,
                               constant: INPUT_TEXT_VIEW_DEFAULT_MARGIN*2),
             $0.leading.constraint(equalTo: leading,
                                   constant: INPUT_TEXT_VIEW_DEFAULT_MARGIN*2)]
        }
    }
    
}
