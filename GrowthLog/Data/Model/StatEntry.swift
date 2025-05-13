//
//  AggregateLogStat.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import Foundation

// Models for period-based statistics(기간별 통계 모델) - 집계 통계 기록, 분석
enum StatPeriod: String, CaseIterable, Identifiable {
    case weekly = "주간"
    case monthly = "월간"
    
    var id: String { rawValue }
}

/// 주간/월간 통계를 위한 샘플 데이터 모델
struct StatEntry: Identifiable {
    let id = UUID()
    let label: String   // ex: "4/28–5/4" 또는 "2025년 4월"
    let count: Int
}

struct DailyLogStat: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}
