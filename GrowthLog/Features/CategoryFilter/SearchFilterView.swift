//
//  SearchFilterView.swift
//  GrowthLog
//
//  Created by 백현진 on 5/13/25.
//

import SwiftUI
import SwiftData


struct SearchFilterView: View {
    // SwiftData에 저장된 전체 로그를 불러옵니다
    @Query(sort: [SortDescriptor(\LogMainData.creationDate, order: .reverse)])
    private var allLogs: [LogMainData]

    // 카테고리 필터 뷰모델을 한 번만 생성, 다음 스택에서 @ObservedObject로 전달할 것
    @StateObject private var categoryViewModel = CategoryFilterViewModel()

    // 검색어 & 태그 필터링 상태
    @State private var searchText = ""
    @State private var selectedTags: [ChildCategoryType] = []
    @State private var isShowingFilter = false



    // 태그 필터 + 텍스트 필터 조합 계산 프로퍼티
    private var filteredLogs: [LogMainData] {
        // 태그 필터
        var result = allLogs
        if !selectedTags.isEmpty {
            result = result.filter { log in
                guard let child = log.childCategory else { return false }
                return selectedTags.contains(child.type)
            }
        }
        // 검색어 필터
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
                    // 검색어도 없고 태그도 없고
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
                    // 칭 결과 무
                    else if filteredLogs.isEmpty {
                        Text("검색 결과가 없습니다")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .padding(.top, 100)
                    }
                    // 매칭 결과 유
                    else {
                        VStack(spacing: 12) {

                            HStack {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.green.opacity(0.2))

                                // 만약 카테고리 필터가 적용될 경우 태그 띄우기
                                if !selectedTags.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(selectedTags, id: \.self) { type in
                                                Text(type.rawValue)
                                                    .font(.caption2)
                                                    .padding(.vertical, 4)
                                                    .padding(.horizontal, 8)
                                                    .background(Color.green.opacity(0.2))
                                                    .foregroundColor(.green)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            }
                                        }
                                        .padding(.horizontal, 5)
                                    }
                                }

                                Spacer()

                            }
                            .padding(.leading, 20)

                            Spacer()


                            // 총 개수 표시
                            HStack {
                                Text("총 \(filteredLogs.count)개 결과")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal)

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
                            .padding(.horizontal, 20)
                        }
                    }
                }
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
                // 필터 화면으로 이동, 선택된 태그를 binding으로 전달
                .navigationDestination(isPresented: $isShowingFilter) {
                    CategoryFilterView(viewModel: categoryViewModel, selectedTags: $selectedTags)
                }
            }
        }
    }
}
    #Preview {
        SearchFilterView()
    }
