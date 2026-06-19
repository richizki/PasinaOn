//
//  GoalDetailView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//
import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Query
    private var entries: [LearningEntry]
    let goal: LearningGoal
    
    var body: some View {
        
        //        goalDetailHeader
        
        ScrollView {
            VStack(spacing: 24) {

                heroCard

                targetDateCard

                entriesChecklistCard

                progressStatusCard
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                
                NavigationLink {
                    
                    GoalEditView(
                        goal: goal
                    )
                    
                } label: {
                    
                    Text("Edit")
                        .fontWeight(.semibold)
                }
            }
        }
        
    }
    private var goalEntries: [LearningEntry] {

        entries.filter {
            $0.topic == goal.title
        }
    }
    private var completedEntries: Int {

        goalEntries.filter {
            $0.isCompleted
        }.count
    }
    private var progress: Double {

        guard !goalEntries.isEmpty else {
            return 0
        }

        return Double(completedEntries)
            / Double(goalEntries.count)
    }
    private var heroCard: some View {
        
        VStack(
            alignment: .leading,
            spacing: 24
        ) {
            
            Text("🎯")
                .font(.largeTitle)
            
            Text(goal.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(goal.goalDescription)
                .foregroundStyle(.white.opacity(0.85))
            
            HStack {

                Text("\(completedEntries)/\(goalEntries.count) completed")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            ProgressView(value: progress)
                .tint(.white)
            
        }
        .foregroundStyle(.white)
        .padding()
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
    
    private var targetDateCard: some View {
        
        HStack {
            
            Image(systemName: "calendar")
                .font(.largeTitle)
            
            VStack(
                alignment: .leading
            ) {
                
                Text("Target Date")
                    .foregroundStyle(.secondary)
                
                Text(
                    goal.targetDate.formatted(
                        date: .long,
                        time: .omitted
                    )
                )
                .font(.title2)
                .fontWeight(.bold)
            }
            
            Spacer()
            

            Text("\(daysRemaining) days left")
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.purple.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding()
        .background(
            Color(uiColor: .secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    private var daysRemaining: Int {

        Calendar.current.dateComponents(
            [.day],
            from: .now,
            to: goal.targetDate
        ).day ?? 0
    }
    private var entriesChecklistCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("LEARNING ENTRIES")
                .font(.headline)

            if goalEntries.isEmpty {

                ContentUnavailableView(
                    "No Entries Yet",
                    systemImage: "book.closed",
                    description: Text(
                        "Add learning entries related to this goal."
                    )
                )

            } else {

                ForEach(goalEntries) { entry in

                    HStack {

                        Image(
                            systemName:
                            entry.isCompleted
                            ? "checkmark.circle.fill"
                            : "circle"
                        )
                        .foregroundStyle(
                            entry.isCompleted
                            ? .green
                            : .secondary
                        )

                        Text(entry.title)

                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            Color(uiColor: .secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private var progressStatusCard: some View {

        HStack {

            Text("✅")
                .font(.largeTitle)

            VStack(alignment: .leading) {

                Text("Completion Rate")
                    .font(.title3)
                    .fontWeight(.bold)

                Text(
                    "\(completedEntries) of \(goalEntries.count) entries completed"
                )
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            Color(uiColor: .secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

    let previewGoal = LearningGoal(
        title: "Complete SwiftUI Fundamentals",
        goalDescription: "Master the core SwiftUI components, state management patterns, and navigation.",
        targetDate: .now
    )

    #Preview {

        NavigationStack {

            GoalDetailView(
                goal: previewGoal
            )
        }
    }
