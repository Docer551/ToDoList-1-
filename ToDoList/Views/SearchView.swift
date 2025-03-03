//
//  SearchView.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//
import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var searchText = ""
    @State private var selectedCategory: String? = "Всі"
    @State private var selectedDate: Date? = nil

    @FetchRequest var tasks: FetchedResults<TaskEntity>

    let categories = ["Всі", "Робота", "Навчання", "Особисте"]

    init() {
        _tasks = FetchRequest<TaskEntity>(
            entity: TaskEntity.entity(),
            sortDescriptors: []
        )
    }

    var filteredTasks: [TaskEntity] {
        tasks.filter { task in
            (searchText.isEmpty || (task.title?.localizedCaseInsensitiveContains(searchText) ?? false)) &&
            (selectedCategory == "Всі" || task.category == selectedCategory) &&
            (selectedDate == nil || Calendar.current.isDate(task.date ?? Date(), inSameDayAs: selectedDate!))
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Пошук завдань...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { _ in }
            
            HStack(spacing: 10) {
                ForEach(categories, id: \ .self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedCategory == category ? Color.white : Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCategory == category ? Color.gray : Color.clear, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
            
            DatePicker("Оберіть дату", selection: Binding($selectedDate, replacingNilWith: Date()), displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { _ in }
            
            if filteredTasks.isEmpty {
                Spacer()
                Text("Нічого не знайдено 🔍")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            } else {
                List(filteredTasks) { task in
                    TaskRowView(task: task)
                }
            }
        }
        .navigationTitle("Пошук")
    }
}

extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
