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
    @State var viewModel = CategoryViewModel()
    @State var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let error = errorMessage {
                    Text("데이터 로드 오류: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if isLoading {
                    ProgressView("카테고리를 로드 중입니다...")
                        .padding()
                        .tint(.primary)
                } else if viewModel.categories.isEmpty {
                    Text("카테고리가 없습니다.")
                        .padding()
                } else {
                    // 카테고리 선택 (세그먼트 컨트롤)
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
                }
                
                Spacer()
            }
            .navigationTitle("카테고리 및 태그")
            .onAppear {
                loadDataSafely()
            }
        }
    }
    
    private func loadDataSafely() {
        isLoading = true
        errorMessage = nil
        
        // Task를 사용하여 비동기적으로 처리
        Task {
            do {
                viewModel.modelContext = modelContext
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5초 대기
                
                // UI 업데이트는 메인 쓰레드에서
                await MainActor.run {
                    // 데이터 로드 및 초기 설정
                    viewModel.loadData()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    // 미리보기를 위한 인메모리 컨테이너 생성
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Category.self, ChildCategory.self, configurations: config)
    
    // 테스트 데이터 생성 및 삽입
    let viewModel = CategoryViewModel()
    viewModel.setupInitialData()
    
    for category in viewModel.categories {
        container.mainContext.insert(category)
    }
    
    return CategoryFilterView()
        .modelContainer(container)
}

// 편의를 위한 미리보기 - 데이터 로드 없이 바로 결과 확인용
#Preview {
    // 미리보기를 위한 인메모리 컨테이너 생성
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Category.self, ChildCategory.self, configurations: config)
    
    // 테스트 데이터 생성 및 삽입
    let viewModel = CategoryViewModel()
    viewModel.setupInitialData()
    
    for category in viewModel.categories {
        container.mainContext.insert(category)
    }
    
    return CategoryFilterView()
        .modelContainer(container)
}

// 편의를 위한 미리보기 - 데이터 로드 없이 바로 결과 확인용
struct PreloadedCategoryFilterView: View {
    @State private var viewModel: CategoryViewModel
    
    init() {
        let vm = CategoryViewModel()
        vm.setupInitialData()
        self._viewModel = State(initialValue: vm)
    }
    
    var body: some View {
        CategoryFilterView(viewModel: viewModel, isLoading: false)
    }
}

#Preview("데이터 로드됨") {
    PreloadedCategoryFilterView()
}
