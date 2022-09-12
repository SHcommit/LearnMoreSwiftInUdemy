//
//  CalculatorAppTests.swift
//  CalculatorAppTests
//
//  Created by 양승현 on 2022/09/12.
//

import XCTest
@testable import CalculatorApp
/*
    setUp() 함수는 이미 XCTestCase에 추가되어 있는 함수이다.
    -> super.setUP() 호출해야 한다.
    각각의 테스트<testSubstractTwoNumbers(),testAddTwoNumbers()>가 실행되기 전에 setUp() 이 실행된다.
    즉 setUp()함수는 두번 실행된다.
 
    즉 중복 실행되는 Calculator() 인스턴스는 setUp()에서 초기화 될 경우 두개의 단위 테스트가 실행되기 이전에 초기화가 될 것이다.
 
 */
class CalculatorAppTests: XCTestCase {
    
    private var calculator: Calculator!
    override func setUp() {
        super.setUp()
        
        self.calculator = Calculator()
        
    }
    func testSubstractTwoNumbers() {
        let result = self.calculator.subtract(5,2)
        XCTAssertEqual(result, 3)
    }
    
    func testAddTwoNumbers() {
        let result = self.calculator.add(2,3)
        XCTAssertEqual(result, 5)
    }

}
