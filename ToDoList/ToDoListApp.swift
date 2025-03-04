//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI


@main
struct ToDoListApp: App {
 
    let persistenceController = PersistenceController.shared
    
   
    
    var body: some Scene {
            WindowGroup {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
