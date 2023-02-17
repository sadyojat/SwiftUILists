//
//  PhotosView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/16/23.
//

import SwiftUI

struct PhotosMainView: View {

    @StateObject private var photoFeed = PhotoFeed()
    let networkInteractor = NetworkInteractor()

    var body: some View {
        NavigationStack {
            List {
                ForEach($photoFeed.photos) { $photo in
                    NavigationLink {
                        PhotoDetailView(photo: $photo)
                    } label: {
                        PhotoCellView(photo: $photo)
                    }
                }
            }
            .navigationTitle("Photos")
            .listStyle(.plain)
            .task {
                if photoFeed.photos.isEmpty {
                    do {
                        if let photos = try await networkInteractor.fetch(.photos) as? [Photo] {
                            photoFeed.photos = photos
                        } else {
                            photoFeed.photos = []
                        }
                    } catch {
                        photoFeed.photos = []
                    }
                }
            }
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosMainView()
    }
}
