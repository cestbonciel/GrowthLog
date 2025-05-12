//
//  LogMainView.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//

import SwiftUI

/// MARK: - App 에 뿌려질 메인 뷰
struct LogMainView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            CategoryFilterView()
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(0)
            LogListView()
                .tabItem { Image(systemName: "square.stack.3d.up.fill") }
                .tag(1)
            WeeklyStatsView()
                .tabItem { Image(systemName: "chart.xyaxis.line") }
                .tag(2)
        }
        .tint(Color.growthGreen)
    }
}

#Preview {
    LogMainView()
}
