//
//  DashboardView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    
    @Query(
        sort: \LearningGoal.targetDate
    )
    private var goals: [LearningGoal]
    
    @Query(
        sort: \LearningEntry.date,
        order: .reverse
    )
    private var entries: [LearningEntry]
    var body: some View {
        VStack(spacing: 24) {
            dashboardHeader
            
            ScrollView {
                NavigationLink {
                    
                    if let currentGoal {
                        
                        NavigationLink {
                            
                            GoalDetailView(
                                goal: currentGoal
                            )
                            
                        } label: {
                            
                            goalCard
                        }
                    }
                } label: {
                    
                    goalCard
                }
                .buttonStyle(.plain)
                statsSection
                weeklyActivity
                quickActions
                recentEntries
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
    private var currentGoal: LearningGoal? {
        goals.first
    }
    
    private var totalEntries: Int {
        entries.count
    }
    
    private var completedEntries: Int {
        entries.filter { $0.isCompleted }.count
    }
    private func goalEntries(
        for goal: LearningGoal
    ) -> [LearningEntry] {
        
        entries.filter {
            $0.topic == goal.title
        }
    }
    
    private func completedGoalEntries(
        for goal: LearningGoal
    ) -> Int {
        
        goalEntries(for: goal)
            .filter { $0.isCompleted }
            .count
    }
    
    private func progress(
        for goal: LearningGoal
    ) -> Double {
        
        let entries = goalEntries(for: goal)
        
        guard !entries.isEmpty else {
            return 0
        }
        
        return Double(
            completedGoalEntries(for: goal)
        ) / Double(entries.count)
    }
    
    
    private var dashboardHeader: some View {
        HStack(alignment: .top){
            VStack(alignment: .leading, spacing: 4){
                Text("Learning Journal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Keep growing every day")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            //        Circle()
            //            .fill(.purple.opacity(0.2))
            //            .frame(width: 56, height: 56)
            //            .overlay {
            //                Image(systemName: "person.fill")
            //                    .foregroundStyle(.purple)
            //            }
        }
    }
    
    private var goalCard: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("Current Goal")
                .font(.caption)
                .fontWeight(.bold)
            Text(currentGoal?.title ?? "No Goal Yet")
                .font(.title2)
                .fontWeight(.bold)
            HStack(spacing: 12){
                Text(
                    "\(completedGoalEntries(for: currentGoal!))/\(goalEntries(for: currentGoal!).count) completed"
                )
                Spacer()
                Text(
                    "\(Int(progress(for: currentGoal!) * 100))%"
                )
                .font(.largeTitle)
                .fontWeight(.bold)
            }
            ProgressView(
                value: progress(
                    for: currentGoal!
                )
            )
            .tint(.white)
            
        }
        .padding()
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
        )
    }
    
    private var statsSection: some View {
        
        HStack(spacing: 16) {
            NavigationLink {
                
                StatisticsView()
                
            } label: {
                
                streakCard
            }
            .buttonStyle(.plain)
            NavigationLink {
                
                StatisticsView()
                
            } label: {
                
                summaryCard
            }
            .buttonStyle(.plain)
        }
    }
    
    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("🔥")
                .font(.largeTitle)
            
            Text("12")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Day Streak")
                .font(.headline)
            
            Text("Best: 21 Days")
                .foregroundStyle(.secondary)
            
            Spacer()
            HStack(spacing: 4){
                ForEach(0..<7) { index in
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(index == 4 ? .gray.opacity(0.3) : .orange)
                        .frame(height: 8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180)
        .background(Color.yellow.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var summaryCard: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            
            HStack {
                
                Image(systemName: "book.fill")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.purple)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                VStack(alignment: .leading) {
                    
                    Text("\(totalEntries)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Entries")
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack {
                
                Image(systemName: "checkmark")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.green)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                VStack(alignment: .leading) {
                    
                    Text("\(completedEntries)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Completed")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 180)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var weeklyActivity: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("This Week")
                .font(.title3)
                .fontWeight(.bold)
            
            HStack(alignment: .bottom, spacing: 12) {
                
                let heights: [CGFloat] = [60, 35, 75, 50, 20, 60, 35]
                
                ForEach(0..<7) { index in
                    
                    VStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                index == 3
                                ? Color.purple
                                : Color.purple.opacity(0.15)
                            )
                            .frame(height: heights[index])
                        
                        Text(["M","T","W","T","F","S","S"][index])
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var quickActions: some View {
        
        HStack(spacing: 16) {
            
            NavigationLink {
                
                EntryFormView()
                
            } label: {
                
                Label("Add Entry", systemImage: "plus")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.indigo, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
            }
            
            NavigationLink {
                
                GoalFormView()
                
            } label: {
                
                Label("Add Goal", systemImage: "plus")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
            }
        }
    }
    private var recentEntries: some View {
        
        VStack(spacing: 16) {
            
            ForEach(entries.prefix(3)) { entry in
                
                NavigationLink {
                    
                    EntryDetailView(
                        entry: entry
                    )
                    
                } label: {
                    
                    entryCard(
                        title: entry.title,
                        topic: entry.topic,
                        date: entry.date.formatted(
                            date: .abbreviated,
                            time: .omitted
                        ),
                        status: entry.isCompleted
                        ? "Done"
                        : "In Progress"
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func entryCard(
        title: String,
        topic: String,
        date: String,
        status: String
    ) -> some View {
        
        HStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(.purple.opacity(0.2))
                .frame(width: 56, height: 56)
                .overlay {
                    
                    Image(systemName: "text.book.closed.fill")
                        .foregroundStyle(.purple)
                }
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(title)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    
                    Text(topic)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(date)
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    status == "Done"
                    ? Color.green.opacity(0.2)
                    : Color.orange.opacity(0.2)
                )
                .clipShape(
                    Capsule()
                )
        }
        .padding()
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}
#Preview {
    NavigationStack {
        DashboardView()
    }
}
