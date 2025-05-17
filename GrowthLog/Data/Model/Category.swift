//
//  CategoryTag.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//
import Foundation
import SwiftData

/// 카테고리 타입: 카테고리 4개케이스
enum CategoryType: String, CaseIterable, Codable, Identifiable {
    case tech = "기술"
    case programming = "프로그래밍"
    case selfDevelopment = "자기계발"
    case etc = "기타"
    
    var id: Self { self }
}
/// 모델 정의: Cascade 삭제 규칙 적용

@Model
final class Category {
    @Attribute var type: CategoryType
    @Attribute(.unique) var id: Int  // Int 타입 ID (고정값)
    @Relationship(deleteRule: .cascade) var tags: [ChildCategory] = []
    
    var title: String { type.rawValue }
    
    init(type: CategoryType, tags: [ChildCategory] = []) {
        self.type = type
        
        switch type {
        case .tech: self.id = 1
        case .programming: self.id = 2
        case .selfDevelopment: self.id = 3
        case .etc: self.id = 4
        }
        self.tags = tags
    }
    
    
    convenience init(title: String, tags: [ChildCategory] = []) {
        let type: CategoryType
        switch title {
        case "기술": type = .tech
        case "프로그래밍": type = .programming
        case "자기계발": type = .selfDevelopment
        case "기타": type = .etc
        default: type = .tech
        }
        
        self.init(type: type, tags: tags)
    }
}
