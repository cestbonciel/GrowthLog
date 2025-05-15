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
    // 온보딩 실행
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    //테마 변경
    @AppStorage("themeMode") private var themeRawValue: String = ThemeMode.system.rawValue

    private var selectedTheme: ColorScheme? {
            switch ThemeMode(rawValue: themeRawValue) ?? .system {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return nil
            }
    }

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

        // 온보딩 페이지 인디케이터 색상 설정
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.green
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
    }
    
    /// 임시로 설정한 뷰입니다. MainView로 넣어야 합니다.
    var body: some Scene {
        WindowGroup {

            // 첫 실행일때 온보딩 뷰 실행
            if hasSeenOnboarding {
                LogMainView()
                    .preferredColorScheme(selectedTheme)
            } else {
                OnboardingView()
                    .preferredColorScheme(selectedTheme)
            }

            //WeeklyStatsView()
            //CategoryFilterView(name: "magnifyingglass", color: .black)
        }
        /// TODO: 모델이 준비되면 주석 해제
        .modelContainer(for: [LogMainData.self, Category.self, ChildCategory.self])
    }
    
    
}

