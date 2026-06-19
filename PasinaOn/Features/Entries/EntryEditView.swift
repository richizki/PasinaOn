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
                .disabled(!canSave)
                .fontWeight(.semibold)
            }
        }
    }
    private var learningInformationSection: some View {

        Section("LEARNING INFORMATION") {

            TextField(
                "Title",
                text: $title
            )

            topicSelector
        }
    }

    private var topicSelector: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            if goals.isEmpty {

                Text("Create a goal first before editing entries.")
                    .foregroundStyle(.secondary)

            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 100))
                    ]
                ) {
                    
                    ForEach(goals) { goal in
                        
                        Button {
                            
                            topic = goal.title
                            
                        } label: {
                            
                            Text(goal.title)
                                .fontWeight(.semibold)
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

        Section("REFLECTION") {

            TextEditor(
                text: $reflection
            )
            .frame(minHeight: 200)
        }
    }
    private var dateStatusSection: some View {

        Section("DATE & STATUS") {

            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: .date
            )

            Toggle(
                "Completed",
                isOn: $isCompleted
            )

            Text(
                "Mark this session as complete to track your progress."
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }
    private var deleteSection: some View {

        Section {

            Button(
                "Delete Entry",
                role: .destructive
            ) {

                showDeleteAlert = true
            }

        } footer: {

            Text(
                "This action cannot be undone."
            )
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


