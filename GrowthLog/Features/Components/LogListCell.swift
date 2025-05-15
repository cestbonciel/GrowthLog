//
//  LogListCell.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/13/25.
//

import SwiftUI
import SwiftData

struct LogListCell: View {
    let logMainData: LogMainData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.growthGreen.opacity(0.3))
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(logMainData.childCategory?.category?.title ?? "카테고리 없음")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(.growthGreen)
                            )
                        
                        Text("#\(logMainData.childCategory?.name ?? "")")
                            .font(.caption)
                            .padding(.horizontal, 5)
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(logMainData.formattedDate)
                        
                        Text(logMainData.formattedtime)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                }
                .padding()
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                
                HStack {
                    Text(logMainData.title ?? logMainData.keep)
                        .font(.subheadline)
                        .padding()
                        .padding(.horizontal, 5)
                    
                    Spacer()
                }
            }
        }
    }
}

//#Preview {
//    // SwiftData 미리보기 환경 설정
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: LogMainData.self,/* Category.self, ChildCategory.self,*/ configurations: config)
//    
//    // 더미 ModelContext 생성
//    let context = container.mainContext
//    
//    // 미리보기용 카테고리 및 태그 생성
//    let previewCategory = Category(type: .programming)
//    let previewTag = ChildCategory(type: .swift)
//    previewTag.category = previewCategory
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
//    return LogListCell(logMainData: previewLog)
//}
