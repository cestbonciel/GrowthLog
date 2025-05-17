//
//  LogListViewModel.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//


import Foundation
import SwiftData

final class LogListViewModel: ObservableObject {
    @Published var logs: [LogMainData] = []
    @Published var errorMessage: String?

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext


        Task {
            await loadJsonIfNeeded()
            fetchLogs()
        }
    }

    func fetchLogs() {
        DispatchQueue.global().async {
            do {
                let descriptor = FetchDescriptor<LogMainData>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)])
                let fetchedLogs = try self.modelContext.fetch(descriptor)

                DispatchQueue.main.async {
                    self.logs = fetchedLogs
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch logs: \(error.localizedDescription)"
                }
            }
        }
    }

    func deleteLog(at indexSet: IndexSet) {
        for index in indexSet {
            let log = logs[index]
            modelContext.delete(log)
        }

        do {
            try modelContext.save()
            fetchLogs()
        } catch {
            errorMessage = "Failed to delete log: \(error.localizedDescription)"
        }
    }

    func log(for id: Int) -> LogMainData? {
        logs.first { $0.id == id }
    }

    func loadJsonIfNeeded() async {
        do {
            let existingLogs = try modelContext.fetch(FetchDescriptor<LogMainData>())
            guard existingLogs.isEmpty else {
                return // 이미 데이터 있음 → JSON insert 생략
            }

            // JSON에서 파싱하고 insert
            try await insertLogsFromJson()
        } catch {
            errorMessage = "초기 데이터 로딩 실패: \(error.localizedDescription)"
        }
    }

    func insertLogsFromJson() async throws {
        guard let url = Bundle.main.url(forResource: "log_data", withExtension: "json") else {
            throw NSError(domain: "JSON 로드 실패", code: 0)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let parsed = try decoder.decode(LogJson.self, from: data)

        // 1. 미리 고정된 카테고리 생성
        let tech = Category(type: .tech)
        let programming = Category(type: .programming)
        let selfDev = Category(type: .selfDevelopment)
        let etc = Category(type: .etc)

        // 2. 태그 맵 생성
        let tagMap: [String: ChildCategory] = {
            var map: [String: ChildCategory] = [:]
            for type in ChildCategoryType.allCases {
                let tag = ChildCategory(type: type)
                map[type.rawValue] = tag
            }
            return map
        }()

        for logData in parsed.logs {
            guard let childCategory = tagMap[logData.childCategoryType] else { continue }

            let category: Category
            switch logData.categoryId {
            case 1: category = tech
            case 2: category = programming
            case 3: category = selfDev
            case 4: category = etc
            default: continue
            }

            childCategory.category = category
            category.tags.append(childCategory)

            let formatter = DateFormatter() // ✅ 올바른 타입
            formatter.dateFormat = "yyyy-MM-dd hh:mm a"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            let dateString = "2025-05-17 08:30 AM"
            if let date = formatter.date(from: dateString) {
                print("파싱된 날짜: \(date)")
            } else {
                print("날짜 파싱 실패")
            }

            // 날짜 파싱
            guard let date = formatter.date(from: logData.creationDate) else { continue }

            let log = LogMainData(
                id: logData.id,
                title: logData.title,
                keep: logData.keep,
                problem: logData.problem,
                tryContent: logData.tryContent,
                creationDate: date,
                category: category,
                childCategory: childCategory
            )

            modelContext.insert(log)
        }

        try modelContext.save()
    }
}
