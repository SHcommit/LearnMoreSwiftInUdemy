//
//  Calculator.swift
//  CalculatorApp
//
//  Created by 양승현 on 2022/09/12.
//

/*
    이 클래스를 CalculatorAppTests에서도 호출할 수 있는 경우는?
    1. Identity and Type 탭에서 CalculatorAppTests 타게팅 체크
    2. CalculatorAppTests.swift에서 @testable import CalculatorApp 프로젝트 임포트하기
 */
class Calculator {
    
    func add(_ a: Int, _ b: Int) -> Int {
        return a+b
    }
    
    func subtract(_ a: Int, _ b: Int) -> Int {
        return a-b
    }
}
