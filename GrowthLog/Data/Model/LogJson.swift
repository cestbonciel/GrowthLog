//
//  LogJson.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/14/25.
//

import Foundation


// MARK: - JSON 파싱을 위한 모델
struct LogJson: Codable {
    let logs: [LogData]
}

struct LogData: Codable, Identifiable {
    let categoryId: Int
    let categoryType: String
    let childCategoryType: String
    let creationDate: String
    let id: Int
    let keep: String
    let problem: String
    let title: String
    let tryContent: String
    
    enum CodingKeys: String, CodingKey {
        case categoryId, categoryType, childCategoryType, creationDate, id, keep, problem, title
        case tryContent = "try"
    }
}
