//
//  ContentView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import Combine
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
                ForEach(feed.postViewModels) { vm in
                    NavigationLink {
                        SelectedPostView(vm: vm)
                    } label: {
                        PostCellView(post: vm)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Posts \(feed.postViewModels.count)")
            .task {
                guard feed.postViewModels.isEmpty else { return }
                
                if let posts = try? await network.fetch(.posts) as? [Post] {
                    feed.postViewModels = posts.compactMap({
                        $0.translateToViewModel()
                    })
                } else {
                    feed.postViewModels = []
                }
            }
        }
    }
}
