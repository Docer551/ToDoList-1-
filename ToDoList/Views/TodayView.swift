//
//  TodayView.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var showCompleted = false
    @State private var showNotes = false
    @State private var taskToEdit: TaskEntity? = nil
    @State private var showEditTaskView = false

    let categoryColors: [String: Color] = [
        "Робота": .blue,
        "Навчання": .green,
        "Особисте": .purple
    ]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Фільтр", selection: $showCompleted) {
                    Text("Усі").tag(false)
                    Text("Невиконані").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(filteredTasks) { task in
                        HStack {
                            if let category = task.category {
                                Circle()
                                    .fill(categoryColors[category] ?? .gray)
                                    .frame(width: 10, height: 10)
                            }
                            TaskRowView(task: task)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteTask(task)
                            } label: {
                                Label("Видалити", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                taskToEdit = task
                                showEditTaskView = true
                            } label: {
                                Label("Редагувати", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: { showNotes.toggle() }) {
                            Image(systemName: "note.text")
                        }
                        .sheet(isPresented: $showNotes) {
                            NotesView()
                        }
                        
                        Button(action: { viewModel.showAddTask.toggle() }) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $viewModel.showAddTask) {
                            AddTaskView(viewModel: viewModel)
                        }
                    }
                }
            }
            .onAppear { viewModel.fetchTasks() }
            .sheet(item: $taskToEdit) { task in
                EditTaskView(task: task, viewModel: viewModel)
            }
        }
    }

    private var filteredTasks: [TaskEntity] {
        showCompleted ? viewModel.tasks.filter { !$0.isCompleted } : viewModel.tasks
    }

    private func deleteTask(_ task: TaskEntity) {
        viewModel.deleteTask(task)
    }
}

struct NotesView: View {
    @State private var notes: String = UserDefaults.standard.string(forKey: "savedNotes") ?? ""
    
    var body: some View {
        NavigationView {
            TextEditor(text: $notes)
                .padding()
                .navigationTitle("Нотатки")
                .navigationBarTitleDisplayMode(.inline)
                .onDisappear {
                    UserDefaults.standard.set(notes, forKey: "savedNotes")
                }
        }
    }
}

struct EditTaskView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var task: TaskEntity
    var viewModel: TaskViewModel
    
    @State private var title: String
    @State private var category: String

    init(task: TaskEntity, viewModel: TaskViewModel) {
        self.task = task
        self.viewModel = viewModel
        _title = State(initialValue: task.title ?? "")
        _category = State(initialValue: task.category ?? "Особисте")
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Назва", text: $title)
                Picker("Категорія", selection: $category) {
                    Text("Робота").tag("Робота")
                    Text("Навчання").tag("Навчання")
                    Text("Особисте").tag("Особисте")
                }
                .pickerStyle(MenuPickerStyle())
            }
            .navigationTitle("Редагування")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Зберегти") {
                        saveTask()
                    }
                }
            }
        }
    }

    private func saveTask() {
        task.title = title
        task.category = category
        try? context.save()
        presentationMode.wrappedValue.dismiss()
    }
}
