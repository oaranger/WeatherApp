//
//  ImageCache.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

import Foundation
import SwiftUI

class ImageCache {
    
    // Create a dictionary to store the images
    private var cache = [String: Image]()
    
    // Create a static variable to access the cache instance globally
    static let shared = ImageCache()
    
    // Add an image to the cache
    func addImageToCache(_ image: Image, for key: String) {
        cache[key] = image
    }
    
    // Retrieve an image from the cache
    func getImageFromCache(for key: String) -> Image? {
        return cache[key]
    }
    
    // Clear the cache
    func clearCache() {
        cache.removeAll()
    }
}
