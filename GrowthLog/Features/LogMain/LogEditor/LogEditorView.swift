//
//  LogEditorView.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/12/25.
//
import SwiftUI
import SwiftData

// MARK: - 개발회고 작성화면
struct LogEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    
    @State private var title: String = ""
    @State private var keep: String = ""
    @State private var problem: String = ""
    @State private var tryContent: String = ""
    @State private var selectedCategoryId: Int = 1
    
    @State private var selectedChildCategory: [ChildCategory] = []
    @State private var insertTagTemp: [ChildCategory] = []
    
    @State var selectedCategoryType: CategoryType = .tech
    @StateObject private var viewModel = LogEditorViewModel()
    
    @State var presentCardModal = false
    @State var isSelectedAlert = false
    
    @Binding var isShowEditorView: Bool
    @State private var didLoadInitialData = false
    
    var logMainData: LogMainData? = nil
    var maxId: Int?
    
    private let contentsLeading: CGFloat = 10
    private let contentsHeight: CGFloat = 100

    
    private var stackToPadding: CGFloat {
        logMainData == nil ? 20 : 0
    }
    private var stackBottomPadding: CGFloat {
        logMainData == nil ? 30 : 0
    }
    private var stackHorizontalPadding: CGFloat {
        logMainData == nil ? 30 : 0
    }
    
    private var headerTags: [ChildCategory] {
        // 1) 편집 모드에서 이미 저장된 childCategories 가 있으면 그걸 그대로
        if let existing = logMainData?.childCategories, !existing.isEmpty {
          return existing
        }
        // 2) 모달에서 새로 선택한 게 있으면 그것을
        if !selectedChildCategory.isEmpty {
          return selectedChildCategory
        }
        // 3) 그 외에는 빈 배열
        return []
      }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.growthGreen.opacity(0.3))
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        
                        CategoryHeaderView(
                                  selectedCategoryType: selectedCategoryType,
                                  tags: headerTags
                                ) {
                                  presentCardModal = true
                                }
                        
                        
