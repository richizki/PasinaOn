//
//  GoalFormView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//
import SwiftUI
import SwiftData

struct GoalFormView: View {

    @State private var title = ""
    @State private var goalDescription = ""

    @State private var targetDate = Date()

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext)
    
    private var modelContext

    var body: some View {

        Form {

            goalInformationSection

            targetDateSection
        }
        .navigationTitle("Add Goal")
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {

//            ToolbarItem(
//                placement: .topBarLeading
//            ) {
//
//                Button("Cancel") {
//                    dismiss()
//                }
//            }

            ToolbarItem(
                placement: .topBarTrailing
            ) {

                Button("Save") {

                    saveGoal()
                }
                .fontWeight(.semibold)
                .disabled(title.isEmpty)
            }
        }
    }
    
    private func saveGoal() {

        let goal = LearningGoal(
            title: title,
            goalDescription: goalDescription,
            targetDate: targetDate
        )

        modelContext.insert(goal)

        do {
            try modelContext.save()
        } catch {
            print(error)
        }

        dismiss()
    }
    
    private var goalInformationSection: some View {

        Section("Goal Information") {

            TextField(
                "Goal Title",
                text: $title
            )

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
    
//    private var goalPreviewSection: some View {
//
//        Section("GOAL PREVIEW") {
//
//            VStack(spacing: 24) {
//
//                if title.isEmpty {
//
//                    VStack(spacing: 16) {
//
//                        Image(systemName: "target")
//                            .font(.largeTitle)
//
//                        Text("Goal Preview")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//
//                        Text("Your goal will appear here")
//                            .foregroundStyle(.secondary)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 40)
//
//                } else {
//
//                    previewCard
//                }
//            }
//        }
//    }
//    private var targetDateSection: some View {
//
//        Section("TARGET DATE") {
//
//            DatePicker(
//                "Target Date",
//                selection: $targetDate,
//                displayedComponents: .date
//            )
//        }
//    }
//    private var previewCard: some View {
//
//        VStack(
//            alignment: .leading,
//            spacing: 20
//        ) {
//
//            HStack {
//
//                VStack(
//                    alignment: .leading
//                ) {
//
//                    Text(title)
//                        .font(.title2)
//                        .fontWeight(.bold)
//
//                    Text("0 of \(targetEntries) entries")
//                        .foregroundStyle(.secondary)
//                }
//
//                Spacer()
//
//                ZStack {
//
//                    Circle()
//                        .stroke(
//                            Color.secondary.opacity(0.2),
//                            lineWidth: 8
//                        )
//
//                    Text("0%")
//                        .fontWeight(.bold)
//                }
//                .frame(
//                    width: 72,
//                    height: 72
//                )
//            }
//
//            ProgressView(value: 0)
//
//            HStack {
//
//                Text("Just getting started")
//
//                Spacer()
//
//                Text("\(targetEntries) entries needed")
//            }
//            .foregroundStyle(.secondary)
//            .font(.caption)
//        }
//        .padding(.vertical)
//    }
}

#Preview {

    NavigationStack {

        GoalFormView()
    }
}

