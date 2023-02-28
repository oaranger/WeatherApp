//
//  CurrentWeatherSearchViewModel.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

import Foundation
import Combine
import CoreLocation

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = UserDefaults.standard.string(forKey: AppUserDefaultKeys.lastSearch) ?? ""
    @Published private(set) var currentWeatherViewModel: CurrentWeatherViewModel?
    @Published private(set) var isSearching = false
    private var searchTask: Task<Void, Never>?
    private let weatherFetchable: WeatherFetchable
    
    init(weatherFetchable: WeatherFetchable) {
        self.weatherFetchable = weatherFetchable
        
        $searchText
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { output in
                self.isSearching = true
            })
            .flatMap { value in
                Future { promise in
                    Task {
                        let current = await self.search(matching: value)
                        if let current = current {
                            promise(.success(current))
                        }
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .handleEvents(receiveOutput: { output in
                self.isSearching = false
            })
            .compactMap {CurrentWeatherViewModel(currentWeather: $0)}
            .assign(to: &$currentWeatherViewModel)
    }
    
    private func search(matching searchTerm: String) async -> CurrentWeather? {
        let currentSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
        do {
            let current = try await weatherFetchable.getWeather(for: currentSearchTerm)
            return current
        } catch {
            print(error.localizedDescription)
        }
        return nil
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
                    let currentWeather = try await weatherFetchable.getWeather(for: currentSearchTerm)
                    currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: currentWeather)
                } catch {
                    print(error.localizedDescription)
                }
                UserDefaults.standard.set(currentSearchTerm, forKey: AppUserDefaultKeys.lastSearch)
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
