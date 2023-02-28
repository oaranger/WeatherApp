//
//  WeatherFetcherMock.swift
//  JPMorgan_WeatherAppTests
//
//  Created by Binh Huynh on 2/27/23.
//

import XCTest
import CoreLocation
@testable import JPMorgan_WeatherApp

struct WeatherFetcherMock: WeatherFetchable {
    func getWeather(for city: String) async throws -> CurrentWeather {
        CurrentWeather.sampple
    }
    
    func getWeather(for location: CLLocation) async throws -> CurrentWeather {
        CurrentWeather.sampple
    }
}

extension CurrentWeather {
    static let sampple = CurrentWeather(
        main: CurrentWeather.Main(
            temp: 50,
            temp_min: 40,
            temp_max: 60,
            humidity: 80),
        weather: [CurrentWeather.Weather(description: "Cloudy", icon: "10d")],
        name: "Cupertino",
        sys: CurrentWeather.Sys(country: "US")
    )
}
