//
//  Persistence.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Помилка CoreData: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }
}
