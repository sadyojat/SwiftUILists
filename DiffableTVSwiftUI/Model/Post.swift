//
//  Post.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import Foundation
import SwiftUI

struct Post: AbstractModel, Codable {
    let userId: Int
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool? = false
    var isMarkedForDeletion: Bool? = false
}

class Feed: ObservableObject {
    let identifier = UUID()

    @Published var posts = [Post]()
}
