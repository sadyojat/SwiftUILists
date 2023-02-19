//
//  CDCellTrailingSwipeAction.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import SwiftUI

struct CDCellTrailingSwipeAction: View {

    @Environment(\.managedObjectContext) var moc

    @State var post: PostManagedObject

    var body: some View {
        HStack {
            Button(role: .destructive) {
                moc.delete(post)
                do {
                    try moc.save()
                } catch let error {
                    print("\(#file) | \(#line) | ERROR :: \(error) ")
                }
            } label: {
                Label("Delete", image: "trash")
            }
        }
    }
}
