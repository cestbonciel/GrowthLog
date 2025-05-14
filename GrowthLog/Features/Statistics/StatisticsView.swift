//
//  StatsticsView.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import SwiftUI
import Charts

// MARK: 주, 월별 통계 및 분석 UI
struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedPeriod: StatPeriod = .weekly
    @State private var selectedStatTab: StatTabType = .tags
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 상단 헤더와 기본 통계
                headerSection
                
                // 주/월 선택 세그먼트
                periodSegmentPicker
                
                // 회고 건수 차트
                logCountChartSection
                
                // 키워드/태그 선택 세그먼트
                statTypeSegmentPicker
                
                // 키워드/태그 분포 차트
                keywordTagDistributionSection
            }
            .padding()
        }
        .navigationTitle("통계")
        .background(Color(UIColor.systemGray6))
    }
    
    // 상단 헤더 및 기본 통계
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("회고 통계")
                .font(.title2).bold()
            
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
        }
    }
    
    // 주/월 선택 피커
    private var periodSegmentPicker: some View {
        Picker("기간", selection: $selectedPeriod) {
            ForEach(StatPeriod.allCases) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical, 8)
    }
    
    // 회고 건수 차트 섹션
    private var logCountChartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("회고 건수")
                .font(.headline)
            
            if selectedPeriod == .weekly {
                weeklyChart
            } else {
                monthlyChart
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // 주간 차트
    private var weeklyChart: some View {
        Chart(viewModel.weeklyStats) { stat in
            BarMark(
                x: .value("주", stat.period),
                y: .value("회고 수", stat.count)
            )
            .foregroundStyle(.green)
            .annotation(position: .top) {
                Text("\(stat.count)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 200)
        .chartXAxisLabel("주 단위")
        .chartYAxisLabel("회고 수")
    }
    
    // 월간 차트
    private var monthlyChart: some View {
        Chart(viewModel.monthlyStats) { stat in
            LineMark(
                x: .value("월", stat.period),
                y: .value("회고 수", stat.count)
            )
            .foregroundStyle(.green)
            
            PointMark(
                x: .value("월", stat.period),
                y: .value("회고 수", stat.count)
            )
            .foregroundStyle(.green)
            .annotation(position: .top) {
                Text("\(stat.count)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 200)
        .chartXAxisLabel("월 단위")
        .chartYAxisLabel("회고 수")
    }
    
    // 태그/키워드 선택 피커
    private var statTypeSegmentPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("주요 키워드별 집계")
                .font(.headline)
                .padding(.top, 8)
            
            Picker("통계 유형", selection: $selectedStatTab) {
                ForEach(StatTabType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // 키워드/태그 분포 차트 섹션
    private var keywordTagDistributionSection: some View {
        VStack {
            if selectedStatTab == .tags {
                tagsPieChart
            } else {
                keywordsPieChart
            }
            
            // 범례
            legendView
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // 태그 파이 차트
    private var tagsPieChart: some View {
        let data = selectedPeriod == .weekly ? viewModel.weeklyTags : viewModel.monthlyTags
        
        return Chart(data) { item in
            SectorMark(
                angle: .value("비율", item.count),
                innerRadius: .ratio(0.5),
                angularInset: 1
            )
            .foregroundStyle(item.color)
            .cornerRadius(5)
        }
        .frame(height: 200)
        .chartBackground { _ in
            VStack {
                Text("태그")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(data.reduce(0) { $0 + $1.count })개")
                    .font(.title3).bold()
            }
        }
    }
    
    // 키워드 파이 차트
    private var keywordsPieChart: some View {
        let data = selectedPeriod == .weekly ? viewModel.weeklyKeywords : viewModel.monthlyKeywords
        
        return Chart(data) { item in
            SectorMark(
                angle: .value("비율", item.count),
                innerRadius: .ratio(0.5),
                angularInset: 1
            )
            .foregroundStyle(item.color)
            .cornerRadius(5)
        }
        .frame(height: 200)
        .chartBackground { _ in
            VStack {
                Text("키워드")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(data.reduce(0) { $0 + $1.count })개")
                    .font(.title3).bold()
            }
        }
    }
    
    // 차트 범례
    private var legendView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if selectedStatTab == .tags {
                ForEach(selectedPeriod == .weekly ? viewModel.weeklyTags : viewModel.monthlyTags) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: 10, height: 10)
                        Text(item.tag)
                            .font(.subheadline)
                        Spacer()
                        Text("\(Int(item.percentage))%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                ForEach(selectedPeriod == .weekly ? viewModel.weeklyKeywords : viewModel.monthlyKeywords) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: 10, height: 10)
                        Text(item.keyword)
                            .font(.subheadline)
                        Spacer()
                        Text("\(Int(item.percentage))%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}


#Preview {
    StatisticsView()
}
