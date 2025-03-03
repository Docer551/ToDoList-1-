//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TaskViewModel

    @State private var title: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: String = "Робота"
    @FocusState private var isTitleFocused: Bool

    let categories = ["Робота", "Навчання", "Особисте"]
    
    var categoryColors: [String: Color] = [
        "Робота": .blue,
        "Навчання": .green,
        "Особисте": .purple
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Назва завдання")) {
                    TextField("Введіть назву", text: $title)
                        .focused($isTitleFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            isTitleFocused = false
                        }
                }

                Section(header: Text("Дата")) {
                    DatePicker("Оберіть дату", selection: $selectedDate, displayedComponents: .date)
                }

                Section(header: Text("Категорія")) {
                    Picker("Категорія", selection: $selectedCategory) {
                        ForEach(categories, id: \ .self) { category in
                            Text(category)
                                .tag(category)
                                .foregroundColor(categoryColors[category] ?? .black)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section {
                    Button(action: saveTask) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Додати завдання")
                        }
                        .foregroundColor(title.isEmpty ? .gray : (categoryColors[selectedCategory] ?? .blue))
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("Нове завдання")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func saveTask() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addTask(title: title, date: selectedDate, category: selectedCategory)
        presentationMode.wrappedValue.dismiss()
    }
}
