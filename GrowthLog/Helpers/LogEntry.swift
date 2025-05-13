//
//  LogEntry.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//
import Foundation

// 전체 JSON 구조 정의
struct LogData: Codable {
    let title: String
    let logs: [LogEntry]
}

// 데이터 구조 정의
struct LogEntry: Codable {
    let id: Int
    let creationDate: String  // ISO8601 형식의 날짜
    let categoryId: Int
    let categoryType: String
    let childCategoryType: String
    let keep: String
    let problem: String
    let `try`: String  // Swift에서 예약어를 속성명으로 사용할 때는 백틱으로 감싸야 함
    
    // 필요시 Date 객체로 변환하는 메서드
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: creationDate)
    }
    
    // 다른 형식으로 포맷팅하는 메서드
    func getFormattedDate(format: String = "yyyy.MM.dd hh:mm a") -> String {
        guard let date = getDate() else { return creationDate }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = format
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date)
    }
}

// 카테고리 정의
let categories = [
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

let categoryToKeywords = [
    "기술": techKeywords,
    "프로그래밍": programmingKeywords,
    "자기계발": selfDevKeywords,
    "기타": etcKeywords
]
