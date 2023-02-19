//
//  SelectedView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import SwiftUI

struct SelectedPostView: View {
    @Binding var post: Post
    var body: some View {
        Text(post.title + "\(post.isFavorite)")
    }
}
