//
//  SerttingViewModelTests.swift
//  GoodWeatherTests
//
//  Created by 양승현 on 2022/09/12.
//

import XCTest
@testable import GoodWeather
/*
    TODO: 새로운 지역을 추가했을때 기본적인 단위가 화씨인지 섭씨인지 확인하고 싶다.
 
    1. 새로운 Object를 생성하면 default로 화씨가 설정됬는지 확인하고 싶다.
    함수 네이밍은 자세하게! 왜냐면 실패했을때 그 이유를 분명히 알 수 있기 때문
 
    2. 디스플레이 name에 관한 테스트 (화씨 이면 화씨)
 
    3. 사용자의 선택 저장 ( SettingViewController에서 _selectedUnit을 선택했을 때 set을 통해 영구저장소에 저장됬는데 이게 정말 되는지
 
        3에서 영구 저장소를 사용했기에 이를 지워야한다.
 */
class SerttingViewModelTests: XCTestCase {
    
    private var settingVM: SettingViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.settingVM = SettingViewModel()
    }
    
    func test_should_make_sure_that_default_selected_unit_is_fahrenheit() {
        
        XCTAssertEqual(settingVM.selectedUnit, .fahrenheit)
    }

    func test_should_return_correct_display_name_for_fahrenheit() {
        
        XCTAssertEqual(self.settingVM.selectedUnit.displayType, "Fahrenheit")
        
    }
    
    func test_should_be_able_to_save_user_unit_selection() {
        
        settingVM.selectedUnit = .celsius
        let ud = UserDefaults.standard
        XCTAssertNotNil(ud.value(forKey: "unit"))
        
    }
    
    //MARK: - clear test logic
    
    override func tearDown() {
        super.tearDown()
        
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "unit")
    }
}
