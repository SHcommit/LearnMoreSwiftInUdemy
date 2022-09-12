//
//  CalculatorAppTests.swift
//  CalculatorAppTests
//
//  Created by 양승현 on 2022/09/12.
//

import XCTest
@testable import CalculatorApp
/*
  이렇게 통과한 테스트 코드를 이제 리펙토링한다.
 */
class CalculatorAppTests: XCTestCase {

    func testSubstractTwoNumbers() {
        let calculator = Calculator()
        let result = calculator.subtract(5,2)
        
        XCTAssertEqual(result, 3)
    }
    
    func testAddTwoNumbers() {
        let calculator = Calculator()
        let result = calculator.add(2,3)
        /*
            2+3은 5를 수행할 것이다! 내가 계산한 것과 Calculator의 로직이 맞는지 test가 가능하다.
         */
        XCTAssertEqual(result, 5)
    }

}
