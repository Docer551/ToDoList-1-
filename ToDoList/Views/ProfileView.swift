//
//  ProfileView.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text("Користувач")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Ваш прогрес:")
                    .font(.headline)

                ProfileStatsView()

                Toggle("Темний режим", isOn: $isDarkMode)
                    .padding()
                    .onChange(of: isDarkMode) { _ in
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                    }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Профіль")
        }
    }
}

struct ProfileStatsView: View {
    @FetchRequest(entity: TaskEntity.entity(), sortDescriptors: []) var tasks: FetchedResults<TaskEntity>

    var completedTasks: Int {
        tasks.filter { $0.isCompleted }.count
    }

    var totalTasks: Int {
        tasks.count
    }

    var body: some View {
        VStack {
            Text("Завершено: \(completedTasks) / \(totalTasks)")
                .font(.headline)

            ProgressView(value: totalTasks == 0 ? 0 : Double(completedTasks) / Double(totalTasks))
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
        }
    }
}
