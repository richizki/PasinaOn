//
//  GoalsView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import SwiftUI
import SwiftData

struct GoalsView: View {
    @Query(
        sort: \LearningGoal.targetDate
    )
    private var goals: [LearningGoal]
    
    @Query
    private var entries: [LearningEntry]
    
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            goalsHeader
            
            summaryCard
            
            ScrollView {
                goalList
            }
        }
        .padding()
        
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func goalEntries(
        for goal: LearningGoal
    ) -> [LearningEntry] {
        
        entries.filter {
            $0.topic == goal.title
        }
    }
    
    private func completedEntries(
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
            completedEntries(for: goal)
        ) / Double(entries.count)
    }
    
    private var averageProgress: Int {
        
        guard !goals.isEmpty else {
            return 0
        }
        
        let totalProgress = goals.reduce(0.0) {
            $0 + progress(for: $1)
        }
        
        return Int(
            (totalProgress / Double(goals.count)) * 100
        )
    }
    
    private var goalList: some View {
        
        VStack(spacing: 24) {
            
            ForEach(goals) { goal in
                
                NavigationLink {
                    
                    GoalDetailView(
                        goal: goal
                    )
                    
                } label: {
                    
                    goalCard(
                        emoji: "🎯",
                        title: goal.title,
                        description: goal.goalDescription,
                        progress: progress(for: goal),
                        milestones: "\(completedEntries(for: goal))/\(goalEntries(for: goal).count) completed",
                        percentage: "\(Int(progress(for: goal) * 100))%",
                        dueDate: goal.targetDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        ),
                        colors: [.indigo, .purple]
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    private var summaryCard: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text("Active Goals")
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("\(goals.count)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                
                Text("Avg Progress")
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("\(averageProgress)%")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    
    private var goalsHeader: some View {
        
        HStack {
            
            Text("Goals")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            NavigationLink {
                
                GoalFormView()
                
            } label: {
                
                FloatingAddButton()
            }
            .buttonStyle(.plain)
        }
    }
    
    
    
    private func goalCard(
        emoji: String,
        title: String,
        description: String,
        progress: Double,
        milestones: String,
        percentage: String,
        dueDate: String,
        colors: [Color]
    ) -> some View {
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text(emoji)
                    .font(.largeTitle)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(description)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            
            VStack(spacing: 16) {
                
                HStack {
                    
                    Text(milestones)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(percentage)
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                ProgressView(value: progress)
                
                HStack {
                    
                    Text(dueDate)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(AppColor.cardBackground)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
        
    }
}

#Preview {
    NavigationStack {
        GoalsView()
    }
}
