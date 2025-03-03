//
//  Untitled.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var selectedDate = Date()
    @State private var tasks: [TaskEntity] = []

    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Оберіть дату", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .onChange(of: selectedDate, perform: { _ in
                        fetchTasks()
                    })

                if tasks.isEmpty {
                    VStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                            .padding()
                        Text("Завдань немає 📅")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List(tasks) { task in
                        TaskRowView(task: task)
                    }
                }
            }
            .navigationTitle("Календар")
            .onAppear {
                fetchTasks()
            }
        }
    }

    private func fetchTasks() {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)]

        do {
            tasks = try context.fetch(request)
        } catch {
            print("Помилка завантаження завдань: \(error.localizedDescription)")
        }
    }
}
