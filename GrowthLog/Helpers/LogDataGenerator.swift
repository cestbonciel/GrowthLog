//
//  LogDataGenerator.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//

import Foundation
import SwiftUI


class LogDataGenerator {
    
    // 카테고리 정의
    static let categories = [
        (id: 1, type: "기술", childCategories: ["컴퓨터과학", "네트워크", "보안", "인프라", "소프트웨어 공학"]),
        (id: 2, type: "프로그래밍", childCategories: ["Swift", "C++", "Python", "Java", "JavaScript", "React"]),
        (id: 3, type: "자기계발", childCategories: ["코딩테스트", "면접", "사이드프로젝트"]),
        (id: 4, type: "기타", childCategories: ["IDEA", "디자인", "Product", "UIUX"])
    ]
    
    // 카테고리별 키워드 정의
    let techKeywords = ["알고리즘", "데이터구조", "운영체제", "CI/CD", "클라우드", "서버", "API", "데이터베이스", "백엔드", "프론트엔드", "아키텍처", "마이크로서비스", "테스트", "TDD", "디버깅"]
    let programmingKeywords = ["코드", "함수", "클래스", "변수", "인터페이스", "프로토콜", "버그", "리팩토링", "상속", "라이브러리", "프레임워크", "성능", "최적화", "비동기", "UI", "코드리뷰"]
    let selfDevKeywords = ["학습", "성장", "목표", "계획", "시간관리", "포트폴리오", "커리어", "스킬", "경험", "지식", "문제해결", "팀워크", "소통", "협업", "피드백"]
    let etcKeywords = ["아이디어", "사용자경험", "디자인", "기획", "마케팅", "비즈니스", "브레인스토밍", "혁신", "생산성", "효율", "직관", "컨셉", "리서치", "분석", "인사이트"]
    
    static let categoryToKeywords = [
        "기술": techKeywords,
        "프로그래밍": programmingKeywords,
        "자기계발": selfDevKeywords,
        "기타": etcKeywords
    ]
    
    
    // 추가: 타이틀 생성용 샘플
    static let titleSamples: [String] = [
        "KPT회고",  // 기본값을 배열에 포함
        "오늘의 회고",
        "이번 주 개발 회고",
        "프로젝트 중간 점검",
        "스프린트 회고",
        "개인 성장 리뷰",
        "코딩 학습 회고",
        "문제 해결 회고"
    ]
    
    // 카테고리별 키워드 정의
    static let techKeywords = ["알고리즘", "데이터구조", "운영체제", "CI/CD", "클라우드", "서버", "API", "데이터베이스", "백엔드", "프론트엔드", "아키텍처", "마이크로서비스", "테스트", "TDD", "디버깅"]
    static let programmingKeywords = ["코드", "함수", "클래스", "변수", "인터페이스", "프로토콜", "버그", "리팩토링", "상속", "라이브러리", "프레임워크", "성능", "최적화", "비동기", "UI", "코드리뷰"]
    static let selfDevKeywords = ["학습", "성장", "목표", "계획", "시간관리", "포트폴리오", "커리어", "스킬", "경험", "지식", "문제해결", "팀워크", "소통", "협업", "피드백"]
    static let etcKeywords = ["아이디어", "사용자경험", "디자인", "기획", "마케팅", "비즈니스", "브레인스토밍", "혁신", "생산성", "효율", "직관", "컨셉", "리서치", "분석", "인사이트"]
    
    
    // 랜덤 날짜 생성 함수 (최근 1년 이내)
    static func randomDate() -> Date {
        let now = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now)!
        
