//
//  StatsticsView.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import SwiftUI
import Charts

/// MARK: 주, 월별 통계 및 분석 UI
struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedPeriod: StatPeriod = .weekly
    @State private var selectedStatTab: StatTabType = .tags
    @Environment(\.colorScheme) private var colorScheme
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM"
        return df
    }()
    
    private var canNavigateToPreviousMonth: Bool {
        if let firstLog = viewModel.allLogs.sorted(by: { $0.creationDate < $1.creationDate }).first {
            let firstLogYear = Calendar.current.component(.year, from: firstLog.creationDate)
            let firstLogMonth = Calendar.current.component(.month, from: firstLog.creationDate)
            
            return (firstLogYear < viewModel.selectedYear) ||
            (firstLogYear == viewModel.selectedYear && firstLogMonth < viewModel.selectedMonth)
        }
        return false
    }
    
    private var canNavigateToNextMonth: Bool {
        if let lastLog = viewModel.allLogs.sorted(by: { $0.creationDate > $1.creationDate }).first {
            let lastLogYear = Calendar.current.component(.year, from: lastLog.creationDate)
            let lastLogMonth = Calendar.current.component(.month, from: lastLog.creationDate)
            
            return (lastLogYear > viewModel.selectedYear) ||
            (lastLogYear == viewModel.selectedYear && lastLogMonth > viewModel.selectedMonth)
        }
        return false
    }
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("회고 통계")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGray6))
            .onAppear {
                viewModel.loadStatJsonData()
                viewModel.loadMonthlyStats(year: viewModel.selectedYear, month: viewModel.selectedMonth)
            }
            .onChange(of: selectedPeriod) { newValue in
                viewModel.updateStatisticsForPeriod(
                    period: newValue,
                    year: viewModel.selectedYear,
                    month: viewModel.selectedMonth
                )
            }
        }
    }
    
    // 상단 헤더 및 기본 통계
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
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
                
                Spacer()
                
                // 날짜 탐색 - 포맷 변경 (콤마 제거)
                HStack(spacing: 16) {
                    Button {
                        // 한 달 뒤로 이동
                        if viewModel.selectedMonth == 1 {
                            viewModel.selectedMonth = 12
                            viewModel.selectedYear -= 1
                        } else {
                            viewModel.selectedMonth -= 1
                        }
                        viewModel.loadMonthlyStats(year: viewModel.selectedYear, month: viewModel.selectedMonth)
                        viewModel.updateStatisticsForPeriod(period: selectedPeriod, year: viewModel.selectedYear, month: viewModel.selectedMonth)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(canNavigateToPreviousMonth ? .primary : .gray.opacity(0.5))
                    }
                    .disabled(!canNavigateToPreviousMonth)
                    
                    // 콤마 없는 날짜 포맷
                    Text(" \(String(format: "%d", viewModel.selectedYear)).\(String(format: "%02d", viewModel.selectedMonth)) ")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button {
                        // 한 달 앞으로 이동
                        if viewModel.selectedMonth == 12 {
                            viewModel.selectedMonth = 1
                            viewModel.selectedYear += 1
                        } else {
                            viewModel.selectedMonth += 1
                        }
                        viewModel.loadMonthlyStats(year: viewModel.selectedYear, month: viewModel.selectedMonth)
                        viewModel.updateStatisticsForPeriod(period: selectedPeriod, year: viewModel.selectedYear, month: viewModel.selectedMonth)
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(canNavigateToNextMonth ? .primary : .gray.opacity(0.5))
                    }
                    .disabled(!canNavigateToNextMonth)
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
                .foregroundStyle(.primary)
            
            if selectedPeriod == .weekly {
                weeklyChart
            } else {
                monthlyChart
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color.white)
        .cornerRadius(12)
    }
    
    private var weeklyChart: some View {
        Chart(viewModel.weeklyStats) { stat in
            BarMark(
                x: .value("주", stat.period),
                y: .value("회고 수", stat.count)
            )
            .foregroundStyle(Color.green)
            .annotation(position: .top) {
                Text("\(stat.count)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 200)
        .chartXAxisLabel("주 단위")
        .chartYAxisLabel("회고 수")
        .chartForegroundStyleScale([
            "회고 수": Color.green
        ])
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            }
        }
    }
    
    // 월간 차트
    private var monthlyChart: some View {
        Chart(viewModel.monthlyStats) { stat in
            LineMark(
                x: .value("월", stat.period),
                y: .value("회고 수", stat.count)
            )
            .foregroundStyle(Color.green)
            
            PointMark(
                x: .value("월", stat.period),
                y: .value("회고 수", stat.count)
            )
            .foregroundStyle(Color.green)
            .annotation(position: .top) {
                Text("\(stat.count)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 200)
        .chartXAxisLabel("월 단위")
        .chartYAxisLabel("회고 수")
        .chartForegroundStyleScale([
            "회고 수": Color.green
        ])
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            }
        }
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
            .onChange(of: selectedStatTab) { _ in
                // 탭 변경 시 데이터 갱신을 위한 모의 이벤트
                viewModel.updateStatisticsForPeriod(
                    period: selectedPeriod,
                    year: viewModel.selectedYear,
                    month: viewModel.selectedMonth
                )
            }
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
        .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color.white)
        .cornerRadius(12)
    }
    
    // 태그 파이 차트
    private var tagsPieChart: some View {
        let data = selectedPeriod == .weekly ? viewModel.weeklyTags : viewModel.monthlyTags
        
        return Group {
            if data.isEmpty {
                emptyStatePlaceholder("태그 데이터가 없습니다")
            } else {
                Chart(data) { item in
                    SectorMark(
                        angle: .value("비율", item.count),
                        innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(item.color)
                    .cornerRadius(5)
                }
                .frame(height: 200)
                .chartBackground { chartProxy in
                    GeometryReader { geometry in
                        let frame = geometry[chartProxy.plotAreaFrame]
                        VStack {
                            Text("태그")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(data.count)개") // data.count로 변경
                                .font(.title3).bold()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
        }
    }

    // 키워드 파이 차트
    private var keywordsPieChart: some View {
        let data = selectedPeriod == .weekly ? viewModel.weeklyKeywords : viewModel.monthlyKeywords
        
        return Group {
            if data.isEmpty {
                emptyStatePlaceholder("키워드 데이터가 없습니다")
            } else {
                Chart(data) { item in
                    SectorMark(
                        angle: .value("비율", item.count),
                        innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(item.color)
                    .cornerRadius(5)
                }
                .frame(height: 200)
                .chartBackground { chartProxy in
                    GeometryReader { geometry in
                        let frame = geometry[chartProxy.plotAreaFrame]
                        VStack {
                            Text("키워드")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(data.count)개") // data.count로 변경
                                .font(.title3).bold()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
        }
    }
    
    /// 데이터가 없을 때 표시할 placeholder
    private func emptyStatePlaceholder(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.pie")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity) // 너비 채우기
        .padding(.vertical, 20)
    }
    
    /// 차트 범례
    private var legendView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if selectedStatTab == .tags {
                let data = selectedPeriod == .weekly ? viewModel.weeklyTags : viewModel.monthlyTags
                if data.isEmpty {
                    Text("표시할 태그 데이터가 없습니다")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical)
                } else {
                    ForEach(data) { item in
                        HStack {
                            Circle()
                                .fill(item.color)
                                .frame(width: 10, height: 10)
                            Text(item.tag)
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("\(Int(item.percentage))%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } else {
                let data = selectedPeriod == .weekly ? viewModel.weeklyKeywords : viewModel.monthlyKeywords
                if data.isEmpty {
                    Text("표시할 키워드 데이터가 없습니다")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical)
                } else {
                    ForEach(data) { item in
                        HStack {
                            Circle()
                                .fill(item.color)
                                .frame(width: 10, height: 10)
                            Text(item.keyword)
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("\(Int(item.percentage))%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
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
