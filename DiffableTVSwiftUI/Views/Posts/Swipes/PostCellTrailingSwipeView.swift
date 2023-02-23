//
//  PostCellTrailingSwipeView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/19/23.
//

import SwiftUI

struct PostCellTrailingSwipeView: View {

    @StateObject var post: PostVM

    var body: some View {
        HStack {
            Button(role: .destructive) {
                post.isMarkedForDeletion = true
                NotificationCenter.default.post(name: .postMarkedForDeletion, object: post)
            } label: {
                Label("Delete", systemImage: "minus.circle")
            }

            Button(role: .none) {

            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.yellow)

            Button {
                print("Changing state from \(String(describing: post.isFavorite)))")
                post.isFavorite = !post.isFavorite
            } label: {
                if post.isFavorite == true {
                    Label("Unfavorite", systemImage: "heart.slash")
                } else {
                    Label("Favorite", systemImage: "heart")
                }
            }
        }
    }
}

