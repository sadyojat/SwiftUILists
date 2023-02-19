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

struct ContentView: View {

    @StateObject private var feed = Feed()
    
    private let network = NetworkInteractor()

    var body: some View {
        NavigationStack {            
            List {
                ForEach($feed.posts) { $post in
                    NavigationLink {
                        SelectedView(post: $post)
                    } label: {
                        CellContentView(post: $post)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Navigation Title")
            .task {
                do {
                    if self.feed.posts.isEmpty {
                        if let posts = try await network.fetch(.posts) as? [Post] {
                            self.feed.posts = posts
                        }
                    }

                } catch {
                    print("Failed to retrieve posts")
                }
            }
        }

    }
}

struct CellContentView: View {

    @Binding var post: Post

    var body: some View {
        HStack {
            Image(systemName: "arrow.down.circle.fill")
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                /*@START_MENU_TOKEN@*/Text(post.title)/*@END_MENU_TOKEN@*/
                    .font(.title3)
                Text(post.body)
                    .font(.caption)
            }
            Spacer()
            Image(systemName: "heart.fill")
                .symbolRenderingMode(.multicolor)
                .opacity((post.isFavorite ?? false) ? 1 : 0)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            TrailingSwipeView(isFavorite: $post.isFavorite)
        }
        .padding()
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            LeadingSwipeView()
        }
    }
}

struct TrailingSwipeView: View {

    @Binding var isFavorite: Bool?

    var body: some View {
        HStack {
            Button(role: .destructive) {

            } label: {
                Label("Delete", systemImage: "minus.circle")
            }

            Button(role: .none) {

            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.yellow)

            Button {
                print("Changing state from \(String(describing: isFavorite)))")
                isFavorite = !(isFavorite ?? false)
            } label: {
                if isFavorite == true {
                    Label("Unfavorite", systemImage: "heart.slash")
                } else {
                    Label("Favorite", systemImage: "heart")
                }
            }
        }
    }
}

struct LeadingSwipeView: View {

    var body: some View {
        HStack {
            Button {
            } label: {
                Label("Phone", systemImage: "phone")
            }
            .tint(.accentColor)

            Button {
            } label: {
                Label("Email", systemImage: "envelope")
            }
            .tint(.teal)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    @StateObject private var feed = Feed()
//    static var previews: some View {
//        ContentView(posts: $feed.posts)
//    }
//}
