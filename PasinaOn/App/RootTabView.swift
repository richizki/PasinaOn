//
//  RootTabView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import SwiftUI

struct RootTabView: View {

    var body: some View {

        TabView {

            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }

            NavigationStack {
                EntriesView()
            }
            .tabItem {
                Label("Entries", systemImage: "book")
            }

            NavigationStack {
                GoalsView()
            }
            .tabItem {
                Label("Goals", systemImage: "target")
            }

            NavigationStack {
                StatisticsView()
            }
            .tabItem {
                Label("Statistics", systemImage: "chart.bar")
            }
        }
        .tint(.purple)
    }
}

#Preview {
    RootTabView()
}
