//
//  LogEntry.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//
import Foundation

struct LogsData: Codable {
    let logs: [LogEntry]
}

// 전체 JSON 구조 정의
struct LogEntry: Codable {
    let id: Int
    let creationDate: String
    let categoryId: Int
    let categoryType: String
    let childCategoryType: String
    let title: String?  // 옵셔널 String 유지
    let keep: String
    let problem: String
    let `try`: String
    // json 키 나열
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate
        case categoryId
        case categoryType
        case childCategoryType
        case title
        case keep
        case problem
        case `try`
    }
    
    // 필요시 Date 객체로 변환하는 메서드
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: creationDate)
    }
    
    // 다른 형식으로 포맷팅하는 메서드
    func getFormattedDate(format: String = "yyyy.MM.dd hh:mm a") -> String {
        guard let date = getDate() else { return creationDate }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = format
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date)
    }
    
    // getTitle 메서드 - 옵셔널 처리 유지
    func getTitle() -> String {
        return title ?? "KPT회고"
    }
}
