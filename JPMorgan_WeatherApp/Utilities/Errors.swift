//
//  Errors.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/27/23.
//

import Foundation

enum WeatherError: LocalizedError {
    case parsing
    
    public var errorDescription: String? {
        switch self {
        case .parsing:
            return "There was error in decoding the retrieved weather data"
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidServerResponse
    case invalidURL
    
    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        }
    }
}
