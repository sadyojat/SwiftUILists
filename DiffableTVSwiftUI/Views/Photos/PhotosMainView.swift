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
                ForEach(photoFeed.photoViewModels) { vm in
                    NavigationLink {
                        PhotoDetailView(viewModel: vm)
                    } label: {
                        PhotoCellView(viewModel: vm)
                    }
                }
            }
            .navigationTitle("Photos")
            .listStyle(.plain)
            .task {
                guard photoFeed.photoViewModels.isEmpty else { return }
                
                if let photos = try? await networkInteractor.fetch(.photos) as? [Photo] {
                    photoFeed.photoViewModels = photos.compactMap({
                        $0.convertToViewModel()
                    })
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
