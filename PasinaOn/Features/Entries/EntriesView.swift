//
//  EntriesView.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 12/06/26.
//

import SwiftUI
import SwiftData

enum EntryFilter {
    case all
    case completed
    case inProgress
    case thisWeek
}

struct EntriesView: View {
    @Query(
        sort: \LearningEntry.date,
        order: .reverse
    )
    private var entries: [LearningEntry]
    @State private var searchText = ""

    @State private var selectedFilter: EntryFilter = .all
    
    private var filteredEntries: [LearningEntry] {

        var result = entries

        if !searchText.isEmpty {

            result = result.filter {

                $0.title.localizedCaseInsensitiveContains(searchText)
                ||
                $0.topic.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch selectedFilter {

        case .all:
            break

        case .completed:

            result = result.filter {
                $0.isCompleted
            }

        case .inProgress:

            result = result.filter {
                !$0.isCompleted
            }

        case .thisWeek:

            let calendar = Calendar.current

            result = result.filter {

                calendar.isDate(
                    $0.date,
                    equalTo: Date(),
                    toGranularity: .weekOfYear
                )
            }
        }

        return result
    }
    
    @Environment(\.modelContext)
    private var modelContext

    var body: some View {

        VStack(spacing: 0) {

//            Text("Count: \(entries.count)")
//                .font(.headline)

            entriesHeader
                .padding()

            ScrollView {

                VStack(spacing: 24) {

    //                Button("Test Insert") {
    //
    //                    let entry = LearningEntry(
    //                        title: "TEST",
    //                        topic: "SwiftData",
    //                        reflection: "Testing"
    //                    )
    //
    //                    modelContext.insert(entry)
    //
    //                    do {
    //                        try modelContext.save()
    //                        print("SAVE SUCCESS")
    //                    } catch {
    //                        print("SAVE FAILED:", error)
    //                    }
    //                }

                    searchBar

                    filterChips

                    entriesList
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            print("ENTRIES COUNT:", entries.count)

            entries.forEach {
                print($0.title)
            }
        }
    }
    
    private var entriesHeader: some View {
        
        HStack {
            
            Text("Entries")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            NavigationLink {
                
                EntryFormView()
                
            } label: {
                
                FloatingAddButton()
            }
            .buttonStyle(.plain)
        }
    }
    
    
    
    private var searchBar: some View {

        HStack {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search entries...",
                text: $searchText
            )
        }
        .padding()
        .background(
            Color.gray.opacity(0.1)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
    
    private var filterChips: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                
                chip(
                    title: "All",
                    filter: .all
                )

                chip(
                    title: "Completed",
                    filter: .completed
                )

                chip(
                    title: "In Progress",
                    filter: .inProgress
                )

                chip(
                    title: "This Week",
                    filter: .thisWeek
                )
            }
        }
    }
    
    private func chip(
        title: String,
        filter: EntryFilter
    ) -> some View {
        
        Button {

            selectedFilter = filter

        } label: {

            Text(title)
                .fontWeight(.semibold)
                .foregroundStyle(
                    selectedFilter == filter
                    ? .white
                    : .primary
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    selectedFilter == filter
                    ? Color.purple
                    : Color.gray.opacity(0.1)
                )
                .clipShape(Capsule())
        }
    }
    
    private var entriesList: some View {

        VStack(spacing: 16) {

            ForEach(filteredEntries) { entry in

                NavigationLink {

                    EntryDetailView(
                        entry: entry
                    )

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
    
    private func entryCard(
        title: String,
        topic: String,
        date: String,
        status: String
    ) -> some View {
        
        HStack(spacing: 16) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(.purple.opacity(0.2))
                .frame(width: 56, height: 56)
                .overlay {
                    
                    Image(systemName: "text.book.closed.fill")
                        .foregroundStyle(.purple)
                }
            
            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text(title)
                    .font(.headline)

                HStack(spacing: 8) {

                    Text(topic)
                        .foregroundStyle(.secondary)

                    Text("•")

                    Text(date)
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(status)
                .fixedSize()
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    status == "Done"
                    ? Color.green.opacity(0.2)
                    : Color.orange.opacity(0.2)
                )
                .clipShape(Capsule())
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    NavigationStack {
        EntriesView()
    }
}
