//
//  LogDummyView.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//

import SwiftUI

struct DateFormatRow: View {
    let label: String
    let date: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
            
            Text(date)
                .font(.body)
                .padding(4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(.vertical, 2)
    }
}

struct LogDummyView: View {
    @State private var logsData: [LogEntry] = []
    @State private var statistics: String = ""
    
    var body: some View {
        VStack {
            Text("Growth Log 데이터 표시")
                .font(.title)
                .padding()
            
            if !logsData.isEmpty {
                Text("데이터 항목 수: \(logsData.count)개")
                    .padding()
                
                List {
                    Section(header: Text("샘플 데이터 (최신 5개)")) {
                        // 날짜를 기준으로 내림차순 정렬하여 최신 항목부터 표시
                        ForEach(logsData.sorted(by: {
                            $0.getDate()?.compare($1.getDate() ?? Date()) == .orderedDescending
                        }).prefix(5), id: \.id) { entry in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    // 날짜 표시
                                    VStack(spacing: 2) {
                                        Text(entry.getFormattedDate(format: "yyyy.MM.dd"))
                                            .font(.system(size: 16, weight: .bold))
                                        Text(entry.getFormattedDate(format: "hh:mm a"))
                                            .font(.system(size: 14))
                                    }
                                    .frame(width: 120)
                                    .padding(8)
                                    .background(Color.mint.opacity(0.2))
                                    .cornerRadius(8)
                                    
                                    // 카테고리 정보와 제목
                                    VStack(alignment: .leading) {
                                        Text("ID: \(entry.id)")
                                            .font(.caption)
                                        Text("\(entry.categoryType) - \(entry.childCategoryType)")
                                            .font(.subheadline)
                                        Text("제목: \(entry.getTitle())")
                                            .font(.headline)
                                    }
                                }
                                
                                // 로그 내용
                                Group {
                                    Text("Keep:").font(.headline) + Text(" \(entry.keep)")
                                    Text("Problem:").font(.headline) + Text(" \(entry.problem)")
                                    Text("Try:").font(.headline) + Text(" \(entry.try)")
                                }
                                .font(.body)
                                .lineLimit(2)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    if !statistics.isEmpty {
                        Section(header: Text("통계 정보")) {
                            Text(statistics)
                        }
                    }
                }
            } else {
                Text("데이터가 없습니다.")
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            loadSampleData()
        }
    }
    
    // 샘플 데이터를 로드하는 함수 (JSON 생성 대신)
    func loadSampleData() {
        // 여기서는 하드코딩된 샘플 데이터를 사용
        // 실제 앱에서는 정적 JSON 파일 또는 API 등에서 로드
        logsData = [
            LogEntry(
                id: 1,
                creationDate: "2024-05-15 08:27 AM",
                categoryId: 4,
                categoryType: "기타",
                childCategoryType: "소프트웨어 공학",
                title: "오늘의 회고",
                keep: "만족스러웠던 것은 협업에 관한 작업을 잘 수행했다.",
                problem: "다음에는 아키텍처에 관한 부분이 비효율적이었다.",
                try: "새롭게 적용할 것은 알고리즘에 관한 기술을 사용해볼 것이다."
            ),
            LogEntry(
                id: 2,
                creationDate: "2024-05-16 01:39 PM",
                categoryId: 3,
                categoryType: "자기계발",
                childCategoryType: "코딩테스트",
                title: nil,
                keep: "성공적이었던 것은 문제해결에 관한 부분에서 성과를 냈다.",
                problem: "개선이 필요한 점은 학습에 관한 부분이 어려웠다.",
                try: "다음에 해볼 것은 경험에 관한 기술을 사용해볼 것이다."
            )
        ]
        
        // 통계 정보 계산
        statistics = LogDataGenerator.getStatistics(entries: logsData)
    }
}


#Preview {
    LogDummyView()
}
