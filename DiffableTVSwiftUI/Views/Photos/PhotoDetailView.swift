//
//  PhotoDetailView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/16/23.
//

import SwiftUI

struct PhotoDetailView: View {
    
    @ObservedObject var viewModel: PhotoVM

    @State private var image: UIImage?

    var body: some View {
        VStack(alignment: .center) {
            DetailImageView(imageUrl: viewModel.url)
            Spacer()
            FavoriteButtonView(viewModel: viewModel)
        }
        .frame(maxHeight: 400)
        .padding()
        
    }
}

struct DetailImageView: View {

    @State private var image: UIImage?
    
    @State var imageUrl: String
    
    private let network = NetworkInteractor()
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .cornerRadius(20)
                .scaledToFit()
                .frame(maxWidth: 600, maxHeight: 600)

                .padding()
        } else {
            Image(systemName: "arrow.down")
                .task {
                    if image == nil {
                        image = try? await network.downloadPhoto(imageUrl)
                    }

                }
        }
    }
}

struct FavoriteButtonView: View {

    @ObservedObject var viewModel: PhotoVM

    var body: some View {
        if viewModel.isFavorite == true {
            Button {
                viewModel.isFavorite = false
            } label: {
                Label("Unfavorite", systemImage: "heart.slash")
            }
        } else {
            Button {
                viewModel.isFavorite = true
            } label: {
                Label("Mark as Favorite", systemImage: "heart.fill")
            }
        }
    }
}
