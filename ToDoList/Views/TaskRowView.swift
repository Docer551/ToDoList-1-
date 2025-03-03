//
//  TaskRowView.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var task: TaskEntity
    @Environment(\.managedObjectContext) private var context
    
    let categoryColors: [String: Color] = [
        "Робота": .blue,
        "Навчання": .green,
        "Особисте": .purple
    ]

    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? (categoryColors[task.category ?? ""] ?? .gray) : .gray)
                    .font(.system(size: 24))
                    .animation(.spring(), value: task.isCompleted)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading) {
                Text(task.title ?? "Без назви")
                    .font(.headline)
                    .strikethrough(task.isCompleted, color: .gray)
                    .foregroundColor(task.isCompleted ? .gray : .primary)

                if let date = task.date {
                    Text(date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private func toggleCompletion() {
        task.isCompleted.toggle()
        try? context.save()
    }
}
