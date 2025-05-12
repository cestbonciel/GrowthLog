//
//  CategoryFilterView.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//

import SwiftUI
import SwiftData

/// 임시 뷰입니다 - 카테고리와 태그 기반 검색 기능 필터링 구현 뷰입니다.
struct CategoryFilterView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CategoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 카테고리 선택 (세그먼트 컨트롤)
                if !viewModel.categories.isEmpty {
                    Picker("카테고리", selection: $viewModel.selectedCategoryIndex) {
                        ForEach(0..<viewModel.categories.count, id: \.self) { index in
                            Text(viewModel.categories[index].title).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // 현재 선택된 카테고리 제목
                    Text(viewModel.currentCategory.title)
                        .font(.headline)
                        .padding(.top)
                    
                    // 태그 버튼 그리드
                    ScrollView {
                        if let currentCategory = viewModel.safeCurrentCategory {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 10) {
                                ForEach(Array(currentCategory.tags.enumerated()), id: \.offset) { index, tag in
                                    Button(action: {
                                        viewModel.toggleTagSelection(tagIndex: index)
                                    }) {
                                        Text(tag.name)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .frame(maxWidth: .infinity)
                                            .background(tag.isSelected ? Color.blue : Color.gray.opacity(0.2))
                                            .foregroundColor(tag.isSelected ? .white : .primary)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                        } else {
                            Text("카테고리를 로드하는 중...")
                                .padding()
                        }
                    }
                } else {
                    ProgressView("카테고리를 로드 중입니다...")
                }
                
                Spacer()
            }
            .navigationTitle("카테고리 및 태그")
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.loadData()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Category.self,
        Tag.self,
        configurations: config
    )
    CategoryFilterView()
        .modelContainer(container)
}
