//
//  LogListView.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/12/25.
//
import SwiftUI
import SwiftData

struct LogListView: View {
    @StateObject private var viewModel: LogListViewModel
    @State private var isShowEditorView = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: LogListViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.logs.isEmpty {
                    Text("아직 작성한 회고가 없습니다.")
                        .foregroundColor(.gray)
                } else {
                    listCell(items: viewModel.logs)
                }
            }
            .navigationTitle("회고 목록")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowEditorView = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $isShowEditorView) {
                LogEditorView(isShowEditorView: $isShowEditorView, logMainData: nil)
            }
            .navigationDestination(for: Int.self) { id in
                if let log = viewModel.log(for: id) {
                    LogDetailView(logMainData: log)
                } else {
                    Text("회고 데이터를 찾을 수 없습니다.")
                }
            }
        }
        .onAppear {
            viewModel.fetchLogs()
        }
    }

    private func listCell(items: [LogMainData]) -> some View {
        List {
            ForEach(items) { item in
                ZStack {
                    LogListCell(logMainData: item)
                        .padding(.vertical, 5)

                    NavigationLink(value: item.id) {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: viewModel.deleteLog)
        }
        .listStyle(.plain)
    }
}

#Preview {
    do {
        // 인메모리 SwiftData 컨테이너 생성
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: LogMainData.self, Category.self, ChildCategory.self, configurations: config)
        let context = container.mainContext

        // 더미 데이터 준비
        let category = Category(type: .programming)
        let tag = ChildCategory(type: .swift)
        tag.category = category
        category.tags = [tag]

        let log = LogMainData(
            id: 1,
            title: "SwiftUI 회고",
            keep: "StateObject에 대해 배웠다",
            problem: "초기화 위치에 따라 다른 동작",
            tryContent: "뷰 생명주기 공부하기",
            creationDate: Date(),
            category: category,
            childCategory: tag
        )

        // SwiftData 컨텍스트에 삽입
        context.insert(category)
        context.insert(tag)
        context.insert(log)

        return LogListView(modelContext: context)

    } catch {
        return Text("프리뷰 생성 실패: \(error.localizedDescription)")
    }
}
