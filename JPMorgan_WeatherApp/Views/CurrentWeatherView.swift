//
//  CurrentWeatherView.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

import SwiftUI

struct CurrentWeatherView: View {
    let viewModel: CurrentWeatherViewModel
    
    init(viewModel: CurrentWeatherViewModel?) {
        self.viewModel = viewModel ?? CurrentWeatherViewModel(currentWeather: CurrentWeather._default)
    }
    
    var body: some View {
        Text(viewModel.cityAndCountry)
            .font(.largeTitle)
        AsyncImageWithCache(iconCode: viewModel.iconCode)
        Text(viewModel.description)
            .font(.headline)
            .padding(.bottom)
        VStack(alignment: .leading) {
            HStack {
                Text("☀️ Temperature:")
                Text(viewModel.temperature)
                    .foregroundColor(.white)
            }
            HStack {
                Text("📈 Max temperature:")
                Text(viewModel.maxTemperature)
                    .foregroundColor(.white)
            }
            HStack {
                Text("📉 Min temperature:")
                Text(viewModel.minTemperature)
                    .foregroundColor(.white)
            }
            HStack {
                Text("💧 Humidity:")
                Text(viewModel.humidity)
                    .foregroundColor(.white)
            }
        }
    }
}
