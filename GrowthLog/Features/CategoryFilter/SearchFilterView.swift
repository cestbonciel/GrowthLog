//
//  SearchFilterView.swift
//  GrowthLog
//
//  Created by 백현진 on 5/13/25.
//

import SwiftUI
import SwiftData


struct SearchFilterView: View {
    @State private var viewModel = SearchFilterViewModel()
    @State private var isPresented = false
    @State private var searchText = ""
    @State private var selectedTags: [ChildCategory] = []

    // 1️⃣ 태그로 먼저 필터링
    private var tagFilteredLogs: [LogItem] {
        guard !selectedTags.isEmpty else {
            return viewModel.items
        }
        let tagIDs = Set(selectedTags.map(\.id))
        return viewModel.items.filter { log in
            !tagIDs.isDisjoint(with: log.category.tags.map(\.id))
        }
    }

    // 2️⃣ 그다음 검색어로 필터링
    private var finalFilteredLogs: [LogItem] {
        guard !searchText.isEmpty else {
            return tagFilteredLogs
        }
        return tagFilteredLogs.filter { log in
            // 예: 제목 또는 본문에 검색어가 포함된 경우
            log.title?.localizedCaseInsensitiveContains(searchText) == true ||
            log.keep.localizedCaseInsensitiveContains(searchText) ||
            log.problem.localizedCaseInsensitiveContains(searchText) ||
            log.tryContents.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    if searchText.isEmpty && selectedTags.isEmpty {
                        // 초기 안내
                        HStack {
                            Text("검색어를 입력하거나 필터를 적용해주세요")
                                .foregroundColor(.gray)
                                .font(.title3)
                            Image(systemName: "text.page.badge.magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)

                    } else {
                        let results = finalFilteredLogs

                        if results.isEmpty {
                            Text("검색 결과가 없습니다")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding(.top, 100)
                        } else {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(results, id: \.id) { item in
                                    NavigationLink {
                                        LogDetailView(logMainData: item)
                                    } label: {
                                        LogListCell(item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .searchable(text: $searchText)
            }
            .navigationTitle("검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
            }
            .navigationDestination(isPresented: $isPresented) {
                CategoryFilterView(selectedTags: $selectedTags)
            }
        }
    }
}

#Preview {
    SearchFilterView()

}
