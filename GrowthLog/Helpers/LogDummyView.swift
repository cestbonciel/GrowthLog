//
//  LogDummyView.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//

import SwiftUI

struct LogDummyView: View {
    @State private var logData: LogData?
    @State private var jsonFilePath: URL? = nil
    @State private var statistics: String = ""
    
    var body: some View {
        VStack {
            Text("Growth Log 데이터 생성기")
                .font(.title)
                .padding()
            
            Button("300개의 로그 데이터 생성하기") {
                generateData()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if let data = logData {
                Text("생성된 데이터: \(data.logs.count)개")
                    .padding()
                
                if let path = jsonFilePath {
                    Text("저장 위치: \(path.path)")
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                List {
                    Section(header: Text("샘플 데이터 (최신 5개)")) {
                        // 날짜를 기준으로 내림차순 정렬하여 최신 항목부터 표시
                        ForEach(data.logs.sorted(by: {
                            $0.getDate()?.compare($1.getDate() ?? Date()) == .orderedDescending
                        }).prefix(5), id: \.id) { entry in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    // 날짜를 스크린샷과 유사한 형식으로 표시
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
                                    
                                    // 카테고리 정보
                                    VStack(alignment: .leading) {
                                        Text("ID: \(entry.id)")
                                            .font(.caption)
                                        Text("\(entry.categoryType) - \(entry.childCategoryType)")
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
                    
                    // 날짜 형식 예시 섹션
                    Section(header: Text("날짜 형식 예시")) {
                        if let firstEntry = data.logs.first {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("원본 저장 형식:")
                                    .font(.headline)
                                Text(firstEntry.creationDate)
                                    .font(.body)
                                    .padding(4)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                                
                                Divider()
                                
                                Text("Date로 파싱 후 다양한 표시 형식:")
                                    .font(.headline)
                                
                                Group {
                                    DateFormatRow(label: "기본 형식", date: firstEntry.getFormattedDate())
                                    DateFormatRow(label: "간단한 날짜", date: firstEntry.getFormattedDate(format: "yyyy.MM.dd"))
                                    DateFormatRow(label: "시간만", date: firstEntry.getFormattedDate(format: "hh:mm:ss a"))
                                    DateFormatRow(label: "한국식", date: firstEntry.getFormattedDate(format: "yyyy년 MM월 dd일 HH시 mm분"))
                                    DateFormatRow(label: "ISO 형식", date: firstEntry.getFormattedDate(format: "yyyy-MM-dd'T'HH:mm:ssZ"))
                                }
                            }
                        }
                    }
                    
                    if !statistics.isEmpty {
                        Section(header: Text("통계 정보")) {
                            Text(statistics)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    func generateData() {
        // 300개의 로그 항목 생성
        let entries = LogDataGenerator.generateLogEntries(count: 300)
        
        // LogData 객체 생성
        logData = LogData(title: "Growth Logs", logs: entries)
        
        // JSON 파일로 저장
        jsonFilePath = LogDataGenerator.saveLogEntriesToJSON(entries: entries, filename: "log_data.json")
        
        // 통계 정보 가져오기
        if let data = logData {
            statistics = LogDataGenerator.getStatistics(entries: data.logs)
        }
    }
}

// 날짜 형식 예시를 보여주는 보조 뷰
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



#Preview {
    LogDummyView()
}
