//
//  AsyncImageWithCache.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/27/23.
//

import SwiftUI

struct AsyncImageWithCache: View {
    private var imageUrlString: String = APIConstants.iconBaseURL
    private let cache = ImageCache.shared
    private let iconURLExtension = "@2x.png"

    init(iconCode: String) {
        self.imageUrlString.append(iconCode + iconURLExtension)
    }

    var body: some View {
        AsyncImage(url: URL(string: imageUrlString)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 100)
                .onAppear {
                    cache.addImageToCache(image, for: imageUrlString)
                }
        } placeholder: {
            Color.clear
                .frame(maxWidth: 300, maxHeight: 100)
        }
        .onAppear {
            if cache.getImageFromCache(for: imageUrlString) != nil {
                return
            }
        }
    }
}
