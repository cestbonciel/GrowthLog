//
//  LogListCell.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/13/25.
//

import SwiftUI

struct LogListCell: View {
    let item: LogItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.growthGreen.opacity(0.3))
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.category.title)
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(.growthGreen)
                            )
                        HStack(spacing: 0) {
                            ForEach(item.category.tags) {
                                Text("#\($0.name)")
                                    .font(.caption)
                                    .padding(.horizontal, 5)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(item.formattedDate)
                        
                        Text(item.formattedtime)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                }
                .padding()
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                
                HStack {
                    Text(item.title ?? item.keep)
                        .font(.subheadline)
                        .padding()
                        .padding(.horizontal, 5)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    let categorys: Category = Category(type: .tech, tags: [ChildCategory(type: .computerScience), ChildCategory(type: .network), ChildCategory(type: .security)])
    
    LogListCell(item: LogItem(title: "SwiftUI 학습", category: categorys, keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-1*24*3600)))
    LogListCell(item: LogItem(title: nil,           category: categorys, keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-1*24*3600)))
}

