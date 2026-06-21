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
    
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize
    
    var body: some View {
        VStack(spacing: 24) {
            dashboardHeader
            
            ScrollView {
                VStack(spacing: 32) {
                    if let currentGoal {
                        
                        NavigationLink {
                            
                            GoalDetailView(
                                goal: currentGoal
                            )
                            
                        } label: {
                            
                            goalCard
                        }
                        .buttonStyle(.plain)
                        
                    } else {
                        
                        goalCard
                    }
                    statsSection
                    weeklyActivity
                    quickActions
                    recentEntries
                }
            }
        }
        .padding()
        .dynamicTypeSize(.xSmall ... .accessibility5)
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
    
    private var dashboardHeader: some View {
        HStack(alignment: .top){
            VStack(alignment: .leading, spacing: 4){
                Text("Learning Journal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                Text("Keep growing every day")
                    .foregroundStyle(.secondary)
                    .font(.body)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
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

        VStack(alignment: .leading, spacing: dynamicTypeSize.isAccessibilitySize ? 24 : 20) {

            if let currentGoal {

                Text("Current Goal")
                    .fontWeight(.bold)
                    .font(.caption)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)

                Text(currentGoal.title)
                    .fontWeight(.bold)
                    .font(.title2)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 12) {

                    Text(
                        "\(completedGoalEntries(for: currentGoal))/\(goalEntries(for: currentGoal).count) completed"
                    )
                    .font(.caption)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)

                    Spacer()

                    Text(
                        "\(Int(progress(for: currentGoal) * 100))%"
                    )
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                }

                ProgressView(
                    value: progress(for: currentGoal)
                )
                .tint(.white)

            } else {

                Text("Current Goal")
                    .fontWeight(.bold)
                    .font(.caption)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)

                Text("No Goal Yet")
                    .fontWeight(.bold)
                    .font(.title2)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)

                Text("Create your first learning goal")
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.caption)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
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
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private var statsSection: some View {

        Group {

            if dynamicTypeSize.isAccessibilitySize {

                VStack(spacing: 16) {

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

            } else {

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
        }
    }
    
    private var streakCard: some View {
        VStack(alignment: .leading, spacing: dynamicTypeSize.isAccessibilitySize ? 24 : 12){
//            Text("🔥")
//                .font(.largeTitle)
            
            Text("\(streak)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text("Day Streak")
                .font(.headline)
            
            Text("Current Streak")
                .foregroundStyle(.secondary)
                .font(.caption)
            
            Spacer()
            HStack(spacing: 4){
                ForEach(0..<7) { index in
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            index < min(streak, 7)
                            ? .orange
                            : .gray.opacity(0.3)
                        )
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
        
        VStack(alignment: .leading, spacing: dynamicTypeSize.isAccessibilitySize ? 24 : 24) {
            
            HStack {
                
                Image(systemName: "book.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading) {
                    
                    Text("\(totalEntries)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("Entries")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                }
            }
            
            HStack {
                
                Image(systemName: "checkmark")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading) {
                    
                    Text("\(completedEntries)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("Completed")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .leading)
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var weeklyActivity: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("This Week")
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)

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
                            .foregroundStyle(.secondary)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)

                        RoundedRectangle(
                            cornerRadius: 8
                        )
                        .fill(
                            count > 0
                            ? Color.purple
                            : Color.purple.opacity(0.15)
                        )
                        .frame(
                            height: max(
                                CGFloat(count) * 20,
                                20
                            )
                        )

                        Text(
                            dayLabelForOffset(
                                6 - index
                            )
                        )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding()
        .background(.background)
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
                    .background(.background)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
            }
            
        }
    }
    private var recentEntries: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Recent Entries")
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)

            if entries.isEmpty {

                if goals.isEmpty {

                    NavigationLink {

                        GoalFormView()

                    } label: {

                        emptyStateCard(
                            icon: "target",
                            title: "No Goals Yet",
                            message: "Create your first learning goal.",
                            buttonTitle: "Create Goal"
                        )
                    }
                    .buttonStyle(.plain)

                } else {

                    NavigationLink {

                        EntryFormView()

                    } label: {

                        emptyStateCard(
                            icon: "book.closed",
                            title: "No Entries Yet",
                            message: "Start documenting what you learn.",
                            buttonTitle: "Create Entry"
                        )
                    }
                    .buttonStyle(.plain)
                }

            } else {

                ForEach(entries.prefix(3)) { entry in

                    NavigationLink {

                        EntryDetailView(entry: entry)

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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var streak: Int {

        let calendar = Calendar.current

        let dates = Set(
            entries.map {
                calendar.startOfDay(
                    for: $0.date
                )
            }
        )

        guard let latestDate = dates.max()
        else {
            return 0
        }

        var currentDate = latestDate
        var streak = 0

        while dates.contains(currentDate) {

            streak += 1

            currentDate =
            calendar.date(
                byAdding: .day,
                value: -1,
                to: currentDate
            )!
        }

        return streak
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
    
    private func entriesCountForWeekday(
        _ weekday: Int
    ) -> Int {

        entries.filter {

            Calendar.current.component(
                .weekday,
                from: $0.date
            ) == weekday

        }.count
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
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    
                    Text(topic)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(date)
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
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
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
    private func emptyStateCard(
        icon: String,
        title: String,
        message: String,
        buttonTitle: String
    ) -> some View {

        VStack(spacing: 12) {

            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.purple)

            Text(title)
                .font(.headline)
                .lineLimit(nil)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)

            Text(buttonTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.purple)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .lineLimit(nil)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color(.secondarySystemBackground))
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
