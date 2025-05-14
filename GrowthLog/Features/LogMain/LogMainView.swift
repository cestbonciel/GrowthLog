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
    @Environment(\.modelContext) private var modelContext

    /// TODO: TabView가 iOS 18+ 이라 분기처리 필요할 수도 있음
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchFilterView()
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(0)
            LogListView(modelContext: modelContext)
                .tabItem { Image(systemName: "square.stack.3d.up.fill") }
                .tag(1)
            StatsticsView()
                .tabItem { Image(systemName: "chart.xyaxis.line") }
                .tag(2)
        }
        .tint(Color.growthGreen)
    }
}

#Preview {
    LogMainView()
        .modelContainer(for: [LogMainData.self/*, Category.self, ChildCategory.self*/], inMemory: true)

}
