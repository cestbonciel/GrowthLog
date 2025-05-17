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
    @Published var allLogs: [LogMainData] = []
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
    @Published var averageWordsPerLog: Double = 0
    @Published var mostActiveDay: String = "-"
    
    
    // 현재 선택된 연도/월
    @Published var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
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
         //loadStatJsonData()
    }
    
    func updateStatisticsForPeriod(period: StatPeriod, year: Int, month: Int) {
        if !allLogs.isEmpty {
            // 선택된 년/월에 맞게 주간/월간 통계 계산
            calculateWeeklyStats(logs: allLogs)
            calculateMonthlyStats(logs: allLogs)
            
            // 선택된 기간에 맞는 키워드와 태그 추출
            let filteredLogs = filterLogsBySelectedMonth(logs: allLogs)
            extractKeywordsAndTags(logs: filteredLogs)
            
            // 평균 단어 수 및 활동적인 요일 계산
            calculateAverageWordsAndActiveDay(logs: filteredLogs)
        }
    }
    
    // 선택한 년/월에 해당하는 로그만 필터링하는 함수
    private func filterLogsBySelectedMonth(logs: [LogMainData]) -> [LogMainData] {
        return logs.filter { log in
            let logYear = Calendar.current.component(.year, from: log.creationDate)
            let logMonth = Calendar.current.component(.month, from: log.creationDate)
            return logYear == selectedYear && logMonth == selectedMonth
        }
     }
    
    
    func loadMonthlyStats(year: Int, month: Int) {
        let calendar = Calendar.current
        selectedYear = year
        selectedMonth = month
        
        // 1) 기준이 될 연·월의 첫째 날
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        guard let baseDate = calendar.date(from: comps) else { return }
        
        // 2) 선택월 기준 최근 3개월 범위 계산
        let months = (0..<3).map { offset -> (start: Date, end: Date) in
            let start = calendar.date(byAdding: .month, value: -offset, to: baseDate)!
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: start)!
            // 다음 달 첫날의 전날을 이달의 말일로
            let end = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
            return (start, end)
        }
        
        // 3) 각 기간별 로그 수 집계
        monthlyStats = months.map { start, end in
            let count = allLogs.filter { log in
                start <= log.creationDate && log.creationDate <= end
            }.count
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 M월"
            formatter.locale = Locale(identifier: "ko_KR")
            let label = formatter.string(from: start)
            return LogStats(period: label, count: count,
                            startDate: start, endDate: end)
        }
        
        // 주간 통계도 업데이트
        calculateWeeklyStats(logs: allLogs)
        
        // 키워드와 태그 통계 업데이트
        let filteredLogs = filterLogsBySelectedMonth(logs: allLogs)
        extractKeywordsAndTags(logs: filteredLogs)
        
        // 평균 단어 수 및 활동적인 요일 계산
        calculateAverageWordsAndActiveDay(logs: filteredLogs)
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
    
    // 특정 년/월에 해당하는 로그만 필터링
    private func filterLogsByYearAndMonth(_ logs: [LogMainData], year: Int, month: Int) -> [LogMainData] {
        let calendar = Calendar.current
        return logs.filter { log in
            let logYear = calendar.component(.year, from: log.creationDate)
            let logMonth = calendar.component(.month, from: log.creationDate)
            return logYear == year && logMonth == month
        }
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
    func loadStatJsonData() {
        guard let url = Bundle.main.url(forResource: "log_data", withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            // Use LogsData instead of LogJson
            let logsData = try decoder.decode(LogsData.self, from: data)
            
            // Process LogEntry directly
            processLogEntries(logsData.logs)
        } catch {
            print("JSON 데이터 로드 오류: \(error)")
        }
    }
    
    
    private func processLogEntries(_ entries: [LogEntry]) {
        // Convert LogEntry to LogMainData
        let mainDataLogs = convertLogEntriesToMainData(entries)
        
        // Process the converted data
        loadData(from: mainDataLogs)
    }
    
    private func convertLogEntriesToMainData(_ entries: [LogEntry]) -> [LogMainData] {
        var result: [LogMainData] = []
        
        for entry in entries {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            guard let date = dateFormatter.date(from: entry.creationDate) else {
                print("날짜 변환 실패: \(entry.creationDate)")
                continue
            }
            
            // Category object creation
            let category = Category(title: entry.categoryType)
            
            // Child category object creation
            let childCategoryType = getChildCategoryType(from: entry.childCategoryType)
            let childCategory = ChildCategory(type: childCategoryType)
            childCategory.category = category
            
            // LogMainData object creation (use try from LogEntry)
            let mainData = LogMainData(
                id: entry.id,
                title: entry.title,
                keep: entry.keep,
                problem: entry.problem,
                tryContent: entry.try, // Map 'try' to 'tryContent'
                creationDate: date,
                category: category,
                childCategory: childCategory
            )
            
            result.append(mainData)
        }
        
        return result
    }
    
    // LogMainData 배열에서 통계 계산
    private func loadData(from logs: [LogMainData]) {
        allLogs = logs
        
        // 현재 년/월로 초기 통계 로드
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        // 월간 통계 계산
        loadMonthlyStats(year: currentYear, month: currentMonth)
    }
    
    
    private func calculateWeeklyStats(logs: [LogMainData]) {
        let calendar = Calendar.current
        
        // 해당 월의 첫째 날 구하기
        var comps = DateComponents()
        comps.year = selectedYear
        comps.month = selectedMonth
        comps.day = 1
        guard let firstDayOfMonth = calendar.date(from: comps) else { return }
        
        // 해당 월의 마지막 날 구하기
        guard let lastDayOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfMonth) else { return }
        
        // 월의 첫째 주의 시작일 (해당 월의 첫째 날이 속한 주의 첫날)
        let firstWeekStartComps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDayOfMonth)
        guard let firstWeekStart = calendar.date(from: firstWeekStartComps) else { return }
        
        // 최대 6주(한 달이 최대 6주에 걸칠 수 있음)
        var weeks: [(start: Date, end: Date)] = []
        var currentWeekStart = firstWeekStart
        
        while currentWeekStart <= lastDayOfMonth {
            let weekEndDate = calendar.date(byAdding: .day, value: 6, to: currentWeekStart)!
            weeks.append((currentWeekStart, weekEndDate))
            currentWeekStart = calendar.date(byAdding: .day, value: 7, to: currentWeekStart)!
        }
        
        // 각 주에 대한 로그 수 계산
        weeklyStats = weeks.map { weekStartDate, weekEndDate in
            let logsInWeek = logs.filter { log in
                // 해당 주가 선택한 월에 속하는 날짜만 포함
                let logInMonth = calendar.component(.month, from: log.creationDate) == selectedMonth &&
                                 calendar.component(.year, from: log.creationDate) == selectedYear
                return weekStartDate <= log.creationDate && log.creationDate <= weekEndDate && logInMonth
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
        
        // 해당 월의 첫째 날
        var comps = DateComponents()
        comps.year = selectedYear
        comps.month = selectedMonth
        comps.day = 1
        guard let baseDate = calendar.date(from: comps) else { return }
        
        // 최근 3개월 범위 계산
        let months = (0..<3).map { monthOffset -> (start: Date, end: Date) in
            let startDate = calendar.date(byAdding: .month, value: -monthOffset, to: baseDate)!
            let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
            return (startDate, endDate)
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
                // 'try' 필드를 'tryContent'로 변환
                tryContent: logData.tryContent ?? "", // 'try'가 optional이면 이 부분을 수정
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
        print("childCategoryType 변환: \(string)")
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
    
    
    // 월간 통계 계산

    
    // 키워드 및 태그 추출
    private func extractKeywordsAndTags(logs: [LogMainData]) {
        print("추출 중인 로그 수: \(logs.count)")  // 디버깅용 로그 추가
        
        if logs.isEmpty {
            // 로그가 없으면 빈 데이터 설정
            weeklyKeywords = []
            monthlyKeywords = []
            weeklyTags = []
            monthlyTags = []
            return
        }
        
        // 이번 달 로그만 필터링하여 태그 통계 생성
        monthlyTags = extractTagsFromLogs(logs)
        monthlyKeywords = extractKeywordsFromLogs(logs)
        
        // 해당 월의 첫 주 기준으로 주간 데이터 필터링 (현재 날짜 대신 선택된 월의 첫 주로 설정)
        let calendar = Calendar.current
        
        // 선택된 월의 첫째 날 구하기
        var comps = DateComponents()
        comps.year = selectedYear
        comps.month = selectedMonth
        comps.day = 1
        guard let firstDayOfMonth = calendar.date(from: comps) else {
            weeklyTags = []
            weeklyKeywords = []
            return
        }
        
        // 첫 주의 시작일과 종료일 계산
        let weekComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDayOfMonth)
        guard let startOfWeek = calendar.date(from: weekComponents) else {
            weeklyTags = []
            weeklyKeywords = []
            return
        }
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
            weeklyTags = []
            weeklyKeywords = []
            return
        }
        
        // 선택된 월에 속하는 로그만 필터링
        let weeklyLogs = logs.filter { log in
            let logInMonth = calendar.component(.month, from: log.creationDate) == selectedMonth &&
                         calendar.component(.year, from: log.creationDate) == selectedYear
            return startOfWeek <= log.creationDate && log.creationDate <= endOfWeek && logInMonth
        }
        
        print("주간 로그 수: \(weeklyLogs.count)")  // 디버깅용 로그 추가
        
        // 주간 태그와 키워드 추출
        weeklyTags = extractTagsFromLogs(weeklyLogs)
        weeklyKeywords = extractKeywordsFromLogs(weeklyLogs)
    }
    
    // 로그에서 키워드 추출
    private func extractKeywordsFromLogs(_ logs: [LogMainData]) -> [KeywordStat] {
        if logs.isEmpty {
            return []
        }
        
        // 키워드 카운트
        var keywordCounts: [String: Int] = [:]
        
        // 각 로그의 텍스트에서 키워드 추출
        for log in logs {
            // keep, problem, tryContent를 모두 결합하여 분석
            let text = [log.keep, log.problem, log.tryContent].joined(separator: " ")
            
            // 텍스트 분석 - 단어 추출 및 불용어 제거
            let words = text.components(separatedBy: .whitespacesAndNewlines)
                .filter { word -> Bool in
                    // 2글자 이상이고 불용어가 아닌 단어만 필터링
                    return word.count >= 2 && !stopWords.contains(word) && !word.isEmpty
                }
            
            // 단어 카운트
            for word in words {
                keywordCounts[word, default: 0] += 1
            }
        }
        
        // 가장 많이 등장한 상위 10개 키워드
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
    
    
    
    // 평균 단어 수 및 활동적인 요일 계산
    private func extractTagsFromLogs(_ logs: [LogMainData]) -> [TagStat] {
        print("태그 추출 대상 로그 수: \(logs.count)")
        if logs.isEmpty {
            return []
        }
        
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
