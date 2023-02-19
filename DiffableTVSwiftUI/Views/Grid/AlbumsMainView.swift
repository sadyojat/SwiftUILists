//
//  AlbumsMainView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import SwiftUI

struct AlbumsMainView: View {

    @StateObject private var albumFeed = AlbumFeed()

    private let networkInteractor = NetworkInteractor()

    var body: some View {
        NavigationStack(root: {
            List {
                ForEach(albumFeed.albums) { album in
                    NavigationLink {
                        AlbumGridView(album: album)
                    } label: {
                        Label(album.title, systemImage: "book")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Grids")
        })
        .task { await loadData() }
    }
}

extension AlbumsMainView {
    fileprivate func loadData() async {
        guard albumFeed.albums.isEmpty else { return }
        albumFeed.albums = (try? await networkInteractor.fetch(.albums()) as? [Album]) ?? []
    }
}
