//
//  ContentView.swift
//  ToDoList
//
//  Created by Ярослав Семистрок on 19.02.2025.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
   
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "checkmark.circle.fill") }

            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .environmentObject(viewModel)
    }
}
