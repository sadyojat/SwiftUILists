//
//  ToolbarView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import CoreData
import SwiftUI

struct CDToolbarView: View {

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            AddRowButton()
                .environment(\.managedObjectContext, moc)
            DeleteAllButton()
                .environment(\.managedObjectContext, moc)

        }
    }
}

struct AddRowButton: View {

    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Button {
            let titles = ["Lorem Ipsum", "dolor sit amet", "consectetur adipiscing elit"]
            let bodies = [
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
                "ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco",
                "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit",
            ]
            let newPost = PostManagedObject(context: moc)
            newPost.id = Int64(Int.random(in: 0..<1024))
            newPost.userId = Int64(Int.random(in: 1024..<2048))
            newPost.title = titles.randomElement()!
            newPost.body = bodies.randomElement()!
            do {
                try moc.save()
            } catch let error as NSError {
                print("Unable to save moc :: \(error) | \(error.userInfo)")
            }
        } label: {
            Label("Add", systemImage: "plus")
        }
    }
}

struct DeleteAllButton: View {

    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: []) var posts: FetchedResults<PostManagedObject>

    var body: some View {
        Button(role: .destructive) {
            for post in posts {
                moc.delete(post)
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
