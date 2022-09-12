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
    테스트 코드 또한 깔끔해야한다.
 
    지금 코드에서 개선해야 할 점.
    Calculator 인스턴스를 두 번 생성한다. 각 테스트가 실행되기 전에 무언가를 시도 하려고하면
    setup func를 오버로딩해서 그곳에 집어넣으면 된다.
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
