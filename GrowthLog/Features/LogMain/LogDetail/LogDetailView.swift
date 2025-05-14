//
//  LogDetailView.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/12/25.
//

import SwiftUI

// MARK: - 작성화면 디테일뷰(조회, 삭제, 수정)
struct LogDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowEditorView = false
    
    var logMainData: LogItem
    
    private let contentsLeading: CGFloat = 7
    
    
    var body: some View {
        ZStack {
            if isShowEditorView {
                LogEditorView(isShowEditorView: $isShowEditorView, logMainData: logMainData)
            } else  {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.growthGreen.opacity(0.3))
                    .frame(maxWidth: .infinity)
                
                VStack(spacing: 0) {
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(logMainData.category.title)
                                .font(.callout)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.growthGreen)
                                )
                            HStack(spacing: 0) {
                                ForEach(logMainData.category.tags) {
                                    Text("#\($0.name)")
                                        .font(.footnote)
                                        .padding(.horizontal, 5)
                                }
                            }
                        }
                        .padding(.horizontal , 5)
                        
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
                            
                            Text(logMainData.tryContents)
                                .font(.footnote)
                                .bold()
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
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 45, height: 45)
                        .foregroundColor(Color.growthGreen)
                        .overlay {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundStyle(.white)
                                .offset(x: 2, y: -1)
                        }
                }
                .offset(x: 130, y: 270)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
        .navigationTitle("회고 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    LogDetailView(logMainData: LogItem(title: "SwiftUI 학습", category: LogListView.categorys[0], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-1*24*3600)))
}
