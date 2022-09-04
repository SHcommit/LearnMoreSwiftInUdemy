//
//  Order.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/03.
//


//struct Order: Codable {
//    let email: String
//    let name : String
//    let size : CoffeeSize
//    let type : CoffeeType
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
//        name  = try values.decodeIfPresent(String.self, forKey: .name)  ?? "Guest"
//        size  = try values.decode(CoffeeSize.self, forKey: .size)
//        type  = try values.decode(CoffeeType.self, forKey: .type)
//    }
//}
//
//enum CoffeeType: String, Codable {
//    case cappuccino
//    case latte
//    case espressino
//    case cortado
//
//    init(from decoder: Decoder) throws {
//        let label = try decoder.singleValueContainer().decode(String.self)
//        let lowercaseLabel = label.lowercased()
//        self = CoffeeType(rawValue: lowercaseLabel) ?? .latte
//    }
//}
//
//enum CoffeeSize: String, Codable {
//    case small
//    case medium
//    case large
//}

enum CoffeeType: String, Codable {
    case cappuccino
    case latte
    case espressino
    case cortado
   
    init(from decoder: Decoder) throws {
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        name  = try values.decodeIfPresent(String.self, forKey: .name)  ?? "Guest"
        size  = try values.decode(CoffeeSize.self, forKey: .size)
        type  = try values.decode(CoffeeType.self, forKey: .type)
    }
}
/*
The problem with your code is case-sensitive properties.
If the API returns these keys
Name,
Type,
Email,
Size,
Type,
then the Codable object should have the coding Keys to handle keys from API ```
struct Order: Codable {
    let email: String
    let name : String
    let size : CoffeeSize
    let type : CoffeeType
    enum CodingKeys: String, CodingKey{
        case name = "Name"
        case email = "Email"
        case type = "Type"
        case size = "Size"
        
    }
} ```
*/