//                        Button {
//                            presentCardModal = true
//                        } label: {
//                            Text(selectedCategoryType.rawValue)
//                                .font(.callout)
//                                .foregroundStyle(.white)
//                                .padding(.horizontal, 10)
//                                .padding(.vertical, 5)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 7)
//                                        .fill(.growthGreen)
//                                )
//                                .onAppear {
//                                    if let categoryTitle = logMainData?.category?.type {
//                                        selectedCategoryType  = categoryTitle
//                                    }
//                                    
//                                }
//                        }
//                        
//                        HStack(spacing: 0) {
//                            Text("#\(logMainData?.childCategory?.name ?? "")")
//                                    .font(.caption)
//                                    .padding(.horizontal, 2)
//                                    .padding(.vertical, 2)
////                                    .onAppear {
////                                        // 이미 초기화했으면 건너뛰기
////                                        guard !didLoadInitialData else { return }
////                                        didLoadInitialData = true
////                                        
////                                        // 수정 모드일 때만
////                                        if let log = logMainData {
////                                            // 1) 버튼에 표시할 카테고리
////                                            selectedCategoryType = log.category?.type ?? .tech
////                                            
////                                            // 2) 헤더에 표시할 태그 배열
////                                            selectedChildCategory = log.category?.tags ?? []
////                                            
////                                            // 3) viewModel 내부에도 isSelected 업데이트
////                                            let types = selectedChildCategory.map(\.type)
////                                            viewModel.applySelections(to: selectedCategoryType,modalSelectedTags: types)
////                                        }
////                                    }
//                        }
//                        .padding(.horizontal, 5)
                        
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 17)
                .padding(.horizontal, 6)
                

                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 8)
                
                TextField("제목 - KPT 회고", text: $title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                    .onAppear {
                        if let logMainDataTitle = logMainData?.title {
                            title = logMainDataTitle
                        }
                    }
                
                // conetent(Keep/Problem/Try)
                HStack {
//                    EditorFieldsView(
//                              keep: $keep,
//                              problem: $problem,
//                              tryContent: $tryContent
//                            )
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Keep")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 9)
                        
                        TextEditor(text: $keep)
                            .font(.footnote)
                            .frame(height: contentsHeight)
                            .cornerRadius(8)
                            .padding(.horizontal, contentsLeading)
                            .onAppear {
                                if let oldKeep = logMainData?.keep {
                            		keep = oldKeep
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white.opacity(0.4))
                            )
                            .overlay(alignment: .topLeading) {
                                Text("현재 만족하고 있는 부분")
                                    .font(.footnote)
                                    .foregroundStyle(keep.isEmpty ? (colorScheme == .dark ? .white : .gray) : .clear)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                            }
                            // 글자 제한
//                            .onChange(of: keep) { newValue in
//                                if newValue.count > 50 {
//                                    print(newValue.count)
//                                    keep = String(newValue.prefix(50))
//                                }
//                            }
                        
                        Spacer()
                        
                        Text("Problem")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 9)
                        
                        TextEditor(text: $problem)
                            .font(.footnote)
                            .frame(height: contentsHeight)
                            .cornerRadius(8)
                            .padding(.leading, contentsLeading)
                            .onAppear {
                                if let oldProblem = logMainData?.problem {
                                    problem = oldProblem
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white.opacity(0.4))
                            )
                            .overlay(alignment: .topLeading) {
                                Text("개선이 필요하다고 생각되는 부분")
                                    .font(.footnote)
                                    .foregroundStyle(problem.isEmpty ? (colorScheme == .dark ? .white: .gray) : .clear)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                            }

                        Spacer()
                        
                        Text("Try")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 9)
                        
                        TextEditor(text: $tryContent)
                            .font(.footnote)
                            .frame(height: contentsHeight)
                            .cornerRadius(8)
                            .padding(.leading, contentsLeading)
                            .onAppear {
                                if let oldTryContent = logMainData?.tryContent {
                                    tryContent = oldTryContent
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white.opacity(0.4))
                            )
                            .overlay(alignment: .topLeading) {
                                Text("Problem에 대한 해결책")
                                    .font(.footnote)
                                    .foregroundStyle(tryContent.isEmpty ? (colorScheme == .dark ? .white : .gray) : .clear)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                            }
                        
                        Spacer()
                        Spacer()
                        
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 20)
            .onAppear {
                guard !didLoadInitialData else { return }
                didLoadInitialData = true
                if let log = logMainData {
                    // 1) 선택된 카테고리 복원
                    selectedCategoryType = log.category?.type ?? .tech
                    // 2) 선택된 태그 복원 (단일이든 복수든)
                    selectedChildCategory = log.childCategories
                    // 3) 뷰모델에 동기화
                    let types = selectedChildCategory.map(\.type)
                    viewModel.applySelections(to: selectedCategoryType, modalSelectedTags: types)
                }
            }
        }
        .padding(
            EdgeInsets(top: stackToPadding, leading: stackHorizontalPadding, bottom: stackBottomPadding, trailing: stackHorizontalPadding)
        )
        .navigationTitle(logMainData == nil ? "회고 등록" : "회고 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if logMainData == nil {
                        dismiss()
                    } else {
                        isShowEditorView = false
                    }
                } label: {
                    Image(systemName: "chevron.backward")
                        .bold()
                        .padding(.leading, -8)
                }
            }
            
            // 등록 / 수정
            ToolbarItem {
                Button {
                    save()
                    
                    // 등록
                    if logMainData == nil {
                        dismiss()
                    } else {
                        // 수정
                        isShowEditorView = false
                    }
                } label: {
                    Image(systemName: "checkmark")
                        .bold()
                        .padding(.leading, -8)
                }
            }
        }
        .sheet(isPresented: $presentCardModal) {
            CategoryModal(viewModel: viewModel, category: $selectedCategoryType, isSelectedAlert: $isSelectedAlert) { newTypes in
                guard let cat = viewModel.categories.first(where: { $0.type == selectedCategoryType }) else { return }
                selectedChildCategory = cat.tags.filter { newTypes.contains($0.type) }
            }
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.hidden)
        }
    }
}

// MARK: - 등록 / 수장
extension LogEditorView {
    
    func save() {
        let inputTag = !selectedChildCategory.isEmpty ? selectedChildCategory : (logMainData?.category?.tags ?? [])
        let inputCategory = Category(type: selectedCategoryType, tags: inputTag)
        
        
        if let logMainData {
            logMainData.title = title
            logMainData.category = inputCategory
            logMainData.keep = keep
            logMainData.problem = problem
            logMainData.tryContent = tryContent
            logMainData.creationDate = Date.now
        } else {
            let inputMainData = LogMainData(id: maxId.map { $0 + 1 } ?? 1, title: title, keep: keep, problem: problem, tryContent: tryContent, creationDate: Date.now, category: inputCategory, childCategories: inputTag)
            context.insert(inputMainData)
        }
        
    }
}



