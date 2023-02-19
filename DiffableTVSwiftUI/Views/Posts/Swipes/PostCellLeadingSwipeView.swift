//
//  PostCellLeadingSwipeView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/19/23.
//

import SwiftUI

struct PostCellLeadingSwipeView: View {

    var body: some View {
        HStack {
            Button {
            } label: {
                Label("Phone", systemImage: "phone")
            }
            .tint(.accentColor)

            Button {
            } label: {
                Label("Email", systemImage: "envelope")
            }
            .tint(.teal)
        }
    }
}
