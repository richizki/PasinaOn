//
//  EntryDetailView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    
    let entry: LearningEntry
    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.dismiss)
    private var dismiss

    @State private var showDeleteAlert = false
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 24) {
                
                heroCard
                
                reflectionCard
                
                metadataCards
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                
                Menu {
                    
                    NavigationLink {
                        
                        EntryEditView(
                            entry: entry
                        )
                        
                    } label: {
                        
                        Label(
                            "Edit",
                            systemImage: "pencil"
                        )
                    }
                    
                    Button(
                        role: .destructive
                    ) {
                        
                        showDeleteAlert = true
                        
                    } label: {
                        
                        Label(
                            "Delete",
                            systemImage: "trash"
                        )
                    }
                    
                } label: {
                    
                    Image(
                        systemName: "ellipsis.circle"
                    )
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
                    ) { }
                    
                } message: {
                    
                    Text(
                        "This action cannot be undone."
                    )
                }}
            
        }
    }
    
    
    private var heroCard: some View {
        
        VStack(
            alignment: .leading,
            spacing: 20
        ) {
            
            HStack {
                
                topicBadge
                
                statusBadge
            }
            
            Text(entry.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(
                entry.date.formatted(
                    date: .complete,
                    time: .omitted
                )
            )
        }
        .foregroundStyle(.white)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
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
    
    private var topicBadge: some View {
        
        Text(entry.topic)
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.white.opacity(0.2))
            .clipShape(Capsule())
    }
    
    private var statusBadge: some View {
        
        HStack(spacing: 6) {
            
            Image(
                systemName: entry.isCompleted
                ? "checkmark.circle.fill"
                : "clock.fill"
            )
            
            Text(
                entry.isCompleted
                ? "Completed"
                : "In Progress"
            )
        }
        .font(.headline)
        .foregroundStyle(
            entry.isCompleted
            ? .green
            : .orange
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.white.opacity(0.2))
        .clipShape(Capsule())
    }
    
    private var reflectionCard: some View {
        
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("REFLECTION")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Text(entry.reflection)
                .font(.body)
                .lineSpacing(6)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            Color(uiColor: .secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private var metadataCards: some View {
        
        HStack(spacing: 16) {
            
            metadataCard(
                emoji: "📅",
                title: "Date Logged",
                value: entry.date.formatted(
                    .dateTime.month(.abbreviated)
                    .day()
                )
            )
            
            metadataCard(
                emoji: "🏷️",
                title: "Topic",
                value: entry.topic
            )
        }
    }
    
    private func metadataCard(
        emoji: String,
        title: String,
        value: String
    ) -> some View {
        
        VStack(spacing: 12) {
            
            Text(emoji)
                .font(.largeTitle)
            
            Text(title)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 150
        )
        .padding()
        .background(
            Color(uiColor: .secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

#Preview {
    
    let sampleEntry = LearningEntry(
        title: "Building Forms in SwiftUI",
        topic: "SwiftUI",
        reflection: """
        Today I learned how to build forms using TextField, Toggle, DatePicker and Form.
        """,
        date: .now,
        isCompleted: true
    )
    
    NavigationStack {
        EntryDetailView(entry: sampleEntry)
    }
}
