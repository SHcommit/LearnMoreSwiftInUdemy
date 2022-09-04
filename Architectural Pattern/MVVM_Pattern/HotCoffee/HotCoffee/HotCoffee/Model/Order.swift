//
//  Order.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/03.
//


enum coffeeType: String, Codable{
    case cappuccino
    case lattee
    case espressino
    case cortado
    
}
enum coffeeSize: String, Codable{
    case small
    case medium
    case large
    
    enum CodingKeys: String, CodingKey {
        case small = "s"
        case medium = "m"
        case large = "l"
    }
}
struct Order: Codable {
    let email: String!
    let name : String!
    let size : coffeeSize!
    let type : coffeeType!
    
    enum CodingKeys: String, CodingKey{
        case name = "Name"
        case email = "Email"
        case type  = "Type"
        case size  = "Size"
    }
/*
 let values = try decoder.container(keyedBy: CodingKeys.self)
 email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
 name  = try values.decodeIfPresent(String.self, forKey: .name)  ?? "Guest"
 
 size  = try values.decodeIfPresent(coffeeSize.self, forKey: .size) ?? .small
 type  = try values.decodeIfPresent(coffeeType.self, forKey: .type) ?? .lattee
 */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        name  = try values.decodeIfPresent(String.self, forKey: .name)  ?? "Guest"
        let orignalSize = try values.decodeIfPresent(String.self, forKey: .size)
        size = coffeeSize(rawValue: orignalSize ?? coffeeSize.small.rawValue) ?? .small
        let orignalType = try values.decodeIfPresent(String.self, forKey: .type)
        type = coffeeType(rawValue: orignalType ?? coffeeType.lattee.rawValue) ?? .lattee
        
    }
}
