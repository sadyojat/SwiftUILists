//
//  CDView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import SwiftUI

struct CDView: View {

    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var posts: FetchedResults<PostManagedObject>

    @EnvironmentObject var interactor: CDInteractor

    var body: some View {

        NavigationStack {
            VStack {
                if !posts.isEmpty {
                    List{
                        ForEach(posts) { post in
                            VStack(alignment: .leading) {
                                Text(post.title ?? "Unknown" )
                                    .font(.title3)
                                Text(post.body ?? "Unknown")
                                    .font(.caption)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                CDCellTrailingSwipeAction(post: post)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("CD Count = \(posts.count)"))
            .toolbar {
                CDToolbarView()
            }
        }
        .onDisappear {
            interactor.saveContext()
        }
    }
}
