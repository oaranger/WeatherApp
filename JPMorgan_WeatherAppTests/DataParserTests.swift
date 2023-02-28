//
//  DataParserTests.swift
//  JPMorgan_WeatherAppTests
//
//  Created by Binh Huynh on 2/27/23.
//

import Foundation
import XCTest
@testable import JPMorgan_WeatherApp

final class DataParserTests: XCTestCase {
    var parser: DataParser!
    
    override func setUp() {
        super.setUp()
        parser = DataParser()
    }
    
    override func tearDown() {
        super.tearDown()
        parser = nil
    }
    
    func testParsingDate() throws {
        guard let path = Bundle.main.path(forResource: "weatherMock", ofType: ".json") else { return }
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let current: CurrentWeather = try parser.parse(data: data)
        XCTAssertEqual(current.name, "Cupertino")
        XCTAssertEqual(current.weather.description, "overcast clouds")
        XCTAssertEqual(current.weather.first?.icon ?? "", "04d")
        XCTAssertEqual(current.main.temp, 282.43)
        XCTAssertEqual(current.main.temp_min, 280.2)
        XCTAssertEqual(current.main.temp_max, 283.78)
        XCTAssertEqual(current.main.humidity, 79)
        XCTAssertEqual(current.sys.country, "US")
    }
}
