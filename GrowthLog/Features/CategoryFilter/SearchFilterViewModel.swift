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
    let searchHistory: [String] = [
        "Swift", "Python", "JavaScript", "iOS", "면접 질문", "코딩 테스트", "Xcode", "SwiftUI"
    ]

    func filteredResults(for keyword: String) -> [String] {
        guard !keyword.isEmpty else { return [] }
        return searchHistory.filter { $0.localizedCaseInsensitiveContains(keyword) }
    }
}
