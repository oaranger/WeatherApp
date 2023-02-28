//
//  CurrentWeatherSearchViewModel.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

import Foundation
import CoreLocation

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = UserDefaults.standard.string(forKey: AppUserDefaultKeys.lastSearch) ?? ""
    @Published private(set) var currentWeatherViewModel: CurrentWeatherViewModel?
    @Published private(set) var isSearching = false
    private var searchTask: Task<Void, Never>?
    private let weatherFetchable: WeatherFetchable
    
    init(weatherFetchable: WeatherFetchable) {
        self.weatherFetchable = weatherFetchable
    }
    
    @MainActor
    func search() async {
        searchTask?.cancel()
        let currentSearchTerm = searchText.trimmingCharacters(in: .whitespaces)
        if currentSearchTerm.isEmpty {
            isSearching = false
        } else {
            searchTask = Task {
                isSearching = true
                do {
                    let currentWeather = try await weatherFetchable.getWeather(for: searchText)
                    currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: currentWeather)
                } catch {
                    print(error.localizedDescription)
                }
                UserDefaults.standard.set(searchText, forKey: AppUserDefaultKeys.lastSearch)
                if !Task.isCancelled {
                    isSearching = false
                }
            }
        }
    }
    
    @MainActor
    func search(location: CLLocation) async {
        searchTask?.cancel()
        searchTask = Task {
            isSearching = true
            do {
                let currentWeather = try await weatherFetchable.getWeather(for: location)
                currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: currentWeather)
            } catch {
                print(error.localizedDescription)
            }
            if !Task.isCancelled {
                isSearching = false
            }
        }

    }
}
