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
    
    func convertToViewModel() -> PhotoVM {
        PhotoVM(albumId: albumId, id: id, title: title, url: url, thumbnailUrl: thumbnailUrl)
    }
}

class PhotoVM: Identifiable, ObservableObject, Equatable {
    let albumId: Int
    var id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    @Published var isFavorite: Bool = false
    
    init(albumId: Int, id: Int, title: String, url: String, thumbnailUrl: String, isFavorite: Bool = false) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.isFavorite = isFavorite
    }
    
    static func == (_ lhs: PhotoVM, _ rhs: PhotoVM) -> Bool {
        lhs === rhs
    }
}

class PhotoFeed: ObservableObject {
    @Published var photoViewModels = [PhotoVM]()
}
