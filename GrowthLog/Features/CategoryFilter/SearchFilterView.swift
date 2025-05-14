//
//  SearchFilterView.swift
//  GrowthLog
//
//  Created by 백현진 on 5/13/25.
//

import SwiftUI
import SwiftData

struct SearchFilterView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: SearchFilterViewModel
    @State private var isPresented = false
    @State private var searchText = ""
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: SearchFilterViewModel(modelContext: modelContext))
    }
    
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
                                ForEach(results) { log in
                                    NavigationLink {
                                        LogDetailView(log: log, modelContext: modelContext)
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
                CategoryFilterView()
            }
            .onAppear {
                viewModel.fetchLogs()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LogMainData.self, Category.self, ChildCategory.self, configurations: config)
    
    let context = container.mainContext
    
    let previewCategory = Category(type: .programming)
    let previewTag = ChildCategory(type: .swift)
    previewTag.category = previewCategory
    

    let previewLog = LogMainData(
        id: 1,
        title: "SwiftUI 학습",
        keep: "SwiftUI 기본 개념을 이해했다",
        problem: "복잡한 레이아웃 구성이 어려웠다",
        tryContent: "더 많은 예제를 통해 연습해보기",
        creationDate: Date(),
        category: previewCategory,
        childCategory: previewTag
    )
    
    context.insert(previewCategory)
    context.insert(previewTag)
    context.insert(previewLog)
    
    return SearchFilterView(modelContext: context)
}
