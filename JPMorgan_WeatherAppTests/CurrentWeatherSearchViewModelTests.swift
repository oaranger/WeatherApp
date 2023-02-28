//
//  CurrentWeatherSearchViewModelTests.swift
//  JPMorgan_WeatherAppTests
//
//  Created by Binh Huynh on 2/27/23.
//
import Foundation
import XCTest
import CoreLocation
@testable import JPMorgan_WeatherApp

@MainActor
final class CurrentSearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var weatherFetcher = WeatherFetcherMock()
    
    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel(weatherFetchable: weatherFetcher)
    }

    func testShouldStartWithNilViewModel() {
        XCTAssertNil(viewModel.currentWeatherViewModel)
    }
    
    func test_whenCompleteSearching_shouldDoneSearching() async {
        viewModel.searchText = "Cupertino"
        await viewModel.search()
        XCTAssertFalse(viewModel.isSearching)
    }

    func test_whenSearchCity_shouldRetrieveData() async throws {
        viewModel.searchText = "Cupertino"
        await viewModel.search()
        try await Task.sleep(nanoseconds: 1_000_000_000)
        XCTAssertEqual(viewModel.currentWeatherViewModel?.description ?? "", "Cloudy")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.cityName ?? "", "Cupertino")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.countryName ?? "", "US")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.iconCode ?? "", "10d")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.temperature ?? "", "50.00°")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.minTemperature ?? "", "40.00°")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.maxTemperature ?? "", "60.00°")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.humidity ?? "", "80")
    }
    
    func test_whenSearchLocation_shouldRetrieveData() async throws {
        await viewModel.search(location: CLLocation(latitude: 0.0, longitude: 0.0))
        try await Task.sleep(nanoseconds: 1_000_000_000)
        XCTAssertEqual(viewModel.currentWeatherViewModel?.description ?? "", "Cloudy")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.cityName ?? "", "Cupertino")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.countryName ?? "", "US")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.iconCode ?? "", "10d")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.temperature ?? "", "50.00°")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.minTemperature ?? "", "40.00°")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.maxTemperature ?? "", "60.00°")
        XCTAssertEqual(viewModel.currentWeatherViewModel?.humidity ?? "", "80")
    }
}
