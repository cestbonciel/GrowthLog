//
//  LogDetailView.swift
//  GrowthLog
//
//  Created by Jooyong Lee on 5/12/25.
//

import SwiftUI
import SwiftData

struct LogDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isShowEditorView = false
    /// 더미에서 LogMainData로 수정
    let log: LogMainData
    @StateObject private var viewModel: LogListViewModel
    
    private let contentsLeading: CGFloat = 7
    
    init(log: LogMainData, modelContext: ModelContext) {
        self.log = log
        _viewModel = StateObject(wrappedValue: LogListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.growthGreen.opacity(0.3))
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(log.category?.title ?? "카테고리 없음")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(.growthGreen)
                            )
                        if let childCategory = log.childCategory {
                            Text("#\(childCategory.name)")
                                .font(.caption)
                                .padding(.horizontal, 5)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(log.formattedDate)
                        
                        Text(log.formattedtime)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                
                Text(log.title ?? log.keep)
                    .font(.title)
                    .padding()
                    .padding(.horizontal, 5)
                
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Keep")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 10)
                        
                        Text(log.keep)
                            .font(.footnote)
                            .padding(.leading, contentsLeading)
                        
                        Spacer()
                        
                        Text("Problem")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 10)
                        
                        Text(log.problem)
                            .font(.footnote)
                            .padding(.leading, contentsLeading)
                        
                        Spacer()
                        
                        Text("Try")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 10)
                        
                        Text(log.tryContent)
                            .font(.footnote)
                            .bold()
                            .padding(.leading, contentsLeading)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding()
                
            }
            
        }
        .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
        .navigationTitle("회고 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    isShowEditorView = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .navigationDestination(isPresented: $isShowEditorView) {
            LogEditorView(viewModel: viewModel, editingLog: log)
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
    
    // viewModel이 아닌 context를 전달해야 함
    return LogDetailView(log: previewLog, modelContext: context)
}
