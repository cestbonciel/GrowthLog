//
//  GrowthLogApp.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import SwiftUI
import SwiftData

@main
struct GrowthLogApp: App {
    // SwiftData 컨테이너에 Category, Tag 를 등록 (아직 모델이 준비되지 않음)
    init() {
        // 1) 새로운 Appearance 객체 생성
        let appearance = UITabBarAppearance()
        // 2) default background + hairline 포함
        appearance.configureWithDefaultBackground()
        
        // 3) standard 및 scrollEdge 에 모두 적용
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    /// 임시로 설정한 뷰입니다. MainView로 넣어야 합니다.
    var body: some Scene {
        WindowGroup {
            LogMainView()
            //WeeklyStatsView()
            //CategoryFilterView(name: "magnifyingglass", color: .black)
        }
        /// TODO: 모델이 준비되면 주석 해제
        //.modelContainer(for: [Category.self, Tag.self])
    }
    
    
}

