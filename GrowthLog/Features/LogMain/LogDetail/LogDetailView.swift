//
//  LogDetailView.swift
//  GrowthLog
//
// MARK: - 작성화면 디테일뷰(조회, 삭제, 수정)
//  Created by Jooyong Lee on 5/12/25.
//

import SwiftUI
import SwiftData

struct LogDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowEditorView = false
    
    /// 더미에서 LogMainData로 수정
    let logMainData: LogMainData
    
    private let contentsLeading: CGFloat = 7
    
    var body: some View {
        ZStack {
            if isShowEditorView {
                LogEditorView(isShowEditorView: $isShowEditorView, logMainData: logMainData, maxId: nil)
            } else  {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.growthGreen.opacity(0.3))
                    .frame(maxWidth: .infinity)
                
                VStack(spacing: 0) {
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(logMainData.category?.title ?? "")
                                .font(.callout)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.growthGreen)
                                )
                            
                            HStack(spacing: 0) {
                                ForEach(logMainData.childCategories) { tag in
                                    Text("#\(tag.name)")
                                        .font(.caption)
                                        .padding(.horizontal, 2)
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                        .padding(.horizontal , 10)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            Text(logMainData.formattedDate)
                            
                            Text(logMainData.formattedtime)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 10)
                    }
                    .padding()
                    
                    Rectangle()
                        .frame(height: 1)
                        .padding(.horizontal, 25)
                    
                    Text(logMainData.title ?? "KTP 회고")
                        .font(.title)
                        .padding(.top)
                        .padding(.horizontal, 5)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Keep")
                                .font(.subheadline)
                                .bold()
                                .padding(.vertical, 10)
                            
                            Text(logMainData.keep)
                                .font(.footnote)
                                .padding(.leading, contentsLeading)
                            
                            Spacer()
                            
                            Text("Problem")
                                .font(.subheadline)
                                .bold()
                                .padding(.vertical, 10)
                            
                            Text(logMainData.problem)
                                .font(.footnote)
                                .padding(.leading, contentsLeading)
                            
                            Spacer()
                            
                            Text("Try")
                                .font(.subheadline)
                                .bold()
                                .padding(.vertical, 10)
                            
                            Text(logMainData.tryContent)
                                .font(.footnote)
                                .padding(.leading, contentsLeading)
                            
                            Spacer()
                            Spacer()
                        }
                        Spacer()
                        
                    }
                    .padding(.horizontal, 30)
                    
                }
                
                Button {
                    isShowEditorView = true
                    
                } label: {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray.opacity(0.8))
                        .overlay {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                                .foregroundStyle(.white)
                                .offset(x: 2, y: -2)
                        }
                }
                .offset(x: 125, y: 275)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
        .navigationTitle("회고 상세")
    }
}

//#Preview {
//    // 미리보기용 카테고리 및 태그 생성
//    let previewCategory = Category(type: .programming)
//    let previewTag = ChildCategory(type: .swift)
//    
//    // 미리보기용 로그 생성
//    let previewLog = LogMainData(
//        id: 1,
//        title: "SwiftUI 학습",
//        keep: "SwiftUI 기본 개념을 이해했다",
//        problem: "복잡한 레이아웃 구성이 어려웠다",
//        tryContent: "더 많은 예제를 통해 연습해보기",
//        creationDate: Date(),
//        category: previewCategory,
//        childCategory: previewTag
//    )
//
//    LogDetailView(logMainData: previewLog)
//}
