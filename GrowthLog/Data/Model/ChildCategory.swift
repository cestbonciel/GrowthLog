//
//  ChildCategory.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//

import Foundation
import SwiftData

// 1) 태그를 열거형으로 정의
enum ChildCategoryType: String, CaseIterable, Codable, Identifiable {
    // 기술
    case computerScience    = "컴퓨터과학"
    case network            = "네트워크"
    case security           = "보안"
    case infrastructure     = "인프라"
    case softwareEngineering = "소프트웨어 공학"
    // 프로그래밍
    case swift              = "Swift"
    case cpp                = "C++"
    case python             = "Python"
    case java               = "Java"
    case javascript         = "JavaScript"
    case react              = "React"
    // 자기개발
    case codingTest         = "코딩테스트"
    case interview          = "면접"
    case sideProject        = "사이드프로젝트"
    // 기타
    case idea               = "IDEA"
    case design             = "디자인"
    case product            = "Product"
    case uiux               = "UIUX"
    
    var id: Self { self }
}

@Model
final class ChildCategory {
    @Attribute var type: ChildCategoryType
    @Attribute var isSelected: Bool = false
    
    /// inverse 관계 (nullify): ChildCategory가 참조하는 Category가 삭제되면 category가 nil로 설정
    /// 반대로 카테고리는 유지하고 태그만 취소, 변경시 카테고리는 보호할 수 있다.
    @Relationship(deleteRule: .nullify) var category: Category?
    
    // UI에 편리한 표시명
    var name: String { type.rawValue }
    
    init(type: ChildCategoryType) {
        self.type = type
    }
}
