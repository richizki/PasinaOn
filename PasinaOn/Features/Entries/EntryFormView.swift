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
    
    @State private var selectedTopic = ""
    
    @State private var reflection = ""
    
    @State private var date = Date()
    
    @State private var isCompleted = false
    
    @Query(
        sort: \LearningGoal.title
    )
    private var goals: [LearningGoal]
    
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
            
//                ToolbarItem(placement: .topBarLeading) {
//
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Button("Save") {
                    saveEntry()
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
    
//    var body: some View {
//        
//        NavigationStack {
//            
//            ScrollView {
//                
//                VStack(spacing: 24) {
//                    
//                    learningInformationSection
//                    
//                    reflectionSection
//                    
//                    dateStatusSection
//                    
//                    saveButton
//                }
//                .padding()
//            }
//            .navigationTitle("New Entry")
//            .navigationBarTitleDisplayMode(.inline)
//
//        }
//    }
    
    private var learningInformationSection: some View {
        
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("LEARNING INFORMATION")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            TextField(
                "What did you work on?",
                text: $title
            )
            .textFieldStyle(.roundedBorder)
            
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
                .font(.headline)

            if goals.isEmpty {

                Text("Create a goal first before adding entries.")
                    .foregroundStyle(.secondary)

            } else {

                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 100))
                    ]
                ) {

                    ForEach(goals) { goal in

                        Button {

                            selectedTopic = goal.title

                        } label: {

                            Text(goal.title)
                                .fontWeight(.semibold)
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
    
    private var reflectionSection: some View {
        
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("REFLECTION")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            TextEditor(
                text: $reflection
            )
            .frame(minHeight: 180)
            .lineLimit(8)
            .textFieldStyle(.roundedBorder)
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
    
    private var saveButton: some View {

        Button {
            saveEntry()
        } label: {
            
            Text("Save Entry")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColor.primary)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
        }
        .background(
            canSave
            ? AppColor.primary
            : Color.gray.opacity(0.3)
        )
        .disabled(!canSave)
    }
}


#Preview {
    NavigationStack {
        EntryFormView()
    }
}
