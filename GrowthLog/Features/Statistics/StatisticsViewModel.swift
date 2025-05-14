//
//  StatisticsViewModel.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//

import SwiftUI
import SwiftData
import Charts

/// 주, 월 통계 뷰 모델
/// TODO: @EnvironmentObject -> 데이터 공유, 생성자 공유, published 생성자로..
final class StatisticsViewModel: ObservableObject {
    // 표시할 통계 데이터
    @Published var weeklyStats: [LogStats] = []
    @Published var monthlyStats: [LogStats] = []
    
    // 키워드 통계
    @Published var weeklyKeywords: [KeywordStat] = []
    @Published var monthlyKeywords: [KeywordStat] = []
    
    // 태그 통계
    @Published var weeklyTags: [TagStat] = []
    @Published var monthlyTags: [TagStat] = []
    
    // 일반 통계
    @Published var averageWordsPerLog: Double = 132.5
    @Published var mostActiveDay: String = "Thursday"
    
    // 불용어 목록 - 키워드 추출 시 제외할 단어들
    private let stopWords = ["관한", "부분", "작업", "잘", "수행", "부분에서", "성과", "점이", "좋았다", "부분이", "효율적", "과정에서",
                             "문제", "발생", "부분에", "시간이", "많이", "소요", "부분이", "비효율적", "방법을", "시도", "방식으로",
                             "개선", "접근법을", "적용", "기술을", "사용", "했다", "이었다", "되었다"]
    
    // 색상 팔레트
    private let colorPalette: [Color] = [
        .blue, .red, .green, .orange, .purple, .teal, .pink, .indigo,
        .cyan, .yellow, .mint, .brown, .gray
    ]
    
    init() {
        // 초기화 시 샘플 데이터 로드
        //loadSampleData()
        
        // 실제 앱에서는 아래와 같이 데이터를 로드합니다
         loadJsonData()
    }
    
    // 샘플 데이터 로드 (개발 테스트용)
    private func loadSampleData() {
        // 샘플 주간 데이터
        weeklyStats = [
            LogStats(period: "4/28–5/4", count: 5, startDate: Date(), endDate: Date()),
            LogStats(period: "5/5–5/11", count: 8, startDate: Date(), endDate: Date()),
            LogStats(period: "5/12–5/18", count: 3, startDate: Date(), endDate: Date())
        ]
        
        // 샘플 월간 데이터
        monthlyStats = [
            LogStats(period: "2025년 3월", count: 15, startDate: Date(), endDate: Date()),
            LogStats(period: "2025년 4월", count: 24, startDate: Date(), endDate: Date()),
            LogStats(period: "2025년 5월", count: 6, startDate: Date(), endDate: Date())
        ]
        
        // 샘플 키워드 데이터 - LogDataGenerator의 카테고리별 키워드 활용
        let keywords = LogDataGenerator.techKeywords.prefix(5).map { String($0) }
        let counts = [12, 8, 5, 3, 2]
        let total = counts.reduce(0, +)
        
        weeklyKeywords = (0..<min(keywords.count, counts.count)).map { i in
            let percentage = Double(counts[i]) / Double(total) * 100
            return KeywordStat(
                keyword: keywords[i],
                count: counts[i],
                percentage: percentage,
                color: colorPalette[i % colorPalette.count]
            )
        }
        monthlyKeywords = weeklyKeywords
        
        // 샘플 태그 데이터 - LogDataGenerator의 카테고리 정의 활용
        let allChildCategories = LogDataGenerator.categories.flatMap { $0.childCategories }
        let tags = Array(allChildCategories.prefix(5))
        let tagCounts = [15, 10, 7, 5, 3]
        let tagTotal = tagCounts.reduce(0, +)
        
        weeklyTags = (0..<min(tags.count, tagCounts.count)).map { i in
            let percentage = Double(tagCounts[i]) / Double(tagTotal) * 100
            return TagStat(
                tag: tags[i],
                count: tagCounts[i],
                percentage: percentage,
                color: colorPalette[i % colorPalette.count]
            )
        }
        monthlyTags = weeklyTags
    }
    
    // JSON 파일 로드 및 분석
    func loadJsonData() {
        // 여기서 log_data.json 파일을 로드하고 분석합니다
        guard let url = Bundle.main.url(forResource: "log_data", withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let logJson = try decoder.decode(LogJson.self, from: data)
            
            // 데이터 분석 및 통계 처리
            processLogData(logJson.logs)
        } catch {
            print("JSON 데이터 로드 오류: \(error)")
        }
    }
    
    // LogMainData 배열에서 통계 계산
    func loadData(from logs: [LogMainData]) {
        // 주간/월간 통계 계산
        calculateWeeklyStats(logs: logs)
        calculateMonthlyStats(logs: logs)
        
        // 키워드 및 태그 분석
        extractKeywordsAndTags(logs: logs)
        
        // 평균 단어 수 및 활동적인 요일 계산
        calculateAverageWordsAndActiveDay(logs: logs)
    }
    
