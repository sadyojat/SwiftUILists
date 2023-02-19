//
//  Album.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import Foundation

struct Album: AbstractModel, Codable {
    let id: Int
    let userId: Int
    let title: String
}


@MainActor class AlbumFeed: ObservableObject {
    @Published var albums: [Album] = [Album]()
}
