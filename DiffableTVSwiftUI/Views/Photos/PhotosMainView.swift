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
    
    @State private var presentingList: [PhotoVM] = []
    
    @State private var searchText = ""
    
    @State private var searchWorkItem: DispatchWorkItem?

    var body: some View {
        NavigationStack {
            List {
                ForEach(presentingList) { vm in
                    NavigationLink {
                        PhotoDetailView(viewModel: vm)
                    } label: {
                        PhotoCellView(viewModel: vm)
                    }
                }
            }
            .searchable(text: $searchText)
            .onSubmit(of: .search, {
                presentingList = photoFeed.photoViewModels.filter({ $0.title.lowercased().contains(searchText.lowercased())})
            })
            .onChange(of: searchText, perform: { newValue in
                if searchText.count == 0 {
                    presentingList = photoFeed.photoViewModels
                } else {
                    searchWorkItem?.cancel()
                    searchWorkItem = DispatchWorkItem(block: {
                        presentingList = photoFeed.photoViewModels.filter({ $0.title.lowercased().contains(searchText.lowercased())})
                    })
                    DispatchQueue.main.async(execute: searchWorkItem!)
                }
            })
            .navigationTitle("Photos")
            .listStyle(.plain)
            .task {
                guard photoFeed.photoViewModels.isEmpty else { return }
                
                searchWorkItem = DispatchWorkItem(block: {
                    presentingList = photoFeed.photoViewModels.filter({ $0.title.lowercased().contains(searchText.lowercased())})
                })
                
                if let photos = try? await networkInteractor.fetch(.photos) as? [Photo] {
                    photoFeed.photoViewModels = photos.compactMap({
                        $0.convertToViewModel()
                    })
                    presentingList = photoFeed.photoViewModels
                } else {
                    presentingList = photoFeed.photoViewModels
                }
            }
        }
    }
}
