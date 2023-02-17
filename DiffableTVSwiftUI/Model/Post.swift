//
//  Post.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import Foundation
import SwiftUI

struct Post: AbstractModel, Codable, Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.userId == rhs.userId &&
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.body == rhs.body
    }    
    let userId: Int
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool? = false


    init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id - 1
        self.title = title
        self.body = body
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(body)
        hasher.combine(isFavorite)
    }
}



@MainActor class Feed: ObservableObject {
    let identifier = UUID()

    @Published var posts = [Post]()

    public func postBinding(for id: Post.ID) -> Binding<Post> {
        Binding<Post> {
            self.posts[id]
        } set: { newValue in
            self.posts[id] = newValue
        }
    }
}
