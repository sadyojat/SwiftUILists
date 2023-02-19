//
//  DiffableTVSwiftUIApp.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import SwiftUI

@main
struct DiffableTVSwiftUIApp: App {
    @StateObject private var coreDataInteractor = CDInteractor()

    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            Tabs()
                .environmentObject(coreDataInteractor)
                // This setting is needed for @FetchRequest to work in the navigation stack
                .environment(\.managedObjectContext, coreDataInteractor.moc)
        }
        .onChange(of: scenePhase) { _ in
            coreDataInteractor.saveContext()
        }

    }
}


struct Tabs: View {

    @Environment(\.managedObjectContext) var moc

    @EnvironmentObject var interactor: CDInteractor

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Posts", systemImage: "envelope")
                }
            PhotosMainView()
                .tabItem {
                    Label("Photos", systemImage: "photo")
                }
            CDView()
                .tabItem {
                    Label("Core Data", systemImage: "externaldrive")
                }
        }
    }
}
