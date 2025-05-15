//
//  LogEditorViewModel.swift
//  GrowthLog
//
//  Created by JuYong Lee on 5/12/25.
//

import SwiftUI

final class LogEditorViewModel: ObservableObject {
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
    
    
}
