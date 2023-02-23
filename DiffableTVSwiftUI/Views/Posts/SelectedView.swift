//
//  SelectedView.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import SwiftUI

struct SelectedPostView: View {
    @StateObject var vm: PostVM
    var body: some View {
        Text(vm.title + " - " + "\(vm.isFavorite)")
    }
}
