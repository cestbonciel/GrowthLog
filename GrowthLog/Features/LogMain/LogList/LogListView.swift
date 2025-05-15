//
//  LogListView.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/12/25.
//
import SwiftUI
import SwiftData

struct LogListView: View {
    @Environment(\.modelContext) var context
    
    @State private var isShowSampleCell = false
    @State private var isShowEditorView = false
    @State private var isLoading = true
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: LogListViewModel
    
    @Query(sort: [SortDescriptor(\LogMainData.creationDate, order: .reverse)])
    var logMainData: [LogMainData]
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: LogListViewModel(modelContext: modelContext)
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if logMainData.isEmpty {
                    Text("아직 작성한 회고가 없습니다.")
                } else {
                    ZStack {
                        listCell(items: logMainData)
                            .listStyle(.plain)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
                        
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                NavigationLink(destination: LogEditorView(isShowEditorView: $isShowEditorView, logMainData: nil)) {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.gray.opacity(0.8))
                                        .overlay {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 25)
                                                .foregroundStyle(.white)
                                                .offset(x: 2, y: -2)
                                        }
                                        .offset(x: -10, y: -10)
                                }
                            }
                            .padding()
                        }
                        .padding()
                        
                    }
                }
            }
//            .navigationTitle("GrowthLog")
            .navigationTitle("회고 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowSampleCell = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .navigationDestination(isPresented: $isShowSampleCell) {
                //LogSettingView()
            }
        }
    }
    
    // 회고 list 출력
    private func listCell(items: [LogMainData]) -> some View {
        List {
            ForEach(items) { item in
                ZStack(alignment: .leading) {
                    LogListCell(logMainData: item)
                        .padding(.vertical, 5)
                    NavigationLink {
                        LogDetailView(logMainData: item)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: delete)
        }
    }
}

#Preview {
    //SwiftData 미리보기 환경 설정
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LogMainData.self/*, Category.self, ChildCategory.self*/, configurations: config)
    
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
