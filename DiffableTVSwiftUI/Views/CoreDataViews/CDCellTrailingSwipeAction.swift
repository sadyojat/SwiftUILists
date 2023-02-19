//
//  CDCellTrailingSwipeAction.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import SwiftUI

struct CDCellTrailingSwipeAction: View {

    @Environment(\.managedObjectContext) var moc

    @EnvironmentObject var interactor: CDInteractor

    @State var post: PostManagedObject

    var body: some View {
        HStack {
            Button(role: .destructive) {
                interactor.delete(post, commitOnEachOp: true)
            } label: {
                Label("Delete", image: "trash")
            }
        }
    }
}
