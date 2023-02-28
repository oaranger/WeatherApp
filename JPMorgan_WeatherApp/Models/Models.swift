//
//  Models.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

struct CurrentWeather: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
    let sys: Sys
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Sys: Codable {
        let country: String
    }
}

extension CurrentWeather {
    static let _default = CurrentWeather(main: Main(temp: 0, temp_min: 0, temp_max: 0, humidity: 0), weather: [], name: "", sys: Sys(country: ""))
}
