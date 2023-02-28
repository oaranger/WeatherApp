//
//  CurrentWeatherViewModel.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/27/23.
//

import Foundation

struct CurrentWeatherViewModel {
    private let currentWeather: CurrentWeather
    
    init(currentWeather: CurrentWeather = CurrentWeather._default) {
        self.currentWeather = currentWeather
    }
    
    var cityAndCountry: String {
        cityName + (cityName.isEmpty ? "" : ", ") + countryName
    }
    
    var description: String {
        currentWeather.weather.first?.description ?? ""
    }
    
    var cityName: String {
        currentWeather.name
    }
    
    var countryName: String {
        currentWeather.sys.country
    }
    
    var iconCode: String {
        currentWeather.weather.first?.icon ?? ""
    }
    
    var temperature: String {
        String(format: "%.2f", currentWeather.main.temp) + "°"
    }
    
    var maxTemperature: String {
        String(format: "%.2f", currentWeather.main.temp_max) + "°"
    }
    
    var minTemperature: String {
        String(format: "%.2f", currentWeather.main.temp_min) + "°"
    }
    
    var humidity: String {
        String(currentWeather.main.humidity)
    }
}