// MARK: - 카테고리, 태그 선택 모달
struct CategoryModal:  View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: LogEditorViewModel
    @Binding var category: CategoryType
    @Binding var isSelectedAlert: Bool
    
    /// Apply 시 선택된 태그 타입 배열을 돌려보낼 클로저
    let onApply: ([ChildCategoryType]) -> Void
    
    /// 모달 내부 복사본 상태
    @State private var modalCategory: CategoryType = .tech
    @State private var modalSelectedTags: [ChildCategoryType] = []
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    init(viewModel: LogEditorViewModel,category: Binding<CategoryType>,isSelectedAlert: Binding<Bool>
         ,onApply: @escaping ([ChildCategoryType]) -> Void) {
        self.viewModel = viewModel
        self._category = category
        self._isSelectedAlert = isSelectedAlert
        self.onApply = onApply

        // 모달 카테고리 복사
        let cat = category.wrappedValue
        self._modalCategory = State(initialValue: cat)

        // viewModel에서 isSelected인 태그 타입만 골라서 초기화
        let existing = viewModel.categories
          .first { $0.type == cat }?
          .tags.filter(\.isSelected)
          .map(\.type) ?? []
        self._modalSelectedTags = State(initialValue: existing)
      }

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Button("적용") {
                        // 1) 모달 카테고리 → 부모 바인딩
                        category = modalCategory
                        // 2) 뷰모델 태그 상태 덮어쓰기
                        viewModel.applySelections(to: modalCategory, modalSelectedTags: modalSelectedTags)
                        // 3) 선택된 타입 배열 전달
                        onApply(modalSelectedTags)
                        dismiss()
                    }
                }
                .padding(10)
                
                Picker("Category", selection: $modalCategory) {
                    ForEach(CategoryType.allCases) { Text($0.rawValue) }
                }
                .pickerStyle(.palette)
                .padding(.horizontal)
                .onChange(of: modalCategory) { newCat in
                    // 카테고리 변경 시 기존 isSelected 상태만 로드
                    modalSelectedTags = viewModel
                        .categories
                        .first(where: { $0.type == newCat })?
                        .tags
                        .filter(\.isSelected)
                        .map(\.type) ?? []
                }
                
                // — 2열 태그 그리드
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel
                        .categories
                        .first(where: { $0.type == modalCategory })?
                        .tags ?? [], id: \.type) { tag in
                            
                            let isOn = modalSelectedTags.contains(tag.type)
                            Text(tag.name)
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(isOn
                                            ? Color.growthGreen
                                            : Color.gray.opacity(0.1))
                                .foregroundColor(isOn
                                                 ? .white
                                                 : (colorScheme == .dark ? .white : .primary))
                                .cornerRadius(8)
                                .onTapGesture {
                                    if isOn {
                                        modalSelectedTags.removeAll { $0 == tag.type }
                                    } else if modalSelectedTags.count < 1 {
                                        modalSelectedTags.append(tag.type)
                                    } else {
                                        isSelectedAlert = true
                                    }
                                }
                        }
                }
                .padding()
                
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
        }
        .padding()
        .alert("태그는 1개만 선택할 수 있습니다.", isPresented: $isSelectedAlert) {
            Button("확인", role: .cancel) { }
        }
        
    }

}

struct CategoryHeaderView: View {
  let selectedCategoryType: CategoryType
  let tags: [ChildCategory]
  let onTapCategory: () -> Void

  var body: some View {
     VStack {
      Button { onTapCategory() } label: {
        Text(selectedCategoryType.rawValue)
          .font(.callout)
          .foregroundStyle(.white)
          .padding(.horizontal, 10).padding(.vertical, 5)
          .background(RoundedRectangle(cornerRadius: 7).fill(.growthGreen))
      }
      HStack(spacing: 4) {
        ForEach(tags) { tag in
          Text("#\(tag.name)")
            .font(.caption2)
            .padding(4)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(4)
        }
      }
    }
    .padding(.vertical, 10)
  }
}


struct EditorFieldsView: View {
  @Binding var keep: String
  @Binding var problem: String
  @Binding var tryContent: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Group {
        Text("Keep").bold()
        TextEditor(text: $keep).frame(height: 100)
      }
      Group {
        Text("Problem").bold()
        TextEditor(text: $problem).frame(height: 100)
      }
      Group {
        Text("Try").bold()
        TextEditor(text: $tryContent).frame(height: 100)
      }
    }
    .padding(.horizontal)
  }
}
    
#Preview {
    @Previewable @State var isShowEditorView2: Bool = false
    
    // SwiftData 미리보기 환경 설정
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LogMainData.self, Category.self, ChildCategory.self, configurations: config)
    
    // 더미 ModelContext 생성
    let context = container.mainContext
    
    // 미리보기용 카테고리 및 태그 생성
    let previewCategory = Category(type: .programming)
    let previewTag = ChildCategory(type: .swift)
    previewTag.category = previewCategory
    
    context.insert(previewCategory)
    context.insert(previewTag)
    
    // LogListViewModel 생성
    let viewModel = LogListViewModel(modelContext: context)
    
    // 작성 모드 (신규)
    return LogEditorView(isShowEditorView: $isShowEditorView2)
    
//     편집 모드를 보고 싶다면 아래 코드 사용:
    /*
     미리보기용 로그 생성
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
    
    context.insert(previewLog)
    
    return LogEditorView(viewModel: viewModel, editingLog: previewLog)
    */
//>>>>>>> feat/LogMainModel
}


    
//#Preview {
//    @Previewable @State var isShowEditorView2: Bool = false
//    LogEditorView(isShowEditorView: $isShowEditorView2)
//}

