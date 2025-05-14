//
//  LogEditorView.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/12/25.
//

import SwiftUI

// MARK: - 개발회고 작성화면
struct LogEditorView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var updateLogData: LogItem?
    @Binding var isShowEditorView: Bool
    
    @State var presentCardModal = false
    
    
    var logMainData: LogItem? = nil
    
    private let contentsLeading: CGFloat = 7
    
    private var stackToPadding: CGFloat {
        logMainData == nil ? 20 : 0
    }
    private var stackBottomPadding: CGFloat {
        logMainData == nil ? 30 : 0
    }
    private var stackHorizontalPadding: CGFloat {
        logMainData == nil ? 20 : 0
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.growthGreen.opacity(0.3))
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Button {
                            presentCardModal = true
                        } label: {
                            Text("카테고리")
                                .font(.callout)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.growthGreen)
                                )
                        }
                        
                        HStack(spacing: 0) {
                            Group {
                                Text("#태그")
                                Text("#태그")
                                Text("#태그")
                            }
                            .font(.footnote)
                            .padding(.horizontal, 5)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                
                TextField("제목 - KPT 회고", text: .constant(""))
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Keep")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 9)
                        
                        TextField("", text: .constant(logMainData?.keep ?? ""), prompt: Text("현재 만족하고 있는 부분"))
                            .font(.footnote)
                            .padding(.leading, contentsLeading)
                        
                        Spacer()
                        
                        Text("Problem")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 9)
                        
                        TextField("", text: .constant(logMainData?.problem ?? ""), prompt: Text("개선이 필요하다고 생각되는 부분"))
                            .font(.footnote)
                            .padding(.leading, contentsLeading)
                        
                        Spacer()
                        
                        Text("Try")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 9)
                        
                        TextField("", text: .constant(""), prompt: Text("개선이 필요하다고 생각되는 부분"))
                            .font(.footnote)
                            .bold()
                            .padding(.leading, contentsLeading)
                        
                        Spacer()
                        Spacer()
                        
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 20)
            
            
        }
        .padding(
            EdgeInsets(top: stackToPadding, leading: stackHorizontalPadding, bottom: stackBottomPadding, trailing: stackHorizontalPadding)
        )
        .navigationTitle(logMainData == nil ? "등록" : "수정")
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
            
            
        }
        .sheet(isPresented: $presentCardModal) {
            CategoryModal()
                .presentationDetents([.fraction(0.7)])
                .presentationDragIndicator(.hidden)
        }
        
    }
}


struct CategoryModal:  View {
    @Environment(\.dismiss) var dismiss
    
    @State var category: CategoryType = .tech
    @State var tags: ChildCategoryType = .codingTest
    
    @State var viewModel = LogEditorViewModel()
    
    var body: some View {
        Picker("category", selection: $category) {
            ForEach(CategoryType.allCases) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.palette)
        
        ForEach(viewModel.categories) { categorys in

            switch category {
            case .tech:
                ForEach(categorys.tags) { tag in
                    Text("\(tag.type)")
                    
                }
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: 100)
            case .programming:
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: 100)
            case .selfDevelopment:
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: 100)
            case .etc:
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: 100)
            }
        
        }
//        Button("dismiss") {
//            dismiss()
//        }
//        
    }
}


#Preview {
    @Previewable @State var isShowEditorView2: Bool = false
    LogEditorView(isShowEditorView: $isShowEditorView2)
}

