//
//  StatisticsView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query
    private var goals: [LearningGoal]

    @Query(
        sort: \LearningEntry.date,
        order: .reverse
    )
    private var entries: [LearningEntry]
    var body: some View {
        VStack(spacing: 24) {
            statisticsHeader
            
            ScrollView {
                
                metricsGrid
                
                weeklyActivityCard
                
                progressSummaryCard
                
                topicsStudiedCard
                
                achievementsCard
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

private var statisticsHeader: some View {
    
    HStack {
        
        Text("Statistics")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        Spacer()
    }
}

private var metricsGrid: some View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    return LazyVGrid(
        columns: columns,
        spacing: 16
    ) {
        
        metricCard(
            emoji: "📚",
            value: "8",
            title: "Total Entries",
            subtitle: "all time",
            color: .purple
        )
        
        metricCard(
            emoji: "✅",
            value: "5",
            title: "Completed",
            subtitle: "63% rate",
            color: .green
        )
        
        metricCard(
            emoji: "🔥",
            value: "12",
            title: "Day Streak",
            subtitle: "best: 21",
            color: .orange
        )
        
        metricCard(
            emoji: "🏷",
            value: "4",
            title: "Topics",
            subtitle: "explored",
            color: .blue
        )
    }
}

private func metricCard(
    emoji: String,
    value: String,
    title: String,
    subtitle: String,
    color: Color
) -> some View {
    
    VStack(
        alignment: .leading,
        spacing: 12
    ) {
        
        Text(emoji)
            .font(.largeTitle)
        
        Text(value)
            .font(.system(size: 40, weight: .bold))
        
        Text(title)
            .font(.headline)
        
        Text(subtitle)
            .foregroundStyle(.secondary)
        
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .frame(height: 180)
    .padding()
    .background(
        AppColor.cardBackground
    )
    .clipShape(
        RoundedRectangle(cornerRadius: 24)
    )
}

private var weeklyActivityCard: some View {
    
    VStack(
        alignment: .leading,
        spacing: 20
    ) {
        
        Text("Weekly Activity")
            .font(.title3)
            .fontWeight(.bold)
        
        HStack(
            alignment: .bottom,
            spacing: 12
        ) {
            
            let heights: [CGFloat] = [
                60,
                20,
                80,
                40,
                100,
                20,
                60
            ]
            
            ForEach(0..<7) { index in
                
                VStack {
                    
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                    .fill(
                        index == 4
                        ? Color.purple
                        : Color.purple.opacity(0.15)
                    )
                    .frame(height: heights[index])
                    
                    Text(
                        ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][index]
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
    .padding()
    .background(
        AppColor.cardBackground
    )
    .clipShape(
        RoundedRectangle(cornerRadius: 24)
    )
}

private var progressSummaryCard: some View {
    
    VStack(
        alignment: .leading,
        spacing: 24
    ) {
        
        Text("Progress Summary")
            .font(.title3)
            .fontWeight(.bold)
        
        progressRow(
            title: "Completion Rate",
            value: "63%",
            progress: 0.63,
            color: .green
        )
        
        progressRow(
            title: "Goal Progress (Avg)",
            value: "45%",
            progress: 0.45,
            color: .purple
        )
        
        progressRow(
            title: "Streak Consistency",
            value: "80%",
            progress: 0.80,
            color: .orange
        )
    }
    .padding()
    .background(
        AppColor.cardBackground
    )
    .clipShape(
        RoundedRectangle(cornerRadius: 24)
    )
}

private func progressRow(
    title: String,
    value: String,
    progress: Double,
    color: Color
) -> some View {
    
    VStack(
        alignment: .leading,
        spacing: 12
    ) {
        
        HStack {
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text(value)
                .font(.headline)
        }
        
        ProgressView(value: progress)
            .tint(color)
    }
}

private var topicsStudiedCard: some View {
    
    VStack(
        alignment: .leading,
        spacing: 24
    ) {
        
        Text("Topics Studied")
            .font(.title3)
            .fontWeight(.bold)
        
        topicRow(
            color: .purple,
            title: "SwiftUI",
            entries: "4 entries",
            percentage: "50%",
            progress: 0.50
        )
        
        topicRow(
            color: .blue,
            title: "Swift",
            entries: "2 entries",
            percentage: "25%",
            progress: 0.25
        )
        
        topicRow(
            color: .pink,
            title: "SwiftData",
            entries: "1 entry",
            percentage: "13%",
            progress: 0.13
        )
        
        topicRow(
            color: .green,
            title: "Combine",
            entries: "1 entry",
            percentage: "13%",
            progress: 0.13
        )
    }
    .padding()
    .background(
        AppColor.cardBackground
    )
    .clipShape(
        RoundedRectangle(cornerRadius: 24)
    )
}

private func topicRow(
    color: Color,
    title: String,
    entries: String,
    percentage: String,
    progress: Double
) -> some View {
    
    VStack(
        alignment: .leading,
        spacing: 8
    ) {
        
        HStack {
            
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text("\(entries) • \(percentage)")
                .foregroundStyle(.secondary)
        }
        
        ProgressView(value: progress)
            .tint(color)
    }
}

private var achievementsCard: some View {
    
    VStack(
        alignment: .leading,
        spacing: 24
    ) {
        
        Text("Achievements")
            .font(.title3)
            .fontWeight(.bold)
        
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 16
        ) {
            
            achievementItem(
                emoji: "🔥",
                title: "Streak Starter",
                unlocked: true
            )
            
            achievementItem(
                emoji: "📚",
                title: "Bookworm",
                unlocked: true
            )
            
            achievementItem(
                emoji: "🎯",
                title: "Goal Setter",
                unlocked: true
            )
            
            achievementItem(
                emoji: "⚡️",
                title: "Swift Learner",
                unlocked: false
            )
            
            achievementItem(
                emoji: "🏆",
                title: "Champion",
                unlocked: false
            )
            
            achievementItem(
                emoji: "🌟",
                title: "All Topics",
                unlocked: false
            )
        }
    }
    .padding()
    .background(
        AppColor.cardBackground
    )
    .clipShape(
        RoundedRectangle(cornerRadius: 24)
    )
}

private func achievementItem(
    emoji: String,
    title: String,
    unlocked: Bool
) -> some View {
    
    VStack(spacing: 12) {
        
        Text(emoji)
            .font(.largeTitle)
        
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
    }
    .foregroundStyle(
        unlocked
        ? .primary
        : .secondary
    )
    .frame(maxWidth: .infinity)
    .frame(height: 120)
    .background(
        Color(uiColor: .tertiarySystemBackground)
    )
    .clipShape(
        RoundedRectangle(cornerRadius: 20)
    )
}

#Preview {
    NavigationStack {
        StatisticsView()
    }
}
