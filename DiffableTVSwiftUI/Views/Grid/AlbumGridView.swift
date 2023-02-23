//
//  AlbumGridView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//


import SwiftUI

enum GridLayoutOptions {
    case two(size: GridItem.Size = .adaptive(minimum: 100))
    case three(size: GridItem.Size = .adaptive(minimum: 100))
    case four(size: GridItem.Size = .adaptive(minimum: 100))

    var layout: [GridItem] {
        switch self {
            case .two(let size):
                return Array(repeating: GridItem(size), count: 2)
            case .three(let size):
                return Array(repeating: GridItem(size), count: 3)
            case .four(let size):
                return Array(repeating: GridItem(size), count: 4)
        }
    }

    var description: String {
        switch self {
            case .two(let size):
                return "two: \(size)"
            case .three(let size):
                return "three: \(size)"
            case .four(let size):
                return "four: \(size)"
        }
    }
}


struct AlbumGridView: View {

    @State var album: Album

    @State private var photos: [Photo] = [Photo]()

    private let networkInteractor = NetworkInteractor()


    let layouts: [GridLayoutOptions] = [
        .two(size: .fixed(100)),
        .three(size: .fixed(100)),
        .four(size: .fixed(100)),
        .two(size: .flexible()),
        .three(size: .flexible()),
        .four(size: .flexible()),
        .two(size: .adaptive(minimum: 200))
    ]

    var layout: [GridItem] {
        layouts.randomElement()!.layout
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach($photos) { $photo in
                        NavigationLink {
//                            PhotoDetailView(photo: $photo)
                        } label: {
                            ZStack(alignment: .center) {
                                GridImage(photo: $photo)
                                if (photo.isFavorite ?? false) == true {
                                    Image(systemName: "heart.fill")
                                        .symbolRenderingMode(.multicolor)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .task {
                await loadData()
            }
            .navigationTitle("Grid Layouts")
        }
    }
}

extension AlbumGridView {
    func loadData() async {
        guard photos.isEmpty else { return }
        photos = (try? await networkInteractor.fetch(.albums(id: album.id, caseType: .photos)) as? [Photo]) ?? []
    }
}

