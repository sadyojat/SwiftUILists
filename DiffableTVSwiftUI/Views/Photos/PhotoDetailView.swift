//
//  PhotoDetailView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/16/23.
//

import SwiftUI

struct PhotoDetailView: View {

    @Binding var photo: Photo

    @State private var image: UIImage?

    private let network = NetworkInteractor()

    var body: some View {
        VStack(alignment: .center) {
            DetailImageView(image: $image)
            Spacer()
            FavoriteButtonView(photo: $photo)
        }
        .frame(maxHeight: 400)
        .padding()
        .task {
            if image == nil {
                do {
                    image = try await network.downloadPhoto(photo.url)
                } catch {
                    image = nil
                }
            }
        }
    }
}

struct DetailImageView: View {

    @Binding var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 600, maxHeight: 600)
                .padding()
        } else {
            Image(systemName: "arrow.down")
        }
    }
}

struct FavoriteButtonView: View {

    @Binding var photo: Photo

    var body: some View {
        if photo.isFavorite == true {
            Button {
                photo.isFavorite = false
            } label: {
                Label("Unfavorite", systemImage: "heart.slash")
            }
        } else {
            Button {
                photo.isFavorite = true
            } label: {
                Label("Mark as Favorite", systemImage: "heart.fill")
            }
        }
    }
}

//struct PhotoDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoDetailView()
//    }
//}
