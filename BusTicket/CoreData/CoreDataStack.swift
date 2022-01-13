//
//  CoreDataStack.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let storeContainer = NSPersistentContainer(name: "BusTicket")
        storeContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error  = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return storeContainer
    }()

    func getManagedContext() -> NSManagedObjectContext {
        return storeContainer.viewContext
    }
    func saveContext() {
        guard storeContainer.viewContext.hasChanges else {return}

        do {
            try storeContainer.viewContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

}
