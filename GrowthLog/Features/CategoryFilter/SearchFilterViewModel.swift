//
//  SearchFilterViewModel.swift
//  GrowthLog
//
//  Created by 백현진 on 5/13/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class SearchFilterViewModel {
    //var items: [LogEntry] = loadLogEntriesFromJSON()
    let items: [LogItem] = [
        .init(title: "SwiftUI 학습",       category: LogListView.categorys[0], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-1*24*3600)),
        .init(title: nil,                 category: LogListView.categorys[2], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-1*24*3600)),
        .init(title: "CoreData CRUD 구현", category: LogListView.categorys[1], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-2*24*3600)),
        .init(title: "MVVM 구조 적용",      category: LogListView.categorys[3], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-3*24*3600)),
        .init(title: "UI 리팩토링",         category: LogListView.categorys[4], keep: "학습 개념 이해", problem: "응용", tryContents: "많이 사용해 보기", date: Date().addingTimeInterval(-4*24*3600))
    ]

//    static func loadLogEntriesFromJSON() -> [LogEntry] {
//        guard let url = Bundle.main.url(forResource: "logs", withExtension: "json") else {
//            print("❌ logs.json 파일을 찾을 수 없습니다.")
//            return []
//        }
//
//        do {
//            let data = try Data(contentsOf: url)
//            let decoded = try JSONDecoder().decode(LogsData.self, from: data)
//            return decoded.logs
//        } catch {
//            print("❌ JSON 디코딩 실패: \(error)")
//            return []
//        }
//    }


    func filteredResults(for keyword: String) -> [LogItem] {
        guard !keyword.isEmpty else { return [] }
        return items.filter {
            $0.title?.localizedCaseInsensitiveContains(keyword) == true ||
            $0.keep.localizedCaseInsensitiveContains(keyword) ||
            $0.problem.localizedCaseInsensitiveContains(keyword) ||
            $0.tryContents.localizedCaseInsensitiveContains(keyword)
        }
    }
}
