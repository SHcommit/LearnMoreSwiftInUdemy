//
//  Order.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/03.
//

import Foundation

/**
 *decodeIfPresnt nil 반환 o
 *decode nil 반환 x
 *CaseIterable타입은 반복해서 enum유형을 반환할수있다.
 */

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

extension Order {
    init?(_ vm: AddCoffeeOrderViewModel) {
        //type, size의 경우에는 단순히 string이 아니라 CoffeeType struct이기때문에 rawvalue로 인스턴스 생성해야함
        guard let name = vm.name ,
              let email = vm.email,
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
            return nil
        }
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}


extension Order {
    static let url :String = "https://warp-wiry-rugby.glitch.me/orders"
    // 유저가 선택한 거 한 개 주문 POST로 전송
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        guard let order = Order(vm) else {fatalError()}
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order")
        }
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        return resource
    }
    
    static var all: Resource<[Order]> = {
        return Resource<[Order]>(url: url)
    }()
}

enum CoffeeType: String, Codable ,CaseIterable {
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
enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        let lowercaseLabel = value.lowercased()
        self = CoffeeSize(rawValue: lowercaseLabel) ?? .small
        
    }
}
