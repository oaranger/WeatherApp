//
//  WeatherFetcher.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

import Foundation
import Combine
import CoreLocation

protocol WeatherFetchable {
    func getWeather(for city: String) async throws -> CurrentWeather
    func getWeather(for location: CLLocation) async throws -> CurrentWeather
}

class WeatherFetcher {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension WeatherFetcher: WeatherFetchable {
    func getWeather(for city: String) async throws -> CurrentWeather {
        let urlComponents = createCurrentWeatherURLComponents(for: city)
        let weather = try await getWeather(urlComponents: urlComponents)
        return weather
    }
    
    func getWeather(for location: CLLocation) async throws -> CurrentWeather {
        let urlComponents = createCurrentWeatherURLComponents(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        let weather = try await getWeather(urlComponents: urlComponents)
        return weather
    }
    
    func getWeather(urlComponents: URLComponents) async throws -> CurrentWeather {
        guard let url = urlComponents.url else { throw  NetworkError.invalidURL }
        let (data, response) = try await session.data(for: URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        do {
            let decoded: CurrentWeather = try parser.parse(data: data)
            return decoded
        } catch {
            throw WeatherError.parsing
        }
    }
}

private extension WeatherFetcher {
    var parser: DataParserProtocol {
        return DataParser()
    }
}

private extension WeatherFetcher {
    func createCurrentWeatherURLComponents(for city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = APIConstants.scheme
        components.host = APIConstants.host
        components.path = APIConstants.path + "/weather"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: "\(city),us"),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "appid", value: APIConstants.key)
        ]
        
        return components
    }
    
    func createCurrentWeatherURLComponents(lat: Double, lon: Double) -> URLComponents {
        var components = URLComponents()
        components.scheme = APIConstants.scheme
        components.host = APIConstants.host
        components.path = APIConstants.path + "/weather"
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(String(describing: lat))"),
            URLQueryItem(name: "lon", value: "\(String(describing: lon))"),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "appid", value: APIConstants.key)
        ]
        
        return components
    }
}

