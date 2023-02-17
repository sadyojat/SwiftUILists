//
//  NetworkInteractor.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/16/23.
//

import Foundation
import UIKit

enum APIError: Error {
    case URLError
    case remoteUrlUnreachable(error: String)
    case responseError(error: String)
    case unknown
}

enum CallType: String {
    case photos = "https://jsonplaceholder.typicode.com/photos"
    case posts = "https://jsonplaceholder.typicode.com/posts"
}

class ImageCache {

    static let shared = ImageCache()

    let cache = NSCache<NSString, UIImage>()

    func image(for key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }

    func setImage(_ image: UIImage, for key: NSString) {
        cache.setObject(image, forKey: key)
    }
}

class NetworkInteractor {

    func fetch(_ callType: CallType) async throws -> [any AbstractModel] {
        guard let url = URL(string: callType.rawValue) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        switch callType {
            case .photos:
                return try JSONDecoder().decode([Photo].self, from: data)
            case .posts:
                return try JSONDecoder().decode([Post].self, from: data)
        }
    }


    func downloadPhoto(_ urlString: String) async throws -> UIImage {
        if let image = ImageCache.shared.image(for: urlString as NSString) {
            return image
        } else {
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeRawData) }
            ImageCache.shared.setImage(image, for: urlString as NSString)
            return image
        }
    }
}
