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
  // SwiftData 컨테이너에 Category, Tag 를 등록
    
    /// 임시로 설정한 뷰입니다. MainView로 넣어야 합니다.
  var body: some Scene {
    WindowGroup {
        CategoryFilterView()
    }
    .modelContainer(for: [Category.self, Tag.self])
  }
  
  
}

