//
//  GoalEditView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 16/06/26.
//
import SwiftUI
import SwiftData

struct GoalEditView: View {
    
    let goal: LearningGoal
    
    @Environment(\.dismiss)
    private var dismiss
    @Environment(\.modelContext)
    private var modelContext
    
    @State private var title: String
    @State private var goalDescription: String
    @State private var targetDate: Date
    @State private var showDeleteAlert = false
    
    init(goal: LearningGoal) {
        
        self.goal = goal
        
        _title = State(initialValue: goal.title)
        _goalDescription = State(initialValue: goal.goalDescription)
        _targetDate = State(initialValue: goal.targetDate)
    }
    
    var body: some View {
        
        Form {
            
            goalInformationSection
            
            targetDateSection
            
            deleteSection
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
            ) {

            }

        } message: {

            Text(
                "This action cannot be undone."
            )
        }
        .navigationTitle("Edit Goal")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            
            ToolbarItem(
                placement: .confirmationAction
            ) {
                
                Button("Save") {

                    goal.title = title
                    goal.goalDescription = goalDescription
                    goal.targetDate = targetDate

                    do {
                        try modelContext.save()
                    } catch {
                        print(error)
                    }

                    dismiss()
                }
                .fontWeight(.semibold)
                .disabled(!canSave)
            }
        }
    }
    private var canSave: Bool {

        !title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }
    private var goalInformationSection: some View {
        
        Section("Goal Information") {
            
            TextField(
                "Goal Title",
                text: $title
            )
            .disabled(true)
            TextField(
                "Description",
                text: $goalDescription,
                axis: .vertical
            )
            .lineLimit(4...8)
        }
    }
    private var targetDateSection: some View {
        
        Section("Target Date") {
            
            DatePicker(
                "Target Date",
                selection: $targetDate,
                displayedComponents: .date
            )
        }
    }
    private var deleteSection: some View {

        Section {

            Button(
                role: .destructive
            ) {

                showDeleteAlert = true

            } label: {

                Text("Delete Goal")
            }

        } footer: {

            Text(
                "This action cannot be undone."
            )
        }
    }
}

#Preview {

    NavigationStack {

        GoalEditView(
            goal: previewGoal
        )
    }
}
