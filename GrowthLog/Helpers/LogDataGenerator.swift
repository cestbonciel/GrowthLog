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
    static let techKeywords = ["알고리즘", "데이터구조", "운영체제", "CI/CD", "클라우드", "서버", "API", "데이터베이스", "백엔드", "프론트엔드", "아키텍처", "마이크로서비스", "테스트", "TDD", "디버깅"]
    static let programmingKeywords = ["코드", "함수", "클래스", "변수", "인터페이스", "프로토콜", "버그", "리팩토링", "상속", "라이브러리", "프레임워크", "성능", "최적화", "비동기", "UI", "코드리뷰"]
    static let selfDevKeywords = ["학습", "성장", "목표", "계획", "시간관리", "포트폴리오", "커리어", "스킬", "경험", "지식", "문제해결", "팀워크", "소통", "협업", "피드백"]
    static let etcKeywords = ["아이디어", "사용자경험", "디자인", "기획", "마케팅", "비즈니스", "브레인스토밍", "혁신", "생산성", "효율", "직관", "컨셉", "리서치", "분석", "인사이트"]
    
    static let categoryToKeywords = [
        "기술": techKeywords,
        "프로그래밍": programmingKeywords,
        "자기계발": selfDevKeywords,
        "기타": etcKeywords
    ]
    
    // 통계 정보 메서드만 남김
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
        
        // 월별 분포
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
