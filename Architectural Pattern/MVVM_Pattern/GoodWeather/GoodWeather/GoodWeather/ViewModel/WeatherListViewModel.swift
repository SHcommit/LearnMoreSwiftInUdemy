class WeatherListViewModel {
    var list = [WeatherViewModel]()
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