    // LogData 배열을 처리하여 통계 계산
    private func processLogData(_ logs: [LogData]) {
        // LogData → LogMainData 변환
        let mainDataLogs = convertLogDataToMainData(logs)
        
        // 변환된 데이터로 통계 처리
        loadData(from: mainDataLogs)
    }
    
    // LogData를 LogMainData로 변환
    private func convertLogDataToMainData(_ logs: [LogData]) -> [LogMainData] {
        var result: [LogMainData] = []
        
        for logData in logs {
            // 날짜 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            guard let date = dateFormatter.date(from: logData.creationDate) else {
                print("날짜 변환 실패: \(logData.creationDate)")
                continue
            }
            
            // 카테고리 객체 생성
            let category = Category(title: logData.categoryType)
            
            // 하위 카테고리 객체 생성
            let childCategoryType = getChildCategoryType(from: logData.childCategoryType)
            let childCategory = ChildCategory(type: childCategoryType)
            childCategory.category = category
            
            // LogMainData 객체 생성
            let mainData = LogMainData(
                id: logData.id,
                title: logData.title,
                keep: logData.keep,
                problem: logData.problem,
                tryContent: logData.tryContent,
                creationDate: date,
                category: category,
                childCategory: childCategory
            )
            
            result.append(mainData)
        }
        
