//
//  PhotoCellView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/16/23.
//

import SwiftUI

struct PhotoCellView: View {

    @Binding var photo: Photo

    @State private var thumbnail: UIImage?

    let network = NetworkInteractor()

    var body: some View {
        HStack {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "arrow.down")
            }
            Text(photo.title)
                .multilineTextAlignment(.leading)
            Spacer()
            Image(systemName: "heart.fill")
                .symbolRenderingMode(.multicolor)
                .opacity((photo.isFavorite ?? false) ? 1 : 0)
        }
        .padding()
        .task {
            guard thumbnail == nil else { return }
            do {
                thumbnail = try await network.downloadPhoto(photo.thumbnailUrl)
            } catch {
                thumbnail = nil
            }
        }
    }
}
