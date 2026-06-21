//
//  EntryEditView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 16/06/26.
//

import SwiftUI
import SwiftData

struct EntryEditView: View {

    let entry: LearningEntry

    @State private var title: String
    @State private var topic: String
    @State private var reflection: String
    @State private var date: Date
    @State private var isCompleted: Bool
    @State private var hasTriedSave = false
    @State private var showDeleteAlert = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext)
    private var modelContext
    @Query(
        sort: \LearningGoal.title
    )
    private var goals: [LearningGoal]
    
    init(entry: LearningEntry) {

        self.entry = entry

        _title = State(initialValue: entry.title)
        _topic = State(initialValue: entry.topic)
        _reflection = State(initialValue: entry.reflection)
        _date = State(initialValue: entry.date)
        _isCompleted = State(initialValue: entry.isCompleted)
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                learningInformationSection

                reflectionSection

                dateStatusSection

                deleteSection
            }
            .padding()
        }
        .alert(
            "Delete Entry?",
            isPresented: $showDeleteAlert
        ) {

            Button(
                "Delete",
                role: .destructive
            ) {

                modelContext.delete(entry)

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
        .navigationTitle("Edit Entry")
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {

//            ToolbarItem(
//                placement: .cancellationAction
//            ) {
//
//                Button("Cancel") {
//                    dismiss()
//                }
//            }

            ToolbarItem(
                placement: .confirmationAction
            ) {

                Button("Save") {

                    hasTriedSave = true

                    if canSave {

                        entry.title = title
                        entry.topic = topic
                        entry.reflection = reflection
                        entry.date = date
                        entry.isCompleted = isCompleted

                        do {
                            try modelContext.save()
                        } catch {
                            print(error)
                        }

                        dismiss()
                    }
                }
                .fontWeight(.semibold)
            }
        }
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

            TextField(
                "What did you work on?",
                text: $title
            )
            .textFieldStyle(.roundedBorder)

            topicSelector
        }
        .padding()
        .background(AppColor.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
        
    }

    private var topicSelector: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("Topic")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            if goals.isEmpty {

                Text("Create a goal first before editing entries.")
                    .foregroundStyle(.secondary)

            } else {

    
                    FlowLayout {
                        ForEach(goals) { goal in

                            Button {
                                topic = goal.title
                            } label: {

                                Text(goal.title)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                    .foregroundStyle(
                                        topic == goal.title
                                        ? .white
                                        : .primary
                                    )
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background(
                                        topic == goal.title
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
    
    private var deleteSection: some View {

        VStack(spacing: 8) {

            VStack {

                Button(
                    "Delete Entry",
                    role: .destructive
                ) {

                    showDeleteAlert = true
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppColor.cardBackground)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )

            Text(
                "This action cannot be undone."
            )
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }
    
    private var canSave: Bool {

        !title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
        &&
        !topic.isEmpty
    }
    
}

let previewEntry = LearningEntry(
    title: "Building Forms in SwiftUI",
    topic: "SwiftUI",
    reflection: """
    Today I learned how to build native forms using the SwiftUI Form component...
    """,
    date: .now,
    isCompleted: true
)

#Preview {

    NavigationStack {

        EntryEditView(
            entry: previewEntry
        )
    }
}


