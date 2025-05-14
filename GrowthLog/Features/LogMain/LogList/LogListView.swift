//
//  LogListView.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/12/25.
//

import SwiftUI

// MARK: Dummy Data - 원래 Data > Model
struct LogItem: Identifiable, Hashable {
    let id = UUID()
    var title: String?
    var category: Category
    var keep: String
    var problem: String
    var tryContents: String
    let date: Date
    
    var URL: URL?
    
    // 날짜 포맷
    var formattedDate: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        return df.string(from: date)
    }
    
    // 시간 포맷
    var formattedtime: String {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        return df.string(from: date)
    }
}

struct LogListView: View {
    @State private var isShowSampleCell = false
    @State var isShowEditorView = false
    
    static let categorys: [Category] = [
        Category(type: .tech, tags: [ChildCategory(type: .computerScience), ChildCategory(type: .network), ChildCategory(type: .security)]),
        Category(type: .programming, tags: [ChildCategory(type: .swift), ChildCategory(type: .cpp), ChildCategory(type: .python)]),
        Category(type: .programming, tags: [ChildCategory(type: .swift), ChildCategory(type: .java), ChildCategory(type: .react)]),
        Category(type: .selfDevelopment, tags: [ChildCategory(type: .codingTest), ChildCategory(type: .interview), ChildCategory(type: .sideProject)]),
        Category(type: .etc, tags: [ChildCategory(type: .computerScience), ChildCategory(type: .product), ChildCategory(type: .uiux)])
    ]
    
    private let items: [LogItem] = [
        .init(title: "SwiftUI 학습",       category: LogListView.categorys[0], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-1*24*3600)),
        .init(title: nil,                 category: LogListView.categorys[2], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-1*24*3600)),
        .init(title: "CoreData CRUD 구현", category: LogListView.categorys[1], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-2*24*3600)),
        .init(title: "MVVM 구조 적용",      category: LogListView.categorys[3], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-3*24*3600)),
        .init(title: "UI 리팩토링",         category: LogListView.categorys[4], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-4*24*3600))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if items.isEmpty {
                    Text("아직 작성한 회고가 없습니다.")
                } else {
                    ZStack {
                        List {
                            ForEach(items) { item in
                                ZStack(alignment: .leading) {
                                    LogListCell(item: item)
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
                        }
                        .listStyle(.plain)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
                        
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                NavigationLink(destination: LogEditorView(isShowEditorView: $isShowEditorView, logMainData: nil)) {
                                    RoundedRectangle(cornerRadius: 10)
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
                            }
                            .padding()
                        }
                        .padding()
                        
                    }
                }
            }
            .navigationTitle("GrowthLog")
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
}

#Preview {
    LogListView()
}

