//
//  CDInteractor.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import CoreData
import Foundation

class CDInteractor: ObservableObject {
    private let container = PersistentContainer(name: "Model")

    private(set) lazy var moc = {
        container.viewContext
    }()

    init() {
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("Unable to load persistent stores :: \(error) | \(error.userInfo)", file: #file, line: #line)
            }
        }
    }

    func saveContext(_ backgroundContext: NSManagedObjectContext? = nil) {
        container.saveContext(backgroundContext)
    }

    func delete(_ object: NSManagedObject, commitOnEachOp: Bool = false) {
        moc.delete(object)
        if commitOnEachOp {
            saveContext()
        }
    }
}
