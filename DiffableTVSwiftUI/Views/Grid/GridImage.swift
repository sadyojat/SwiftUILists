//
//  GridImage.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/19/23.
//

import SwiftUI

struct GridImage: View {

    @Binding var photo: Photo

    @State private var image: UIImage?

    let networkInteractor = NetworkInteractor()

    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(10.0)
                    .padding()
            } else {
                Image(systemName: "arrow.down")
            }
        }
        .task {
            guard image == nil else { return }
            image = try? await networkInteractor.downloadPhoto(photo.url)
        }
    }
}
