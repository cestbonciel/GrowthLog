//
//  LogListViewModel.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//

import SwiftUI
import SwiftData


final class LogListViewModel: ObservableObject {
    private let modelContext: ModelContext
    @Published var logs: [LogMainData] = []
    @Published var categories: [Category] = []
    @Published var childCategories: [ChildCategory] = []
    @Published var errorMessage: String?
    @Published var jsonLogs: [LogData] = []
    @Published var isJsonLoading = true
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        // 카테고리 먼저 초기화하고 확실히 완료되게 함
        initializeCategoriesAndWait()
        loadCategoriesIfNeeded()
        loadJsonData()
    }

    private func initializeCategoriesAndWait() {
        // 기존 loadCategoriesIfNeeded 메서드를 향상시킴
        do {
            let categoryDescriptor = FetchDescriptor<Category>()
            let existingCategories = try modelContext.fetch(categoryDescriptor)
            
            if existingCategories.isEmpty {
                // 카테고리 생성
                let techCategory = Category(type: .tech)
                let programmingCategory = Category(type: .programming)
                let selfDevCategory = Category(type: .selfDevelopment)
                let etcCategory = Category(type: .etc)
                
                // 기술 카테고리 태그
                let csTag = ChildCategory(type: .computerScience)
                let networkTag = ChildCategory(type: .network)
                let securityTag = ChildCategory(type: .security)
                let infraTag = ChildCategory(type: .infrastructure)
                let softwareTag = ChildCategory(type: .softwareEngineering)
                
                // 프로그래밍 카테고리 태그
                let swiftTag = ChildCategory(type: .swift)
                let cppTag = ChildCategory(type: .cpp)
                let pythonTag = ChildCategory(type: .python)
                let javaTag = ChildCategory(type: .java)
                let jsTag = ChildCategory(type: .javascript)
                let reactTag = ChildCategory(type: .react)
                
                // 자기개발 카테고리 태그
                let codingTestTag = ChildCategory(type: .codingTest)
                let interviewTag = ChildCategory(type: .interview)
                let sideProjectTag = ChildCategory(type: .sideProject)
                
                // 기타 카테고리 태그
                let ideaTag = ChildCategory(type: .idea)
                let designTag = ChildCategory(type: .design)
                let productTag = ChildCategory(type: .product)
                let uiuxTag = ChildCategory(type: .uiux)
                
                // 카테고리에 태그 할당
                techCategory.tags = [csTag, networkTag, securityTag, infraTag, softwareTag]
                programmingCategory.tags = [swiftTag, cppTag, pythonTag, javaTag, jsTag, reactTag]
                selfDevCategory.tags = [codingTestTag, interviewTag, sideProjectTag]
                etcCategory.tags = [ideaTag, designTag, productTag, uiuxTag]
                
                // 태그에 카테고리 연결
                for tag in techCategory.tags {
                    tag.category = techCategory
                    modelContext.insert(tag)
                }
                
                for tag in programmingCategory.tags {
                    tag.category = programmingCategory
                    modelContext.insert(tag)
                }
                
                for tag in selfDevCategory.tags {
                    tag.category = selfDevCategory
                    modelContext.insert(tag)
                }
                
                for tag in etcCategory.tags {
                    tag.category = etcCategory
                    modelContext.insert(tag)
                }
                
                // 카테고리 저장
                modelContext.insert(techCategory)
                modelContext.insert(programmingCategory)
                modelContext.insert(selfDevCategory)
                modelContext.insert(etcCategory)
                
                try modelContext.save()
                
                // 중요: 다시 가져와서 메모리에 있는 배열 업데이트
                fetchCategories()
                fetchChildCategories()
                
                // 로그 추가하여 카테고리가 제대로 생성됐는지 확인
                print("카테고리 생성 완료: \(categories.count)개")
                categories.forEach { print("ID: \($0.id), 타입: \($0.type.rawValue)") }
            } else {
                // 기존 카테고리가 있는 경우 로드
                fetchCategories()
                fetchChildCategories()
            }
        } catch {
            errorMessage = "카테고리 초기화 실패: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    // 카테고리 데이터 초기화 (앱 첫 실행시)
    private func loadCategoriesIfNeeded() {
        do {
            let categoryDescriptor = FetchDescriptor<Category>()
            let existingCategories = try modelContext.fetch(categoryDescriptor)
            
            if existingCategories.isEmpty {
                // 카테고리 생성
                let techCategory = Category(type: .tech)
                let programmingCategory = Category(type: .programming)
                let selfDevCategory = Category(type: .selfDevelopment)
                let etcCategory = Category(type: .etc)
                
                // 기술 카테고리 태그
                let csTag = ChildCategory(type: .computerScience)
                let networkTag = ChildCategory(type: .network)
                let securityTag = ChildCategory(type: .security)
                let infraTag = ChildCategory(type: .infrastructure)
                let softwareTag = ChildCategory(type: .softwareEngineering)
                
                // 프로그래밍 카테고리 태그
                let swiftTag = ChildCategory(type: .swift)
                let cppTag = ChildCategory(type: .cpp)
                let pythonTag = ChildCategory(type: .python)
                let javaTag = ChildCategory(type: .java)
                let jsTag = ChildCategory(type: .javascript)
                let reactTag = ChildCategory(type: .react)
                
                // 자기개발 카테고리 태그
                let codingTestTag = ChildCategory(type: .codingTest)
                let interviewTag = ChildCategory(type: .interview)
                let sideProjectTag = ChildCategory(type: .sideProject)
                
                // 기타 카테고리 태그
                let ideaTag = ChildCategory(type: .idea)
                let designTag = ChildCategory(type: .design)
                let productTag = ChildCategory(type: .product)
                let uiuxTag = ChildCategory(type: .uiux)
                
                // 카테고리에 태그 할당
                techCategory.tags = [csTag, networkTag, securityTag, infraTag, softwareTag]
                programmingCategory.tags = [swiftTag, cppTag, pythonTag, javaTag, jsTag, reactTag]
                selfDevCategory.tags = [codingTestTag, interviewTag, sideProjectTag]
                etcCategory.tags = [ideaTag, designTag, productTag, uiuxTag]
                
                // 태그에 카테고리 연결
                for tag in techCategory.tags {
                    tag.category = techCategory
                    modelContext.insert(tag)
                }
                
                for tag in programmingCategory.tags {
                    tag.category = programmingCategory
                    modelContext.insert(tag)
                }
                
                for tag in selfDevCategory.tags {
                    tag.category = selfDevCategory
                    modelContext.insert(tag)
                }
                
                for tag in etcCategory.tags {
                    tag.category = etcCategory
                    modelContext.insert(tag)
                }
                
                // 카테고리 저장
                modelContext.insert(techCategory)
                modelContext.insert(programmingCategory)
                modelContext.insert(selfDevCategory)
                modelContext.insert(etcCategory)
                
                try modelContext.save()
            }
            
            // 카테고리 및 태그 로드
            fetchCategories()
            fetchChildCategories()
            
        } catch {
            errorMessage = "Failed to initialize categories: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    // 카테고리 가져오기
    private func fetchCategories() {
        do {
            let descriptor = FetchDescriptor<Category>()
            categories = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to fetch categories: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    // 태그 가져오기
    private func fetchChildCategories() {
        do {
            let descriptor = FetchDescriptor<ChildCategory>()
            childCategories = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to fetch child categories: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    // JSON 파일을 파싱하고 SwiftData에 저장
    func loadJsonData() {
        guard let url = Bundle.main.url(forResource: "log_data", withExtension: "json") else {
            errorMessage = "Cannot find log_data.json in the app bundle"
            return
        }
        
        // 이미 데이터가 로드되었는지 확인
        do {
            let descriptor = FetchDescriptor<LogMainData>()
            let existingLogs = try modelContext.fetch(descriptor)
            
            if !existingLogs.isEmpty {
                logs = existingLogs
                return // 이미 데이터가 있으면 다시 로드하지 않음
            }
        } catch {
            print("Error checking existing logs: \(error.localizedDescription)")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let logJson = try decoder.decode(LogJson.self, from: data)
            
            // 카테고리 사전 생성 (카테고리 관련 문제 회피)
            let techCategory = Category(type: .tech)
            let programmingCategory = Category(type: .programming)
            let selfDevCategory = Category(type: .selfDevelopment)
            let etcCategory = Category(type: .etc)
            
            modelContext.insert(techCategory)
            modelContext.insert(programmingCategory)
            modelContext.insert(selfDevCategory)
            modelContext.insert(etcCategory)
            
            // 차일드카테고리 사전 생성
            let childCategoryMap = createChildCategories()
            
            // 임시 컬렉션에 로그 데이터 모으기
            var newLogs: [LogMainData] = []
            
            // SwiftData에 데이터 저장
            for logData in logJson.logs {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                guard let date = dateFormatter.date(from: logData.creationDate) else {
                    print("Failed to parse date: \(logData.creationDate)")
                    continue
                }
                
                // ID 기반으로 적절한 카테고리 선택
                let category: Category
                switch logData.categoryId {
                case 1: category = techCategory
                case 2: category = programmingCategory
                case 3: category = selfDevCategory
                case 4: category = etcCategory
                default:
                    print("Invalid category ID: \(logData.categoryId)")
                    continue
                }
                
                // 차일드 카테고리 타입으로 찾기
                guard let childCategory = childCategoryMap[logData.childCategoryType] else {
                    print("Child category not found for type: \(logData.childCategoryType)")
                    continue
                }
                
                let logMainData = LogMainData(
                    id: logData.id,
                    title: logData.title,
                    keep: logData.keep,
                    problem: logData.problem,
                    tryContent: logData.tryContent,
                    creationDate: date,
                    category: category,
                    childCategory: childCategory
                )
                newLogs.append(logMainData)
                modelContext.insert(logMainData)
            }
            
            // 로그 배열 업데이트
            logs = newLogs
            
            try modelContext.save()
        } catch {
            errorMessage = "Error loading or parsing the JSON: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    private func createChildCategories() -> [String: ChildCategory] {
        var map: [String: ChildCategory] = [:]
        
        // 모든 차일드 카테고리 타입을 순회하며 인스턴스 생성
        for type in ChildCategoryType.allCases {
            let childCategory = ChildCategory(type: type)
            modelContext.insert(childCategory)
            map[type.rawValue] = childCategory
        }
        
        return map
    }


    
    
    // 카테고리 ID로 찾기
    private func findCategory(byId id: Int) -> Category? {
        let found = categories.first { $0.id == id }
        if found == nil {
            print("카테고리 ID \(id) 검색 실패. 현재 메모리에 있는 카테고리: \(categories.map { "\($0.id):\($0.type.rawValue)" }.joined(separator: ", "))")
            
            // ID를 직접 찾지 못한 경우, CategoryType으로 간접 조회 시도
            if id == 1 { return categories.first { $0.type == .tech } }
            if id == 2 { return categories.first { $0.type == .programming } }
            if id == 3 { return categories.first { $0.type == .selfDevelopment } }
            if id == 4 { return categories.first { $0.type == .etc } }
        }
        return found
    }
    
    // 카테고리 타입으로 찾기
    private func findCategory(byType type: String) -> Category? {
        let categoryType = CategoryType(rawValue: type)
        return categories.first { $0.type == categoryType }
    }
    
    // 차일드 카테고리 타입으로 찾기
    private func findChildCategory(byType type: String) -> ChildCategory? {
        // ChildCategoryType 열거형으로 변환
        guard let childCategoryType = ChildCategoryType.allCases.first(where: { $0.rawValue == type }) else {
            return nil
        }
        
        return childCategories.first { $0.type == childCategoryType }
    }
    
    // 저장된 로그 데이터 가져오기
    func fetchLogs() {
        do {
            let descriptor = FetchDescriptor<LogMainData>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)])
            logs = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to fetch logs: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    // 새 로그 추가
    func addLog(title: String?, categoryId: Int, childCategoryType: String, keep: String, problem: String, tryContent: String) {
        guard let category = findCategory(byId: categoryId),
              let childCategory = findChildCategory(byType: childCategoryType) else {
            errorMessage = "Category or child category not found"
            return
        }
        
        // 새로운 ID 생성 (기존 ID 중 최대값 + 1)
        let newId = (logs.map { $0.id }.max() ?? 0) + 1
        
        let newLog = LogMainData(
            id: newId,
            title: title,
            keep: keep,
            problem: problem,
            tryContent: tryContent,
            creationDate: Date(),
            category: category,
            childCategory: childCategory
        )
        
        modelContext.insert(newLog)
        
        do {
            try modelContext.save()
            fetchLogs()
        } catch {
            errorMessage = "Failed to save new log: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    // 로그 업데이트
    func updateLog(log: LogMainData, title: String?, categoryId: Int? = nil, childCategoryType: String? = nil, keep: String, problem: String, tryContent: String) {
        log.title = title
        log.keep = keep
        log.problem = problem
        log.tryContent = tryContent
        
        // 카테고리 변경이 요청된 경우
        if let categoryId = categoryId, let category = findCategory(byId: categoryId) {
            log.category = category
        }
        
        // 차일드 카테고리 변경이 요청된 경우
        if let childCategoryType = childCategoryType, let childCategory = findChildCategory(byType: childCategoryType) {
            log.childCategory = childCategory
        }
        
        do {
            try modelContext.save()
            fetchLogs()
        } catch {
            errorMessage = "Failed to update log: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    // 로그 삭제
    func deleteLog(log: LogMainData) {
        modelContext.delete(log)
        
        do {
            try modelContext.save()
            fetchLogs()
        } catch {
            errorMessage = "Failed to delete log: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
}
