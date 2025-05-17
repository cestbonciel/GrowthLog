//
//  LogEditorViewModel.swift
//
//  Created by JuYong Lee on 5/12/25.
//  GrowthLog
//

import SwiftUI

class LogEditorViewModel: ObservableObject {
    var categories: [Category]
    
    init() {
        self.categories = [
            Category(type: .programming, tags: [
                ChildCategory(type: .swift), ChildCategory(type: .python),
                ChildCategory(type: .java), ChildCategory(type: .javascript),
                ChildCategory(type: .react), ChildCategory(type: .cpp)
            ]),
            Category(type: .tech, tags: [
                ChildCategory(type: .computerScience), ChildCategory(type: .network),
                ChildCategory(type: .security), ChildCategory(type: .infrastructure),
                ChildCategory(type: .softwareEngineering)
            ]),
            Category(type: .selfDevelopment, tags: [
                ChildCategory(type: .codingTest), ChildCategory(type: .interview),
                ChildCategory(type: .sideProject)
            ]),
            Category(type: .etc, tags: [
                ChildCategory(type: .idea), ChildCategory(type: .design),
                ChildCategory(type: .product), ChildCategory(type: .uiux)
            ])
        ]
    }
    
    // 뷰모델의 `tags.isSelected` 상태를 덮어쓰기
    func applySelections(to catType: CategoryType, modalSelectedTags: [ChildCategoryType]) {
        guard let cat = categories.first(where: { $0.type == catType }) else { return }
        cat.tags.forEach { $0.isSelected = modalSelectedTags.contains($0.type) }
    }
    
}
