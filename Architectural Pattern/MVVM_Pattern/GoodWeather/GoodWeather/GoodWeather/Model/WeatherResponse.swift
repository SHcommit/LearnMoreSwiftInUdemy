struct WeatherResponse: Codable {
    let local: String
    let sys: sys
    let main: mainInfo
    enum CodingKeys: String,CodingKey {
        case local = "name"
        case sys
        case main
    }
}
struct sys: Codable{
    let country: String
}

struct mainInfo: Codable{
    let temp: Double
    let humidity: Int
}
