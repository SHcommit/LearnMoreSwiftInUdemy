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
    
    //MARK: - 기본 제공 함수들
    
    // test 가 실행된 후에 실행되는 함수
    // 이 함수는 db에서 무언가를 작성하거나, 파일을 작성한 후에 테스트가 실행될 경우.
    // 내가 실행한 테스트들을 삭제하는 로직을 tearDown()에서 할 수 있다.
    // 테스트가 실제로 변경되지않도록!!! 삭제하는 로직을
    
    //만약 UserDefaults.default 나중에 사용할 수 있는 영구저장소를 test로 쓰고 있다면
    // tearDown()에서 userDefaults값을 삭제할 수 있다.
    override func tearDown() {
        super.tearDown()
    }
    
    // 따라서 테스트는 한가지만 테스트하고 tearDown()을 통해 제거하는 원칙을 따른다.
    // 신뢰할 수 없을때 하는게 test이다.
}
