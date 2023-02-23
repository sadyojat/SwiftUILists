//
//  Post.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/15/23.
//

import Combine
import Foundation
import SwiftUI

struct Post: AbstractModel, Codable {
    let userId: Int
    var id: Int
    var title: String
    var body: String
    
    func translateToViewModel() -> PostVM {
        PostVM(userId: userId, id: id, title: title, body: body)
    }
}

class PostVM: Identifiable, ObservableObject, Equatable {
    let userId: Int
    let id: String
    let title: String
    let body: String
    @Published var isFavorite: Bool = false
    @Published var isMarkedForDeletion: Bool = false
    
    init(
        userId: Int, id: Int, title: String, body: String,
        isFavorite: Bool = false, isMarkedForDeletion: Bool = false) {
        self.userId = userId
        self.id = UUID().uuidString + "_\(id)"
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
        self.isMarkedForDeletion = isMarkedForDeletion
    }
    
    static func == (_ lhs: PostVM, _ rhs: PostVM) -> Bool {
        return lhs === rhs
    }
}

extension Notification.Name {
    static let postMarkedForDeletion = Notification.Name("PostMarkedForDeletion")
}

class Feed: ObservableObject {
    let identifier = UUID()
    
    @Published var postViewModels = [PostVM]()
    
    private var markedForDeletionPublisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default.publisher(for: Notification.Name.postMarkedForDeletion).eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(postViewModels: [PostVM] = [PostVM]()) {
        self.postViewModels = postViewModels
        markedForDeletionPublisher.sink { [weak self] output in
            guard let self = self else { return }
            if let vm = output.object as? PostVM {
                self.postViewModels.removeAll { $0.id == vm.id }
            }
        }
        .store(in: &cancellables)
    }
}
