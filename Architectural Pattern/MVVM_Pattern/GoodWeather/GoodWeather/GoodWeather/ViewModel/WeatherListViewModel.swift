class WeatherListViewModel {
    private var list = [WeatherViewModel]()
    
    func addWeatherViewModel(_ vm: WeatherViewModel) {
        list.append(vm)
    }
    
}

class WeatherViewModel {
    let weather: WeatherResponse
    init(weather: WeatherResponse) {
        self.weather = weather
    }
    
    var city: String {
        return weather.local
    }
    
    var temperature: Double {
        return weather.main.temp
    }
}

//MARK: -  TableView's data
extension WeatherListViewModel {
    
    func numberOfRows(_ section: Int) -> Int {
        return list.count
    }
    
    func modelAt(_ index: Int) -> WeatherViewModel {
        return list[index]
    }
    
}
