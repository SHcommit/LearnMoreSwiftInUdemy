//
//  CalculatorAppTests.swift
//  CalculatorAppTests
//
//  Created by 양승현 on 2022/09/12.
//

import XCTest
@testable import CalculatorApp

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
    override func tearDown() {
        super.tearDown()
    }
}
