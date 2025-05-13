//
//  StatisticsViewModel.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//

import SwiftUI

/// 주, 월 통계 뷰 모델
final class StatisticsViewModel: ObservableObject {
    // 주간 로그 카운트 (Mon…Sun)
    @Published var weeklyLogsCount: [Int] = [3, 5, 2, 4, 6, 1, 0]
    
    // 평균 단어 수, 가장 활동적인 요일
    @Published var averageWordsPerLog: Double = 132.5
    @Published var mostActiveDay: String = "Thursday"
    
    // 차트용 모델 변환
    @Published var weeklyStats: [StatEntry] = [
        StatEntry(label: "4/28–5/4", count: 5),
        StatEntry(label: "5/5–5/11", count: 8),
        StatEntry(label: "5/12–5/18", count: 3),
    ]
    
    @Published var monthlyStats: [StatEntry] = [
        StatEntry(label: "2025년 3월", count: 15),
        StatEntry(label: "2025년 4월", count: 24),
        StatEntry(label: "2025년 5월", count: 6),
    ]
}
