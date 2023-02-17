//
//  DiffableTVSwiftUIApp.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import SwiftUI

@main
struct DiffableTVSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Posts", systemImage: "envelope")
                    }

                PhotosMainView()
                    .tabItem {
                        Label("Photos", systemImage: "photo")
                    }
            }
        }
    }
}