        let randomTimeInterval = TimeInterval.random(in: oneYearAgo.timeIntervalSinceNow...now.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: randomTimeInterval)
    }
    
    // 날짜를 원하는 형식의 문자열로 변환
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a" // AM/PM 추가
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    // 날짜를 ID 순서에 맞게 생성하는 함수 (최신 ID가 최신 날짜를 가지도록)
    static func generateDateForID(id: Int, totalCount: Int) -> Date {
        let now = Date()
        guard let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now) else {
            return Date(timeIntervalSinceNow: -365 * 24 * 60 * 60)
        }
        
        let ratio = Double(id) / Double(totalCount)
        
        let timeInterval = oneYearAgo.timeIntervalSinceNow + (ratio * -oneYearAgo.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: timeInterval)
    }
    
    
    // 컨텐츠 생성 함수
    static func generateContent(category: String, childCategory: String, section: String, length: Int = 2) -> String {
        guard let keywords = categoryToKeywords[category] else { return "" }
        var baseKeywords = keywords
        
        // 키워드 추가
        baseKeywords.append(childCategory)
        baseKeywords.append(childCategory)
        baseKeywords.append(category)
        baseKeywords.append(childCategory)
        
        var content = ""
        
        for _ in 0..<length {
            let keywordCount = Int.random(in: 1...2)
            var sentence = ""
            
            // 문장 시작 부분 생성
            if section == "keep" {
                let starters = ["오늘 ", "이번 주에 ", "최근에 ", "프로젝트에서 ", "지난 스프린트에서 ", ""]
                sentence += starters.randomElement() ?? ""
                sentence += ["잘한 점은 ", "좋았던 점은 ", "성공적이었던 것은 ", "만족스러웠던 것은 "].randomElement() ?? ""
            } else if section == "problem" {
                let starters = ["다음에는 ", "앞으로 ", "개선이 필요한 점은 ", "문제점은 ", "어려웠던 점은 ", ""]
                sentence += starters.randomElement() ?? ""
            } else if section == "try" {
                let starters = ["시도해볼 것은 ", "다음에 해볼 것은 ", "개선 방안으로 ", "새롭게 적용할 것은 ", ""]
                sentence += starters.randomElement() ?? ""
            }
            
            // 키워드 추가
            for _ in 0..<keywordCount {
                if let keyword = baseKeywords.randomElement() {
                    sentence += "\(keyword)에 관한 "
                }
            }
            
            // 문장 마무리
            if section == "keep" {
                sentence += ["작업을 잘 수행했다.", "부분이 효율적이었다.", "점이 좋았다.", "부분에서 성과를 냈다."].randomElement() ?? ""
            } else if section == "problem" {
                sentence += ["부분이 어려웠다.", "과정에서 문제가 발생했다.", "부분이 비효율적이었다.", "부분에 시간이 많이 소요되었다."].randomElement() ?? ""
            } else if section == "try" {
                sentence += ["방법을 시도해볼 것이다.", "접근법을 적용해볼 것이다.", "기술을 사용해볼 것이다.", "방식으로 개선해볼 것이다."].randomElement() ?? ""
            }
            
            content += sentence + " "
        }
        
        return content.trimmingCharacters(in: .whitespaces)
    }
    
    // 로그 항목 생성 함수
    static func generateLogEntry(id: Int, totalCount: Int) -> LogEntry {
        guard let categoryTuple = categories.randomElement(),
              let childCategory = categoryTuple.childCategories.randomElement() else {
            // 기본 값 설정 (실패 시 사용할 기본 값)
            return LogEntry(
                id: id,
                creationDate: formatDate(Date()),
                categoryId: 1,
                categoryType: "기술",
                childCategoryType: "소프트웨어 공학",
                title: "KPT회고", // 기본 제목 명시적 설정
                keep: "기본 내용",
                problem: "기본 내용",
                try: "기본 내용"
            )
        }
        
        // ID에 따라 날짜 생성
        let date = generateDateForID(id: id, totalCount: totalCount)
        let dateString = formatDate(date)
        
        // 랜덤 제목 선택 - nil 대신 기본값 사용
        // titleSamples에서 값을 가져오고, nil인 경우 "KPT회고" 기본값 사용
        let title = titleSamples.randomElement() ?? "KPT회고"
        
        // 디버깅을 위해 제목 출력
        if id % 25 == 0 { // 일부 항목만 로그 출력
            print("로그 #\(id) 제목: \(title)")
        }
        
        let keepLength = Int.random(in: 1...2)
        let problemLength = Int.random(in: 1...2)
        let tryLength = Int.random(in: 1...2)
        
        let keep = generateContent(category: categoryTuple.type, childCategory: childCategory, section: "keep", length: keepLength)
        let problem = generateContent(category: categoryTuple.type, childCategory: childCategory, section: "problem", length: problemLength)
        let tryContent = generateContent(category: categoryTuple.type, childCategory: childCategory, section: "try", length: tryLength)
        
        return LogEntry(
            id: id,
            creationDate: dateString,
            categoryId: categoryTuple.id,
            categoryType: categoryTuple.type,
            childCategoryType: childCategory,
            title: title, // 여기서는 항상 문자열 값이 있음 (nil이 아님)
            keep: keep,
            problem: problem,
            try: tryContent
        )
    }
    
    
    // 여러 개의 로그 항목 생성
    static func generateLogEntries(count: Int) -> [LogEntry] {
        var entries: [LogEntry] = []
        
        for i in 1...count {
            let entry = generateLogEntry(id: i, totalCount: count)
            entries.append(entry)
            
            // 주기적으로 로그 출력하여 진행 상황 확인
            if i % 50 == 0 {
                print("로그 생성 진행: \(i)/\(count)")
            }
        }
        
        // 제목 누락 여부 확인
        let withTitle = entries.filter { $0.title != nil }.count
        let withoutTitle = entries.filter { $0.title == nil }.count
        print("제목 있음: \(withTitle), 제목 없음: \(withoutTitle)")
        
        return entries
    }
    
    
    // JSON 파일로 저장
    static func saveLogEntriesToJSON(entries: [LogEntry], filename: String) -> URL? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys] // 키 정렬 추가
        
        // 로그 데이터를 LogsData 구조체로 감싸기
        let logsData = LogsData(logs: entries)
        
        do {
            let jsonData = try encoder.encode(logsData)
            
            // 앱의 Documents 디렉토리에 저장
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("문서 디렉토리를 찾을 수 없습니다.")
                return nil
            }
            
            let fileURL = documentsDirectory.appendingPathComponent(filename)
            
            try jsonData.write(to: fileURL)
            print("JSON 파일 저장 완료: \(fileURL.path)")
            return fileURL
        } catch {
            print("JSON 저장 오류: \(error)")
            return nil
        }
    }
    
    // 날짜 관련 샘플 메서드 추가
    static func printFormattedDateExamples(entries: [LogEntry]) {
        guard let entry = entries.first else { return }
        
        print("원본 날짜 형식: \(entry.creationDate)")
        print("기본 형식(yyyy.MM.dd hh:mm a): \(entry.getFormattedDate())")
        print("간단한 날짜(yyyy.MM.dd): \(entry.getFormattedDate(format: "yyyy.MM.dd"))")
        print("한국식 날짜시간: \(entry.getFormattedDate(format: "yyyy년 MM월 dd일 HH시 mm분"))")
        print("제목: \(entry.getTitle()) (원본: \(entry.title ?? "nil"))")
        
        // 월별 그룹화 예시
        let entriesByMonth = Dictionary(grouping: entries) { entry -> String in
            return entry.getFormattedDate(format: "yyyy.MM")
        }
        
        print("\n월별 로그 수:")
        for (month, monthEntries) in entriesByMonth.sorted(by: { $0.key < $1.key }) {
            print("\(month): \(monthEntries.count)개")
        }
    }
    
    
    // 통계 정보
    static func getStatistics(entries: [LogEntry]) -> String {
        var statsText = ""
        
        // 타이틀 존재 여부 통계
        let entriesWithTitle = entries.filter { $0.title != nil }
        let titlePercentage = Double(entriesWithTitle.count) / Double(entries.count) * 100
        
        statsText += "제목 통계:\n"
        statsText += "- 제목 있음: \(entriesWithTitle.count)개 (\(String(format: "%.1f", titlePercentage))%)\n"
        statsText += "- 제목 없음(기본값 'KPT회고' 사용): \(entries.count - entriesWithTitle.count)개 (\(String(format: "%.1f", 100 - titlePercentage))%)\n\n"
        
        // 카테고리별 분포
        var categoryDistribution: [String: Int] = [:]
        for entry in entries {
            categoryDistribution[entry.categoryType, default: 0] += 1
        }
        
        statsText += "카테고리 분포:\n"
        for (category, count) in categoryDistribution.sorted(by: { $0.key < $1.key }) {
            let percentage = Double(count) / Double(entries.count) * 100
            statsText += "- \(category): \(count)개 (\(String(format: "%.1f", percentage))%)\n"
        }
        
        // 하위 카테고리별 분포
        var childCategoryDistribution: [String: Int] = [:]
        for entry in entries {
            childCategoryDistribution[entry.childCategoryType, default: 0] += 1
        }
        
        statsText += "\n하위 카테고리 분포 (상위 10개):\n"
        let topChildCategories = childCategoryDistribution.sorted(by: { $0.value > $1.value }).prefix(10)
        for (childCategory, count) in topChildCategories {
            let percentage = Double(count) / Double(entries.count) * 100
            statsText += "- \(childCategory): \(count)개 (\(String(format: "%.1f", percentage))%)\n"
        }
        
        // 월별 분포 (새 날짜 형식 사용)
        var monthlyDistribution: [String: Int] = [:]
        
        for entry in entries {
            if let date = entry.getDate() {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM"
                let monthKey = formatter.string(from: date)
                monthlyDistribution[monthKey, default: 0] += 1
            }
        }
        
        statsText += "\n월별 분포:\n"
        for (month, count) in monthlyDistribution.sorted(by: { $0.key < $1.key }) {
            let percentage = Double(count) / Double(entries.count) * 100
            statsText += "- \(month): \(count)개 (\(String(format: "%.1f", percentage))%)\n"
        }
        
        return statsText
    }
}
