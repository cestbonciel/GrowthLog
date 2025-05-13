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

// SwiftUI 뷰 예시
struct LogDummyView: View {
    @State private var logsData: LogsData?
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
            
            if let data = logsData {
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
                                
                                Text("제목:")
                                    .font(.headline)
                                Text("\(firstEntry.getTitle()) (원본: \(firstEntry.title ?? "nil"))")
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
        print("============ Growth Log 데이터 생성 시작 ============")
        
        // 300개의 로그 항목 생성
        let entries = LogDataGenerator.generateLogEntries(count: 300)
        print("로그 항목 300개 생성 완료")
        
        // 샘플 로그 항목 디버그 출력
        if let firstEntry = entries.first, let secondEntry = entries.dropFirst().first {
            print("\n===== 로그 항목 샘플 출력 =====")
            printLogEntry(firstEntry, number: 1)
            printLogEntry(secondEntry, number: 2)
        }
        
        // 날짜 포맷팅 예시 출력
        LogDataGenerator.printFormattedDateExamples(entries: entries)
        
        // LogsData 객체 생성
        logsData = LogsData(logs: entries)
        print("LogsData 객체 생성 완료")
        
        // JSON 파일로 저장
        if let path = LogDataGenerator.saveLogEntriesToJSON(entries: entries, filename: "log_data.json") {
            jsonFilePath = path
            print("JSON 파일 저장 경로: \(path.path)")
        } else {
            print("JSON 파일 저장 실패")
        }
        
        // 통계 정보 가져오기
        if let data = logsData {
            statistics = LogDataGenerator.getStatistics(entries: data.logs)
            print("\n===== 통계 정보 =====")
            print(statistics)
        }
        
        print("============ Growth Log 데이터 생성 완료 ============")
    }

    // 로그 항목을 콘솔에 출력하는 함수 추가
    func printLogEntry(_ entry: LogEntry, number: Int) {
        print("\n----- 로그 항목 #\(number) -----")
        print("ID: \(entry.id)")
        print("날짜: \(entry.creationDate)")
        print("카테고리: \(entry.categoryType) - \(entry.childCategoryType)")
        print("제목: \(entry.getTitle()) (원본: \(entry.title ?? "nil"))")
        print("Keep: \(entry.keep)")
        print("Problem: \(entry.problem)")
        print("Try: \(entry.try)")
        print("--------------------------")
    }

}




#Preview {
    LogDummyView()
}
