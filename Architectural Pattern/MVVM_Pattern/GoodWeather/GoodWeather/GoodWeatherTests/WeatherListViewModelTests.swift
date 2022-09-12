//
//  WeatherListViewModelTests.swift
//  GoodWeatherTests
//
//  Created by 양승현 on 2022/09/12.
//

import XCTest
@testable import GoodWeather

/*
    1. addWeatherViewModel(_:) 는 단순히 list에 VM한개를 추가하는데 이를 테스트 할 수 있는데
        비즈니스 관점에서 본다면  단순히 배열에 추가하는 것인데 이를 테스트하는 것은 나에게 가치 있는 테스트인가?
        NO!!
        단순히 배열 추가인데 단위 테스트 의미 없다.
    > 테스트해야 할 것은 실제 로직이어야 한다.
 
    In WeatherListViewModel.swift에서 가장 큰 로직은
        - mutating private func toCelsius()
        - mutating private func toFahrenheit()
        함수이다. 이 두 로직은 의미 깊기에 테스트 할 가치가 있다.
 
    TODO: 2. 온도가 섭씨인지 화씨인지, 성공적으로 convert할수 있는지 테스트 해보자.
        테스트를 하기 위해선 몇가지 정보가 필요하다. list에 저장된 vm 한개라던지,, weather정보 etc
 
 */
class WeatherListViewModelTests: XCTestCase {

    private var weatherListVM: WeatherListViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.weatherListVM = WeatherListViewModel()
        setupWeatherListVM()
    }
    
    func setupWeatherListVM() {
        self.weatherListVM.addWeatherViewModel(WeatherViewModel(weather: WeatherResponse(local: "Seoul", sys: .init(country: "Korea"), main: .init(temp: 32, humidity: 0))))
        
        self.weatherListVM.addWeatherViewModel(WeatherViewModel(weather: WeatherResponse(local: "Daejeon", sys: .init(country: "Korea"), main: .init(temp: 72, humidity: 0))))
    }
    
    override func tearDown() {
        <#code#>
    }
}
