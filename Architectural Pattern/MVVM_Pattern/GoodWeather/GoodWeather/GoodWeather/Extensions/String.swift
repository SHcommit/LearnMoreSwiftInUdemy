//
//  String.swift
//  GoodWeather
//
//  Created by μμΉν on 2022/09/11.
//

import Foundation

extension String {
    func escaped() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
