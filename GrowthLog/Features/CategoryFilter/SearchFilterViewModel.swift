//
//  SearchFilterViewModel.swift
//  GrowthLog
//
//  Created by 백현진 on 5/13/25.
//

import Foundation
import SwiftUI
import SwiftData


final class SearchFilterViewModel: ObservableObject {
    private let modelContext: ModelContext
    var logs: [LogMainData] = []
    

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchLogs()
    }
    
    func fetchLogs() {
        do {
            let descriptor = FetchDescriptor<LogMainData>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)])
            logs = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch logs: \(error.localizedDescription)")
        }
    }
    
    
    func filteredResults(for keyword: String) -> [LogMainData] {
        guard !keyword.isEmpty else { return [] }
        
        return logs.filter {
            $0.title?.localizedCaseInsensitiveContains(keyword) == true ||
            $0.keep.localizedCaseInsensitiveContains(keyword) ||
            $0.problem.localizedCaseInsensitiveContains(keyword) ||
            $0.tryContent.localizedCaseInsensitiveContains(keyword) ||
            $0.category?.title.localizedCaseInsensitiveContains(keyword) == true ||
            $0.childCategory?.name.localizedCaseInsensitiveContains(keyword) == true
        }
    }
    
   
    func filterByCategory(categoryId: Int?) -> [LogMainData] {
        guard let categoryId = categoryId else { return logs }
        
        return logs.filter {
            $0.category?.id == categoryId
        }
    }
    
    
    func filterByChildCategory(childCategoryType: ChildCategoryType?) -> [LogMainData] {
        guard let childCategoryType = childCategoryType else { return logs }
        
        return logs.filter {
            $0.childCategory?.type == childCategoryType
        }
    }
    
    
    func filterByDateRange(from: Date?, to: Date?) -> [LogMainData] {
        var filteredLogs = logs
        
        if let fromDate = from {
            filteredLogs = filteredLogs.filter { $0.creationDate >= fromDate }
        }
        
        if let toDate = to {
            
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: toDate)!
            filteredLogs = filteredLogs.filter { $0.creationDate < nextDay }
        }
        
        return filteredLogs
    }
    
    
    func applyFilters(keyword: String? = nil,
                      categoryId: Int? = nil,
                      childCategoryType: ChildCategoryType? = nil,
                      fromDate: Date? = nil,
                      toDate: Date? = nil) -> [LogMainData] {
        var result = logs
        
        
        if let keyword = keyword, !keyword.isEmpty {
            result = result.filter {
                $0.title?.localizedCaseInsensitiveContains(keyword) == true ||
                $0.keep.localizedCaseInsensitiveContains(keyword) ||
                $0.problem.localizedCaseInsensitiveContains(keyword) ||
                $0.tryContent.localizedCaseInsensitiveContains(keyword) ||
                $0.category?.title.localizedCaseInsensitiveContains(keyword) == true ||
                $0.childCategory?.name.localizedCaseInsensitiveContains(keyword) == true
            }
        }
        
        // 카테고리 필터링
        if let categoryId = categoryId {
            result = result.filter { $0.category?.id == categoryId }
        }
        
        // 태그 필터링
        if let childCategoryType = childCategoryType {
            result = result.filter { $0.childCategory?.type == childCategoryType }
        }
        
        // 날짜 필터링
        if let fromDate = fromDate {
            result = result.filter { $0.creationDate >= fromDate }
        }
        
        if let toDate = toDate {
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: toDate)!
            result = result.filter { $0.creationDate < nextDay }
        }
        
        return result
    }
}
