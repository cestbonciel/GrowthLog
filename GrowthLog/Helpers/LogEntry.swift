//
//  LogEntry.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/13/25.
//
import Foundation

// 전체 JSON 구조 정의
struct LogsData: Codable {
    let logs: [LogEntry]
}

// 데이터 구조 정의
struct LogEntry: Codable {
    let id: Int
    let creationDate: String
    let categoryId: Int
    let categoryType: String
    let childCategoryType: String
    let title: String?  // 옵셔널 문자열 타입으로 제목 추가
    let keep: String
    let problem: String
    let `try`: String
    
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
        formatter.dateFormat = "yyyy-MM-dd hh:mm a" // 여기를 수정 - a 추가
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
    
    // 제목이 비어있으면 "KPT회고" 반환하는 메서드
    func getTitle() -> String {
        return title ?? "KPT 회고"
    }
}
