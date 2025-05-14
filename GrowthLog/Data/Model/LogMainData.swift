//
//  LogMainData.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/14/25.
//

import Foundation
import SwiftData

@Model
final class LogMainData {
    @Attribute(.unique) var id: Int
    var title: String?
    var keep: String
    var problem: String
    var tryContent: String
    var creationDate: Date
    
    // 관계 설정
    @Relationship(deleteRule: .nullify) var category: Category?
    @Relationship(deleteRule: .nullify) var childCategory: ChildCategory?
    
    init(id: Int, title: String? = nil, keep: String, problem: String, tryContent: String, creationDate: Date, category: Category? = nil, childCategory: ChildCategory? = nil) {
        self.id = id
        self.title = title
        self.keep = keep
        self.problem = problem
        self.tryContent = tryContent
        self.creationDate = creationDate
        self.category = category
        self.childCategory = childCategory
    }
    
    // 날짜 포맷
    var formattedDate: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        return df.string(from: creationDate)
    }
    
    // 시간 포맷
    var formattedtime: String {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df.string(from: creationDate)
    }
}
