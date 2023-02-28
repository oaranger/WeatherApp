//
//  SearchView.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

import SwiftUI
import CoreLocationUI

enum AppUserDefaultKeys {
    static let lastSearch = "lastSearch"
}

struct SearchView: View {
    @StateObject var searchViewModel = SearchViewModel(weatherFetchable: WeatherFetcher())
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .blue, .white]),
                               startPoint: .bottomTrailing,
                               endPoint: .topLeading)
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text("")
                        .navigationTitle("Enter city name")
                        .searchable(
                            text: $searchViewModel.searchText,
                            placement: .navigationBarDrawer(displayMode: .always)
                        )
                    
                    Spacer()
                    CurrentWeatherView(viewModel: searchViewModel.currentWeatherViewModel)
                    LocationButton {
                        if locationManager.locationIsDisabled {
                            locationManager.requestWhenInUseAuthorization()
                        } else {
                            searchViewModel.searchText = ""
                            Task {
                                await searchViewModel.search(location: locationManager.lastSeenLocation)
                            }
                        }
                    }
                    .symbolVariant(.fill)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.vertical, 40)
                    .onAppear {
                        locationManager.updateAuthorizationStatus()
                    }
                    Spacer()
                }
                .overlay {
                    if searchViewModel.isSearching {
                        ProgressView()
                    }
                }
                .onAppear {
                    if locationManager.locationIsDisabled {
                        locationManager.requestWhenInUseAuthorization()
                    }
                }
            }
        }
    }
}
