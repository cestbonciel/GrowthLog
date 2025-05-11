//
//  AggregateLogStat.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import Foundation

// Models for period-based statistics(기간별 통계 모델) - 집계 통계 기록, 분석

struct DailyLogStat: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}
