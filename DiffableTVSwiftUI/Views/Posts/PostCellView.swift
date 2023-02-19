//
//  PostCellView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/19/23.
//

import SwiftUI

struct PostCellView: View {

    @Binding var post: Post

    var body: some View {
        HStack {
            Image(systemName: "arrow.down.circle.fill")
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                /*@START_MENU_TOKEN@*/Text(post.title)/*@END_MENU_TOKEN@*/
                    .font(.title3)
                Text(post.body)
                    .font(.caption)
            }
            Spacer()
            Image(systemName: "heart.fill")
                .symbolRenderingMode(.multicolor)
                .opacity((post.isFavorite ?? false) ? 1 : 0)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            PostCellTrailingSwipeView(post: $post)
        }
        .padding()
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            PostCellLeadingSwipeView()
        }
    }
}
