//
//  CombineUtils.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import UIKit
import Combine

class UtilsCombine {
    
    static func textfieldNotificationPublisher(withTF textField: UITextField) -> AnyPublisher<String,NotificationCenter.Publisher.Failure> {
        return NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification,object: textField)
            .map { return ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }

}
