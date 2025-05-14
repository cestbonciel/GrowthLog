//
//  SearchFilterView.swift
//  GrowthLog
//
//  Created by 백현진 on 5/13/25.
//

import SwiftUI
import SwiftData


struct SearchFilterView: View {
    // 1) SwiftData에 저장된 전체 로그를 불러옵니다
    @Query(sort: [SortDescriptor(\LogMainData.creationDate, order: .reverse)])
    private var allLogs: [LogMainData]

    // 2) 검색어 & 태그 필터링 상태
    @State private var searchText = ""
    @State private var selectedTags: [ChildCategory] = []
    @State private var isShowingFilter = false

    // 3) 태그 필터 + 텍스트 필터 조합 계산 프로퍼티
    private var filteredLogs: [LogMainData] {
        // 3-1) 태그 필터
        var result = allLogs
        if !selectedTags.isEmpty {
            result = result.filter { log in
                guard let child = log.childCategory else { return false }
                return selectedTags.contains(where: { $0.id == child.id })
            }
        }
        // 3-2) 검색어 필터
        if !searchText.isEmpty {
            result = result.filter { log in
                let titleOrKeep = log.title ?? log.keep
                return titleOrKeep.localizedCaseInsensitiveContains(searchText)
                    || log.keep.localizedCaseInsensitiveContains(searchText)
                    || log.problem.localizedCaseInsensitiveContains(searchText)
                    || log.tryContent.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    // 4-1) 검색어/태그 모두 비어 있을 때 안내문구
                    if searchText.isEmpty && selectedTags.isEmpty {
                        VStack(spacing: 8) {
                            Text("검색어를 입력하거나 필터를 설정해주세요")
                                .foregroundColor(.gray)
                                .font(.title3)
                            Image(systemName: "text.page.badge.magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    }
                    // 4-2) 필터 또는 검색어에 매칭되는 로그가 없으면
                    else if filteredLogs.isEmpty {
                        Text("검색 결과가 없습니다")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .padding(.top, 100)
                    }
                    // 4-3) 매칭되는 로그가 있으면 리스트 표시
                    else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredLogs, id: \.id) { log in
                                NavigationLink {
                                    LogDetailView(logMainData: log)
                                } label: {
                                    LogListCell(logMainData: log)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            // 5) SwiftUI  시점에 맞춰 검색바와 필터 버튼 배치
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
            }
            // 6) 필터 화면으로 이동, 선택된 태그를 binding으로 전달
            .navigationDestination(isPresented: $isShowingFilter) {
                CategoryFilterView(selectedTags: $selectedTags)
            }
        }
    }
}

#Preview {
    SearchFilterView()
}
