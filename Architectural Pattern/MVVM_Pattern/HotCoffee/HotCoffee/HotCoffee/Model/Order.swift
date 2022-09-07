//
//  Order.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/03.
//

/**
 *decodeIfPresnt nil 반환 o
 *decode nil 반환 x
 */

enum CoffeeType: String, Codable {
    case cappuccino
    case latte
    case espressino
    case cortado
   
    init(from decoder: Decoder) throws {
        //싱글 벨류 컨테이너는 single value의 데이터를 디코딩할때 사용한다. 커스텀 format에서 디코딩 데이터는 자주 사용된다.
        let label = try decoder.singleValueContainer().decode(String.self)
        let lowercaseLabel = label.lowercased()
        self = CoffeeType(rawValue: lowercaseLabel) ?? .latte
    }
}
enum CoffeeSize: String, Codable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let email: String
    let name : String
    let size : CoffeeSize
    let type : CoffeeType
    
    enum CodingKeys: String, CodingKey {
        case name 
        case email
        case type
        case size
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        name  = try values.decodeIfPresent(String.self, forKey: .name)  ?? "Guest"
        size  = try values.decode(CoffeeSize.self, forKey: .size)
        type  = try values.decode(CoffeeType.self, forKey: .type)
    }
}
