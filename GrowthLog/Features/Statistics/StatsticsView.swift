//
//  StatsticsView.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import SwiftUI
import Charts

// MARK: 주, 월별 통계 및 분석 UI

struct StatsticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedPeriod: StatPeriod = .weekly
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                   Text("회고 통계")
                       .font(.title2).bold()
                   
                   // 평균 단어 수, 최다 활동 요일
                   HStack(spacing: 24) {
                       VStack(alignment: .leading) {
                           Text("평균 단어 수")
                               .font(.caption)
                               .foregroundColor(.secondary)
                           Text("\(Int(viewModel.averageWordsPerLog))단어")
                               .font(.headline)
                       }
                       VStack(alignment: .leading) {
                           Text("최다 활동 요일")
                               .font(.caption)
                               .foregroundColor(.secondary)
                           Text(viewModel.mostActiveDay)
                               .font(.headline)
                       }
                   }
                   
                   // 주/월 선택 세그먼트
                   Picker("기간", selection: $selectedPeriod) {
                       ForEach(StatPeriod.allCases) { period in
                           Text(period.rawValue).tag(period)
                       }
                   }
                   .pickerStyle(.segmented)
                   
                   // 차트
                   Group {
                       if selectedPeriod == .weekly {
                           WeeklyChart(data: viewModel.weeklyStats)
                       } else {
                           MonthlyChart(data: viewModel.monthlyStats)
                       }
                   }
                   .frame(height: 250)
                   
                   Spacer()
               }
               .padding(20)
               .background(Color(UIColor.systemGray6))
               .navigationTitle("통계")
       
    }
}

private extension StatsticsView {
    /// 주간 통계 차트
    struct WeeklyChart: View {
        let data: [StatEntry]
        var body: some View {
            Chart(data) { entry in
                BarMark(
                    x: .value("주", entry.label),
                    y: .value("회고 수", entry.count)
                )
                .annotation(position: .top) {
                    Text("\(entry.count)")
                        .font(.caption2)
                }
            }
            .chartXAxisLabel("주 단위")
            .chartYAxisLabel("회고 수")
        }
    }

    /// 월간 통계 차트
    struct MonthlyChart: View {
        let data: [StatEntry]
        var body: some View {
            Chart(data) { entry in
                LineMark(
                    x: .value("월", entry.label),
                    y: .value("회고 수", entry.count)
                )
                PointMark(
                    x: .value("월", entry.label),
                    y: .value("회고 수", entry.count)
                )
            }
            .chartXAxisLabel("월 단위")
            .chartYAxisLabel("회고 수")
        }
    }
}


#Preview {
    StatsticsView()
}

/*
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
*/
