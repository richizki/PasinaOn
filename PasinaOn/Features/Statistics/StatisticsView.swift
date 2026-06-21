//
//  StatisticsView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import SwiftUI
import SwiftData
import Charts

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
    private var completedEntries: Int {
        
        entries.filter {
            $0.isCompleted
        }.count
    }
    
    private var completionRate: Int {
        
        guard !entries.isEmpty else {
            return 0
        }
        
        return Int(
            Double(completedEntries)
            / Double(entries.count)
            * 100
        )
    }
    
    private var topicsCount: Int {
        
        Set(
            entries.map(\.topic)
        ).count
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
                value: "\(entries.count)",
                title: "Total Entries",
                subtitle: "all time",
                color: .purple
            )
            
            metricCard(
                emoji: "✅",
                value: "\(completedEntries)",
                title: "Completed",
                subtitle: "\(completionRate)% rate",
                color: .green
            )
            
            metricCard(
                emoji: "🎯",
                value: "\(goals.count)",
                title: "Goals",
                subtitle: "active goals",
                color: .orange
            )
            
            metricCard(
                emoji: "🏷",
                value: "\(topicsCount)",
                title: "Topics",
                subtitle: "explored",
                color: .blue
            )
        }
    }
    
    private func goalEntries(
        for goal: LearningGoal
    ) -> [LearningEntry] {
        
        entries.filter {
            $0.topic == goal.title
        }
    }
    
    private func goalProgress(
        for goal: LearningGoal
    ) -> Double {
        
        let goalEntries = goalEntries(for: goal)
        
        guard !goalEntries.isEmpty else {
            return 0
        }
        
        let completed = goalEntries.filter {
            $0.isCompleted
        }.count
        
        return Double(completed)
        / Double(goalEntries.count)
    }
    
    private var averageGoalProgress: Int {
        
        guard !goals.isEmpty else {
            return 0
        }
        
        let total = goals.reduce(0.0) {
            $0 + goalProgress(for: $1)
        }
        
        return Int(
            total / Double(goals.count) * 100
        )
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
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
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

                ForEach(0..<7, id: \.self) { index in

                    let count = entriesCountForDayOffset(
                        6 - index
                    )

                    VStack {

                        Text("\(count)")
                            .font(.caption2)

                        RoundedRectangle(
                            cornerRadius: 8
                        )
                        .fill(
                            count > 0
                            ? Color.purple
                            : Color.purple.opacity(0.15)
                        )
                        .frame(
                            height:
                                count == 0
                                ? 8
                                : CGFloat(count) * 20
                        )

                        Text(
                            dayLabelForOffset(
                                6 - index
                            )
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
                value: "\(completionRate)%",
                progress: Double(completionRate) / 100,
                color: .green
            )
            
            progressRow(
                title: "Goal Progress (Avg)",
                value: "\(averageGoalProgress)%",
                progress: Double(averageGoalProgress) / 100,
                color: .purple
            )
            
            progressRow(
                title: "Current Streak",
                value: "\(currentStreak) days",
                progress: min(
                    Double(currentStreak) / 30,
                    1.0
                ),
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
    
    
    
    private func entriesCountForDayOffset(
        _ offset: Int
    ) -> Int {

        let calendar = Calendar.current

        guard let targetDate = calendar.date(
            byAdding: .day,
            value: -offset,
            to: Date()
        ) else {
            return 0
        }

        return entries.filter {

            calendar.isDate(
                $0.date,
                inSameDayAs: targetDate
            )

        }.count
    }
    
    private func dayLabelForOffset(
        _ offset: Int
    ) -> String {

        let calendar = Calendar.current

        guard let date = calendar.date(
            byAdding: .day,
            value: -offset,
            to: Date()
        ) else {
            return ""
        }

        return date.formatted(
            .dateTime.weekday(.narrow)
        )
    }
    
    private var topicStatistics: [(topic: String, count: Int)] {

        Dictionary(
            grouping: entries,
            by: { $0.topic }
        )
        .map {

            (
                topic: $0.key,
                count: $0.value.count
            )
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

            Chart(topicStatistics, id: \.topic) { topic in

                SectorMark(
                    angle: .value(
                        "Entries",
                        topic.count
                    )
                )
                .foregroundStyle(
                    by: .value(
                        "Topic",
                        topic.topic
                    )
                )
            }
            .frame(height: 240)
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
    private var currentStreak: Int {

        let calendar = Calendar.current

        let uniqueDays = Set(
            entries.map {
                calendar.startOfDay(
                    for: $0.date
                )
            }
        )

        let sortedDays = uniqueDays.sorted(
            by: >
        )

        guard let firstDay = sortedDays.first else {
            return 0
        }

        var streak = 1
        var currentDay = firstDay

        for day in sortedDays.dropFirst() {

            guard let previousDay = calendar.date(
                byAdding: .day,
                value: -1,
                to: currentDay
            ) else {
                break
            }

            if calendar.isDate(
                day,
                inSameDayAs: previousDay
            ) {

                streak += 1
                currentDay = day

            } else {

                break
            }
        }

        return streak
    }

    
    private var hasBookworm: Bool {
        entries.count >= 10
    }

    private var hasGoalSetter: Bool {
        goals.count >= 1
    }

    private var hasConsistency: Bool {
        currentStreak >= 7
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
                spacing: 8
            ) {
                
                achievementItem(
                    emoji: "📚",
                    title: "Bookworm",
                    unlocked: hasBookworm
                )

                achievementItem(
                    emoji: "🎯",
                    title: "Goal Setter",
                    unlocked: hasGoalSetter
                )

                achievementItem(
                    emoji: "🔥",
                    title: "Consistency",
                    unlocked: hasConsistency
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
}

#Preview {
    NavigationStack {
        StatisticsView()
    }
}