        return result
    }
    
    // 문자열에서 ChildCategoryType 열거형으로 변환
    private func getChildCategoryType(from string: String) -> ChildCategoryType {
        switch string {
        case "컴퓨터과학": return .computerScience
        case "네트워크": return .network
        case "보안": return .security
        case "인프라": return .infrastructure
        case "소프트웨어 공학": return .softwareEngineering
        case "Swift": return .swift
        case "C++": return .cpp
        case "Python": return .python
        case "Java": return .java
        case "JavaScript": return .javascript
        case "React": return .react
        case "코딩테스트": return .codingTest
        case "면접": return .interview
        case "사이드프로젝트": return .sideProject
        case "IDEA": return .idea
        case "디자인": return .design
        case "Product": return .product
        case "UIUX": return .uiux
        default:
            print("알 수 없는 하위 카테고리: \(string)")
            return .idea // 기본값
        }
    }
    
    // 주간 통계 계산
    private func calculateWeeklyStats(logs: [LogMainData]) {
        let calendar = Calendar.current
        let now = Date()
        
        // 최근 3주 범위 계산
        let weeks = (0..<3).map { weekOffset -> (start: Date, end: Date) in
            let startOfCurrentWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let weekStartDate = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: startOfCurrentWeek)!
            let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate)!
            return (weekStartDate, weekEndDate)
        }
        
        // 각 주에 대한 로그 수 계산
        weeklyStats = weeks.map { weekStartDate, weekEndDate in
            let logsInWeek = logs.filter { log in
                return weekStartDate <= log.creationDate && log.creationDate <= weekEndDate
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d"
            let weekLabel = "\(formatter.string(from: weekStartDate))–\(formatter.string(from: weekEndDate))"
            
            return LogStats(
                period: weekLabel,
                count: logsInWeek.count,
                startDate: weekStartDate,
                endDate: weekEndDate
            )
        }
    }
    
    // 월간 통계 계산
    private func calculateMonthlyStats(logs: [LogMainData]) {
        let calendar = Calendar.current
        let now = Date()
        
        // 최근 3개월 범위 계산
        let months = (0..<3).map { monthOffset -> (start: Date, end: Date) in
            let startOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let monthStartDate = calendar.date(byAdding: .month, value: -monthOffset, to: startOfCurrentMonth)!
            let monthEndDate = calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .month, value: 1, to: monthStartDate)!)!
            return (monthStartDate, monthEndDate)
        }
        
        // 각 월에 대한 로그 수 계산
        monthlyStats = months.map { monthStartDate, monthEndDate in
            let logsInMonth = logs.filter { log in
                return monthStartDate <= log.creationDate && log.creationDate <= monthEndDate
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 M월"
            formatter.locale = Locale(identifier: "ko_KR")
            let monthLabel = formatter.string(from: monthStartDate)
            
            return LogStats(
                period: monthLabel,
                count: logsInMonth.count,
                startDate: monthStartDate,
                endDate: monthEndDate
            )
        }
    }
    
    // 키워드 및 태그 추출
    private func extractKeywordsAndTags(logs: [LogMainData]) {
        // 주간/월간 로그 필터링
        let calendar = Calendar.current
        let now = Date()
        
        // 최근 주 계산
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        let weeklyLogs = logs.filter { $0.creationDate >= startOfWeek && $0.creationDate <= endOfWeek }
        
        // 최근 월 계산
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .month, value: 1, to: startOfMonth)!)!
        let monthlyLogs = logs.filter { $0.creationDate >= startOfMonth && $0.creationDate <= endOfMonth }
        
        // 주간 키워드 추출
        weeklyKeywords = extractKeywordsFromLogs(weeklyLogs)
        
        // 월간 키워드 추출
        monthlyKeywords = extractKeywordsFromLogs(monthlyLogs)
        
        // 주간 태그 추출
        weeklyTags = extractTagsFromLogs(weeklyLogs)
        
        // 월간 태그 추출
        monthlyTags = extractTagsFromLogs(monthlyLogs)
    }
    
    // 로그에서 키워드 추출
    private func extractKeywordsFromLogs(_ logs: [LogMainData]) -> [KeywordStat] {
        // 카테고리별 키워드 정의에서 모든 키워드 가져오기
        let allKeywords = Set(
            LogDataGenerator.techKeywords +
            LogDataGenerator.programmingKeywords +
            LogDataGenerator.selfDevKeywords +
            LogDataGenerator.etcKeywords
        )
        
        // 키워드 카운트
        var keywordCounts: [String: Int] = [:]
        
        // 각 로그의 텍스트에서 키워드 추출
        for log in logs {
            let text = [log.keep, log.problem, log.tryContent].joined(separator: " ")
            
            // 모든 키워드에 대해 검사
            for keyword in allKeywords {
                // 키워드가 텍스트에 있는지 확인 (대소문자 구분 없이)
                let occurrences = text.lowercased().components(separatedBy: keyword.lowercased()).count - 1
                if occurrences > 0 {
                    keywordCounts[keyword, default: 0] += occurrences
                }
            }
            
            // 텍스트에서 직접 단어 추출
            let words = text.components(separatedBy: .whitespacesAndNewlines)
                .filter { !$0.isEmpty && $0.count >= 2 && !stopWords.contains($0) }
            
            for word in words {
                if !allKeywords.contains(word) && word.count >= 2 {
                    keywordCounts[word, default: 0] += 1
                }
            }
        }
        
        // 가장 많이 등장한 키워드 상위 10개
        let topKeywords = keywordCounts.sorted { $0.value > $1.value }.prefix(10)
        let total = topKeywords.reduce(0) { $0 + $1.value }
        
        // KeywordStat 객체 생성
        return topKeywords.enumerated().map { index, item in
            let percentage = total > 0 ? Double(item.value) / Double(total) * 100 : 0
            return KeywordStat(
                keyword: item.key,
                count: item.value,
                percentage: percentage,
                color: colorPalette[index % colorPalette.count]
            )
        }
    }
    
    // 로그에서 태그 추출
    private func extractTagsFromLogs(_ logs: [LogMainData]) -> [TagStat] {
        // 태그 카운트
        var tagCounts: [String: Int] = [:]
        
        // 각 로그의 하위 카테고리(태그) 집계
        for log in logs {
            if let childCategory = log.childCategory {
                let tagName = childCategory.name
                tagCounts[tagName, default: 0] += 1
            }
        }
        
        // 가장 많이 사용된 태그 상위 10개
        let topTags = tagCounts.sorted { $0.value > $1.value }.prefix(10)
        let total = topTags.reduce(0) { $0 + $1.value }
        
        // TagStat 객체 생성
        return topTags.enumerated().map { index, item in
            let percentage = total > 0 ? Double(item.value) / Double(total) * 100 : 0
            return TagStat(
                tag: item.key,
                count: item.value,
                percentage: percentage,
                color: colorPalette[index % colorPalette.count]
            )
        }
    }
    
    // 평균 단어 수 및 활동적인 요일 계산
    private func calculateAverageWordsAndActiveDay(logs: [LogMainData]) {
        // 평균 단어 수 계산
        if !logs.isEmpty {
            let totalWords = logs.reduce(0) { result, log in
                let allText = [log.keep, log.problem, log.tryContent].joined(separator: " ")
                let wordCount = allText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
                return result + wordCount
            }
            
            averageWordsPerLog = Double(totalWords) / Double(logs.count)
        } else {
            averageWordsPerLog = 0
        }
        
        // 가장 활동적인 요일 계산
        var dayCount: [Int: Int] = [:] // [요일: 개수]
        
        for log in logs {
            let weekday = Calendar.current.component(.weekday, from: log.creationDate)
            dayCount[weekday, default: 0] += 1
        }
        
        if let (mostActiveWeekday, _) = dayCount.max(by: { $0.value < $1.value }) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            
            // 옵셔널 처리 추가
            if let weekdaySymbols = formatter.weekdaySymbols {
                let index = (mostActiveWeekday - 1) % 7 // 0 = 일요일, 1 = 월요일, ...
                
                if index < weekdaySymbols.count {
                    mostActiveDay = weekdaySymbols[index]
                } else {
                    mostActiveDay = "알 수 없음"
                }
            } else {
                mostActiveDay = "알 수 없음"
            }
        } else {
            mostActiveDay = "없음"
        }
    }
    
    // 특정 기간의 로그 필터링 메서드
    private func filterLogsByPeriod(logs: [LogMainData], from startDate: Date, to endDate: Date) -> [LogMainData] {
        return logs.filter { log in
            return startDate <= log.creationDate && log.creationDate <= endDate
        }
    }
    
    // SwiftData에서 로그 데이터 로드
    func loadLogsFromSwiftData(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<LogMainData>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)])
        
        do {
            let logs = try modelContext.fetch(descriptor)
            loadData(from: logs)
        } catch {
            print("SwiftData에서 로그 로드 실패: \(error)")
        }
    }
}
