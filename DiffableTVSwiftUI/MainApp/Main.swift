//
//  DiffableTVSwiftUIApp.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import SwiftUI

@main
struct MainApp: App {
    

    var body: some Scene {
        WindowGroup {
            Tabs()
        }
    }
}


struct Tabs: View {
    @StateObject private var coreDataInteractor = CDInteractor()

    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        TabView {
            PostsMainView()
                .tabItem {
                    Label("Posts", systemImage: "envelope")
                }
            PhotosMainView()
                .tabItem {
                    Label("Photos", systemImage: "photo")
                }
            CDView()
                .environmentObject(coreDataInteractor)
                // This setting is needed for @FetchRequest to work in the navigation stack
                .environment(\.managedObjectContext, coreDataInteractor.moc)
                .tabItem {
                    Label("Core Data", systemImage: "externaldrive")
                }
            AlbumsMainView()
                .tabItem {
                    Label("Grids", systemImage: "grid.circle")
                        .tint(.accentColor)
                }
        }
        .onChange(of: scenePhase) { _ in
            coreDataInteractor.saveContext()
        }
    }
}
