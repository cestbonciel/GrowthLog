//
//  LogDummyView.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//

import SwiftUI

struct LogDummyView: View {
    @State private var logEntries: [LogEntry] = []
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
            
            if !logEntries.isEmpty {
                Text("생성된 데이터: \(logEntries.count)개")
                    .padding()
                
                if let path = jsonFilePath {
                    Text("저장 위치: \(path.path)")
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                List {
                    Section(header: Text("샘플 데이터 (처음 5개)")) {
                        ForEach(logEntries.prefix(5), id: \.id) { entry in
                            VStack(alignment: .leading) {
                                Text("ID: \(entry.id), Category: \(entry.categoryType)-\(entry.childCategoryType)")
                                    .font(.headline)
                                Text("Keep: \(entry.keep)")
                                Text("Problem: \(entry.problem)")
                                Text("Try: \(entry.try)")
                            }
                            .padding(.vertical, 5)
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
        logEntries = LogDataGenerator.generateLogEntries(count: 300)
        
        // JSON 파일로 저장
        jsonFilePath = LogDataGenerator.saveLogEntriesToJSON(entries: logEntries, filename: "log_data.json")
        
        // 통계 정보 가져오기
        statistics = LogDataGenerator.getStatistics(entries: logEntries)
    }
}

#Preview {
    LogDummyView()
}
