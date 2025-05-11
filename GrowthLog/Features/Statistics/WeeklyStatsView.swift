//
//  WeeklyStatsView.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import SwiftUI
import Charts

// MARK: 주, 월별 통계 및 분석 UI

struct WeeklyStatsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("주간 작성 통계")
                .font(.title2)
                .padding(.bottom, 10)

            Chart(viewModel.weeklyStats) { stat in
                BarMark(
                    x: .value("요일", stat.day),
                    y: .value("작성 수", stat.count)
                )
                .foregroundStyle(Color.accentColor)
            }
            .frame(height: 200)
            .padding(.horizontal)

            HStack(alignment: .center, spacing: 16) {
                Text("가장 활발한 요일: \(viewModel.mostActiveDay)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("평균 단어 수: \(Int(viewModel.averageWordsPerLog))단어")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
        }
        .padding()
    }
}


#Preview {
    WeeklyStatsView()
}
