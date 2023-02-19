//
//  PersistentContainer.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/18/23.
//

import CoreData
import Foundation

protocol PersistenceProtocol {
    func saveContext(_ backgroundContext: NSManagedObjectContext?)
}

class PersistentContainer: NSPersistentContainer, PersistenceProtocol {
    func saveContext(_ backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("\(#file)|\(#line) || ERROR:: Unable to save context : \(error) || \(error.userInfo)")
        }
    }
}
