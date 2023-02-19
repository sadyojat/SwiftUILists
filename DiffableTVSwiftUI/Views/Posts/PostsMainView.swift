//
//  ContentView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import SwiftUI


enum SwipeActionOptions {
    case phone, email, edit, delete, favorite, unfavorite
    case none
}

struct PostsMainView: View {

    @StateObject private var feed = Feed()
    
    private let network = NetworkInteractor()

    var body: some View {
        NavigationStack {            
            List {
                ForEach($feed.posts) { $post in
                    NavigationLink {
                        SelectedPostView(post: $post)
                    } label: {
                        PostCellView(post: $post)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Posts \(feed.posts.count)")
            .task {
                guard feed.posts.isEmpty else { return }
                feed.posts = (try? await network.fetch(.posts) as? [Post]) ?? []
            }
            .onChange(of: feed.posts) { _ in
                feed.posts.removeAll { $0.isMarkedForDeletion == true }
            }
        }
    }
}
