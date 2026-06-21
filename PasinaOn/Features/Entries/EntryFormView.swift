//
//  EntryFormView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import SwiftUI
import SwiftData

struct EntryFormView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var title = ""
    
    @State private var selectedTopic: String
    
    @State private var reflection = ""
    
    @State private var date = Date()
    
    @State private var isCompleted = false
    
    @State private var hasTriedSave = false
    
    @Query(
        sort: \LearningGoal.title
    )
    
    private var goals: [LearningGoal]
    init(
        selectedGoal: LearningGoal? = nil
    ) {

        self.selectedGoal = selectedGoal

        _selectedTopic = State(
            initialValue:
                selectedGoal?.title ?? ""
        )
    }
    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                learningInformationSection

                reflectionSection

                dateStatusSection

                saveButton
            }
            .padding()
        }
        .navigationTitle("New Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Button("Save") {

                    hasTriedSave = true

                    if canSave {
                        saveEntry()
                    }
                }
                .fontWeight(.semibold)
            }
        }
        
    }
    
    private var canSave: Bool {

        !title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
        &&
        !selectedTopic.isEmpty
    }
    
    private func saveEntry() {

        print("BUTTON CLICKED")

        let entry = LearningEntry(
            title: title,
            topic: selectedTopic,
            reflection: reflection,
            date: date,
            isCompleted: isCompleted
        )

        print("ENTRY CREATED")

        modelContext.insert(entry)

        print("INSERTED")

        do {

            try modelContext.save()

            print("SAVE SUCCESS")

        } catch {

            print("SAVE FAILED")
            print(error)
        }

        dismiss()
    }
    
    
    private var learningInformationSection: some View {
        
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("Learning Information")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {

                TextField(
                    "What did you work on?",
                    text: $title
                )
                .textFieldStyle(.roundedBorder)

                if showTitleError {

                    Text("Please enter what you learned.")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            topicSection
        }
        .padding()
        .background(AppColor.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private var topicSection: some View {
        
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            
            Text("Topic")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            if goals.isEmpty {

                Text("Create a goal first before adding entries.")
                    .foregroundStyle(.secondary)

            } else {

                FlowLayout {
                    ForEach(goals) { goal in

                        Button {
                            selectedTopic = goal.title
                        } label: {

                            Text(goal.title)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .foregroundStyle(
                                    selectedTopic == goal.title
                                    ? .white
                                    : .primary
                                )
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(
                                    selectedTopic == goal.title
                                    ? AppColor.primary
                                    : AppColor.surfaceBackground
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }
    
    private var validationMessage: String {

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please enter what you learned."
        }

        if selectedTopic.isEmpty {
            return "Please select a topic."
        }

        return ""
    }
    
    private var reflectionSection: some View {
        
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("Reflection")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            TextEditor(
                text: $reflection
            )
            .frame(minHeight: 180)
            .scrollContentBackground(.hidden)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Color.gray.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
        .padding()
        .background(AppColor.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private var dateStatusSection: some View {
        
        VStack(spacing: 20) {
            
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            
            Toggle(
                "Completed Session",
                isOn: $isCompleted
            )
        }
        .padding()
        .background(AppColor.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private var showTitleError: Bool {

        hasTriedSave &&
        title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }
    private var titleValidationColor: Color {
        showTitleError
        ? .red.opacity(0.7)
        : .clear
    }
    
    private var saveButton: some View {

        VStack(spacing: 8) {

            Button {

                hasTriedSave = true

                if canSave {
                    saveEntry()
                }

            } label: {

                Text("Save Entry")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        canSave
                        ? AppColor.primary
                        : Color.gray.opacity(0.3)
                    )
            )

            if hasTriedSave && !canSave {

                Text(validationMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
    }
    let selectedGoal: LearningGoal?
    
}


#Preview {
    NavigationStack {
        EntryFormView()
    }
}
