//
//  CategoryFilterViewModel.swift
//  GrowthLog
//
//  Created by 백현진 on 5/12/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class CategoryFilterViewModel {
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

    var selectedTags: [ChildCategory] {
        categories.flatMap { $0.tags }.filter { $0.isSelected }
    }

    func toggleSelection(for tag: ChildCategory) {
        guard let categoryIndex = categories.firstIndex(where: { $0.tags.contains(where: { $0.id == tag.id }) }) else { return }
        guard let tagIndex = categories[categoryIndex].tags.firstIndex(where: { $0.id == tag.id }) else { return }

        if categories[categoryIndex].tags[tagIndex].isSelected {
            categories[categoryIndex].tags[tagIndex].isSelected = false
        } else {
            guard selectedTags.count < 3 else { return }
            categories[categoryIndex].tags[tagIndex].isSelected = true
        }
    }

    func clearSelections() {
        for categoryIndex in categories.indices {
            for tagIndex in categories[categoryIndex].tags.indices {
                categories[categoryIndex].tags[tagIndex].isSelected = false
            }
        }
    }


}
