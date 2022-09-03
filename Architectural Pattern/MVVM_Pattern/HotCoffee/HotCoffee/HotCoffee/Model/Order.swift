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
    case americano
    
}
enum coffeeSize: String, Codable{
    case small
    case medium
    case large
}
struct Order: Codable {
    let name : String
    let email: String
    let type : coffeeType
    let size : coffeeSize
}
