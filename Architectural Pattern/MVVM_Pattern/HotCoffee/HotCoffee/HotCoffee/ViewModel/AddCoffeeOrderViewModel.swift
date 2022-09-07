//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/07.
//

import Foundation


struct AddCoffeeOrderViewModel {
    //이건 save시 저장될 user's choice 데이터
    var name: String?
    var email: String?
    var selectedType: String?
    var selectedSize: String?
    
    
    // CoffeeType에 CaseIterable을 채택함으로 모든 케이스의 enum을 반환할 수 있다.
    // 근데 열거형의 rawValue를해야 string이되는데 capitalized를 통해 String을 얻을 수 있다.
    //이건 테이블에 보여주기 위한 데이터 또는!! 사용자가 특정한거 선택했을때 해당되는 index가 주어지는데 이를 이용하기 위한 배열
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
