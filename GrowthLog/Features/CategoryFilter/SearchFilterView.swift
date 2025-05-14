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

  //카테ㅐ고리 탭 필터링 계산속성
//    var filteredLogs: [LogItem] {
//        guard !selectedTags.isEmpty else { return viewModel.items }
//
//            return viewModel.items.filter { log in
//                !Set(log.category.tags.map(\.id)).isDisjoint(with: selectedTags.map(\.id))
//            }
//        }


    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    if searchText.isEmpty {
                        // 초기
                        HStack {
                            Text("검색어를 입력해주세요")
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
                        let results = viewModel.filteredResults(for: searchText)

                        if results.isEmpty {
                            // 검색 결과 없음
                            Text("검색 결과가 없습니다")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding(.top, 100)
                        } else {
                            // 검색 결과
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
