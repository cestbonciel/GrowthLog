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
    var tags: [Tag]
    
    init(title: String, tags: [Tag] = []) {
        self.title = title
        self.tags = tags
    }
}

@Model
class Tag {
    var name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}
