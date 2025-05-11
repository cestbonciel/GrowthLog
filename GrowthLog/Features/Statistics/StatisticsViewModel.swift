//
//  StatisticsViewModel.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//

import SwiftUI

final class StatisticsViewModel: ObservableObject {
    @Published var weeklyLogsCount: [Int] = [3, 5, 2, 4, 6, 1, 0]
    @Published var averageWordsPerLog: Double = 132.5
    @Published var mostActiveDay: String = "Thursday"
    
    var weeklyStats: [DailyLogStat] {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return zip(days, weeklyLogsCount).map { DailyLogStat(day: $0, count: $1) }
    }
}
