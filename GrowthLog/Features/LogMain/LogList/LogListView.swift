//
//  LogListView.swift
//  GrowthLog
//
//  Created by Seohyun Kim Kim on 5/12/25.
//
import SwiftUI
import SwiftData

struct LogListView: View {
    @State private var isShowSampleCell = false
    @State private var isShowEditorView = false
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: LogListViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: LogListViewModel(modelContext: modelContext)
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.logs.isEmpty {
                    Text("아직 작성한 회고가 없습니다.")
                        .padding()
                } else {
                    logList
                }
            }
            .navigationTitle("회고")
            .toolbar {
                toolbarItems
            }
            .navigationDestination(isPresented: $isShowSampleCell) {
                SampleCell()
            }
            .navigationDestination(isPresented: $isShowEditorView) {
                LogEditorView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchLogs()
            }
        }
    }
    
    // 리스트 뷰를 별도 속성으로 분리
    private var logList: some View {
        List {
            ForEach(viewModel.logs) { log in
                logListItem(for: log)
            }
        }
        .listStyle(.plain)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
    }
    
    // 리스트 항목을 별도 메서드로 분리
    private func logListItem(for log: LogMainData) -> some View {
        ZStack(alignment: .leading) {
            // LogListCell 호출 시 매개변수 이름 확인 (logMainData인지 log인지)
            LogListCell(logMainData: log)
                .padding(.vertical, 5)
            
            NavigationLink {
                // 매개변수 이름을 modelContext로 변경
                LogDetailView(log: log, modelContext: modelContext)
            } label: {
                EmptyView()
            }
            .opacity(0.0)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.deleteLog(log: log)
            } label: {
                Label("삭제", systemImage: "trash")
            }
        }
    }
    
    // 툴바 항목들을 별도 속성으로 분리
    private var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowEditorView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowSampleCell = true
                } label: {
                    Image(systemName: "gearshape.fill")
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
    
    context.insert(previewCategory)
    context.insert(previewTag)
    context.insert(previewLog)
    
    return LogListView(modelContext: context)
}
