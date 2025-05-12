//
//  LogListView.swift
//  GrowthLog
//
//  Created by Seohyun Kim Kim on 5/12/25.
//

import SwiftUI

// MARK: Dummy Data - 원래 Data > Model
struct LogItem: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    
    var formattedDate: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }
}

struct LogListView: View {
    private let items: [LogItem] = [
        .init(title: "SwiftUI 학습",       date: Date().addingTimeInterval(-1*24*3600)),
        .init(title: "CoreData CRUD 구현", date: Date().addingTimeInterval(-2*24*3600)),
        .init(title: "MVVM 구조 적용",     date: Date().addingTimeInterval(-3*24*3600)),
        .init(title: "UI 리팩토링",        date: Date().addingTimeInterval(-4*24*3600))
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        List {

            Section(header: Text("Grid View").font(.headline)) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.subheadline).bold()
                            Text(item.formattedDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                .padding(.vertical, 8)
            }
            

            Section(header: Text("List View").font(.headline)) {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.body)
                            Text(item.formattedDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
    }
}

#Preview {
    LogListView()
}


