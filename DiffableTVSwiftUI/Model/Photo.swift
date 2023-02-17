//
//  Photo.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/16/23.
//

import Foundation
import SwiftUI

struct Photo: AbstractModel, Codable {
    let albumId: Int
    var id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    var isFavorite: Bool? = false
}


@MainActor class PhotoFeed: ObservableObject {
    @Published var photos: [Photo] = [Photo]()

    func bindingPhoto(_ id: Photo.ID) -> Binding<Photo> {
        Binding<Photo> {
            self.photos[id]
        } set: { photo in
            self.photos[id] = photo
        }
    }

}
