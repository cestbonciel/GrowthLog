//
//  CategoryTag.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//
import Foundation
import SwiftData


@Model
class Category {
    var title: String
    var tags: [ChildCategory]
    
    init(title: String, tags: [ChildCategory] = []) {
        self.title = title
        self.tags = tags
    }
}

@Model
class ChildCategory {
    var name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}
