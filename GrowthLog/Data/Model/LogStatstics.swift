//
//  LogStatstics.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/14/25.
//
import SwiftUI
import Foundation

// 태그/키워드 탭 선택을 위한 열거형
enum StatTabType: String, CaseIterable, Identifiable {
    case tags = "태그"
    case keywords = "키워드"
    
    var id: String { rawValue }
}

// 기간 유형
enum StatPeriod: String, CaseIterable, Identifiable {
    case weekly = "주간"
    case monthly = "월간"
    
    var id: String { rawValue }
}

// 태그 통계 데이터 모델
struct TagStat: Identifiable {
    let id = UUID()
    let tag: String
    let count: Int
    let percentage: Double
    let color: Color
}

// 키워드 통계 데이터 모델
struct KeywordStat: Identifiable {
    let id = UUID()
    let keyword: String
    let count: Int
    let percentage: Double
    let color: Color
}

// LogStats 모델 수정
struct LogStats: Identifiable {
    let id = UUID()
    let period: String
    let count: Int
    let startDate: Date
    let endDate: Date
}
