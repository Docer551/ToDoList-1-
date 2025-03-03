//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskEntity] = []
    @Published var showAddTask = false

    private let context = PersistenceController.shared.context

    func fetchTasks() {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let sort = NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)
        request.sortDescriptors = [sort]

        do {
            tasks = try context.fetch(request)
        } catch {
            print("Помилка завантаження: \(error.localizedDescription)")
        }
    }

    func addTask(title: String, date: Date, category: String) {
        let newTask = TaskEntity(context: context)
        newTask.title = title
        newTask.date = date
        newTask.category = category
        newTask.isCompleted = false

        saveContext()
    }

    func deleteTask(_ task: TaskEntity) {
        context.delete(task)
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
            fetchTasks()
        } catch {
            print("Помилка збереження: \(error.localizedDescription)")
        }
    }
}
