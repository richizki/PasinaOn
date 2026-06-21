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
    @State private var showDeleteAlert = false

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext
    var body: some View {
        
        //        goalDetailHeader
        
        ScrollView {
            VStack(spacing: 24) {

                heroCard

                targetDateCard

                entriesChecklistCard

//                goalStatusCard
            }
            .padding()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {

                NavigationLink {

                    EntryFormView(
                        selectedGoal: goal
                    )

                } label: {

                    Image(systemName: "plus")
                }
            }
            ToolbarItem(
                placement: .topBarTrailing
            ) {

                Menu {

                    NavigationLink {

                        GoalEditView(
                            goal: goal
                        )

                    } label: {

                        Label(
                            "Edit Goal",
                            systemImage: "pencil"
                        )
                    }

                    Button(
                        role: .destructive
                    ) {

                        showDeleteAlert = true

                    } label: {

                        Label(
                            "Delete Goal",
                            systemImage: "trash"
                        )
                    }

                } label: {

                    Image(
                        systemName: "ellipsis.circle"
                    )
                }
                .alert(
                    "Delete Goal?",
                    isPresented: $showDeleteAlert
                ) {

                    Button(
                        "Delete",
                        role: .destructive
                    ) {

                        modelContext.delete(goal)

                        do {
                            try modelContext.save()
                        } catch {
                            print(error)
                        }

                        dismiss()
                    }

                    Button(
                        "Cancel",
                        role: .cancel
                    ) { }

                } message: {

                    Text(
                        "This action cannot be undone."
                    )
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
    
    private var goalStatusTitle: String {

        if progress >= 1 {
            return "Completed"
        }

        if goalEntries.isEmpty {
            return "No Activity Yet"
        }

        return "In Progress"
    }

    private var goalStatusEmoji: String {

        if progress >= 1 {
            return "🏆"
        }

        if goalEntries.isEmpty {
            return "⚠️"
        }

        return "🔥"
    }

    private var goalStatusDescription: String {

        if progress >= 1 {
            return "Congratulations! This goal has been completed."
        }

        if goalEntries.isEmpty {
            return "Start adding learning entries to make progress."
        }

        return "\(completedEntries) of \(goalEntries.count) entries completed."
    }
    
    private var entriesChecklistCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                Text("Learning Entries")
                    .font(.headline)

                Spacer()


                Text("\(goalEntries.count)")
                    .foregroundStyle(.secondary)
            }

            if goalEntries.isEmpty {

                ContentUnavailableView {

                    Label(
                        "No Entries Yet",
                        systemImage: "book.closed"
                    )

                } description: {

                    Text(
                        "Add learning entries related to this goal."
                    )

                } actions: {

                    NavigationLink {

                        EntryFormView(
                            selectedGoal: goal
                        )

                    } label: {

                        Label(
                            "Add Entry",
                            systemImage: "plus"
                        )
                    }
                }

            } else {

                ForEach(goalEntries) { entry in

                    NavigationLink {

                        EntryDetailView(
                            entry: entry
                        )

                    } label: {

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

                            VStack(
                                alignment: .leading
                            ) {

                                Text(entry.title)

                                Text(
                                    entry.date.formatted(
                                        date: .abbreviated,
                                        time: .omitted
                                    )
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
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
    
    private var goalStatusCard: some View {

        HStack {

            Text(goalStatusEmoji)
                .font(.largeTitle)

            VStack(alignment: .leading) {

                Text("Goal Status")
                    .font(.title3)
                    .fontWeight(.bold)

                Text(goalStatusTitle)
                    .font(.headline)

                Text(goalStatusDescription)
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
