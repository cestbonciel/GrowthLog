//
//  LogEditorView.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//
import SwiftUI
import SwiftData

// MARK: - 개발회고 작성화면

struct LogEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var keep: String = ""
    @State private var problem: String = ""
    @State private var tryContent: String = ""
    @State private var selectedCategoryId: Int = 1
    @State private var selectedChildCategoryType: String = ""
    
    var viewModel: LogListViewModel
    var editingLog: LogMainData? // 수정 모드일 경우 사용
    
    var isEditMode: Bool {
        editingLog != nil
    }
    
    init(viewModel: LogListViewModel, editingLog: LogMainData? = nil) {
        self.viewModel = viewModel
        self.editingLog = editingLog
        
        if let log = editingLog {
            _title = State(initialValue: log.title ?? "")
            _keep = State(initialValue: log.keep)
            _problem = State(initialValue: log.problem)
            _tryContent = State(initialValue: log.tryContent)
            _selectedCategoryId = State(initialValue: log.category?.id ?? 1)
            _selectedChildCategoryType = State(initialValue: log.childCategory?.type.rawValue ?? "")
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 제목 입력
                    TextField("제목 (선택사항)", text: $title)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    // 카테고리 선택
                    VStack(alignment: .leading) {
                        Text("카테고리")
                            .font(.headline)
                        
                        Picker("카테고리", selection: $selectedCategoryId) {
                            ForEach(viewModel.categories) { category in
                                Text(category.title).tag(category.id)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 8)
                    }
                    
                    // 태그 선택
                    VStack(alignment: .leading) {
                        Text("태그")
                            .font(.headline)
                        
                        // 선택된 카테고리에 해당하는 태그만 표시
                        let filteredTags = viewModel.childCategories.filter { tag in
                            tag.category?.id == selectedCategoryId
                        }
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                            ForEach(filteredTags) { tag in
                                Button(action: {
                                    selectedChildCategoryType = tag.type.rawValue
                                }) {
                                    Text("#\(tag.name)")
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            selectedChildCategoryType == tag.type.rawValue ?
                                            Color.growthGreen : Color.gray.opacity(0.2)
                                        )
                                        .foregroundColor(
                                            selectedChildCategoryType == tag.type.rawValue ?
                                            .white : .primary
                                        )
                                        .cornerRadius(5)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Keep 입력
                    VStack(alignment: .leading) {
                        Text("Keep")
                            .font(.headline)
                        
                        TextEditor(text: $keep)
                            .padding()
                            .frame(height: 120)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Problem 입력
                    VStack(alignment: .leading) {
                        Text("Problem")
                            .font(.headline)
                        
                        TextEditor(text: $problem)
                            .padding()
                            .frame(height: 120)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Try 입력
                    VStack(alignment: .leading) {
                        Text("Try")
                            .font(.headline)
                        
                        TextEditor(text: $tryContent)
                            .padding()
                            .frame(height: 120)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding()
            }
            .navigationTitle(isEditMode ? "회고 수정" : "회고 작성")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditMode ? "수정" : "저장") {
                        if isEditMode, let log = editingLog {
                            viewModel.updateLog(
                                log: log,
                                title: title.isEmpty ? nil : title,
                                categoryId: selectedCategoryId,
                                childCategoryType: selectedChildCategoryType,
                                keep: keep,
                                problem: problem,
                                tryContent: tryContent
                            )
                        } else {
                            viewModel.addLog(
                                title: title.isEmpty ? nil : title,
                                categoryId: selectedCategoryId,
                                childCategoryType: selectedChildCategoryType,
                                keep: keep,
                                problem: problem,
                                tryContent: tryContent
                            )
                        }
                        dismiss()
                    }
                    .disabled(keep.isEmpty || problem.isEmpty || tryContent.isEmpty || selectedChildCategoryType.isEmpty)
                }
            }
        }
    }
}


#Preview {
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
    return LogEditorView(viewModel: viewModel)
    
    // 편집 모드를 보고 싶다면 아래 코드 사용:
    /*
    // 미리보기용 로그 생성
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
}
