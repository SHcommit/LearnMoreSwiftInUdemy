import UIKit
class WeatherListViewModel {
    private var list = [WeatherViewModel]()
    
    func addWeatherViewModel(_ vm: WeatherViewModel) {
        list.append(vm)
    }
    
}

class WeatherViewModel {
    private let weather: WeatherResponse
    init(weather: WeatherResponse) {
        self.weather = weather
        temperature = weather.main.temp
    }
    
    var city: String {
        return weather.local
    }
    
    var temperature: Double

}

//MARK: -  TableView's data
extension WeatherListViewModel {
    
    func numberOfRows(_ section: Int) -> Int {
        return list.count
    }
    
    func modelAt(_ index: Int) -> WeatherViewModel {
        return list[index]
    }
    
    func setupCellData(cell: UITableViewCell, index: Int, listModel: WeatherListViewModel) {
        let data = listModel.modelAt(index)
        cell.textLabel?.text = data.city
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        cell.detailTextLabel?.text = "\(data.temperature)°"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 25)
    }
    
    private func toCelcius() {
        
        list = list.map { vm in
            let weatherModel = vm
            weatherModel.temperature = round((weatherModel.temperature - 32) * 5/9)
            return weatherModel
        }
        
    }
    
    private func toFahrenheit() {
        list = list.map { vm in
            let weatherModel = vm
            weatherModel.temperature = round((weatherModel.temperature * 9/5) + 32)
            return weatherModel
        }
    }
    
    func updateUnit(to unit: Unit) {
        switch unit {
        case .celsius:
            toCelcius()
        case .fahrenheit:
            toFahrenheit()
        }
    }
}
