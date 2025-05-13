//
//  CategoryFilterViewModel.swift
//  GrowthLog
//
//  Created by Nat Kim on 5/12/25.
//

import SwiftUI
import SwiftData

/// ViewModel 생성은 선택사항입니다 Model에 모델과 비즈니스 로직을 짜도 상관없습니다.
/// 단 기능별 폴더에 ViewModel도 넣으면 관리하거나 보기는 좋을 것 같습니다.

@Observable
class CategoryViewModel {
    var selectedCategoryIndex: Int = 0 {
        didSet {
            // 인덱스 유효성 검사
            if selectedCategoryIndex < 0 || selectedCategoryIndex >= categories.count {
                selectedCategoryIndex = oldValue
            }
        }
    }
    var categories: [Category] = []
    
    var modelContext: ModelContext?
    
    init() {
        setupInitialData()
    }
    
    func setupInitialData() {
        // 기본 카테고리와 태그 데이터 설정
        let techTags = [
            ChildCategory(name: "컴퓨터과학"),
            ChildCategory(name: "네트워크"),
            ChildCategory(name: "보안"),
            ChildCategory(name: "인프라"),
            ChildCategory(name: "소프트웨어 공학")
        ]
        
        let programmingTags = [
            ChildCategory(name: "Swift"),
            ChildCategory(name: "C++"),
            ChildCategory(name: "Python"),
            ChildCategory(name: "Java"),
            ChildCategory(name: "JavaScript"),
            ChildCategory(name: "React")
        ]
        
        let selfDevTags = [
            ChildCategory(name: "코딩테스트"),
            ChildCategory(name: "면접"),
            ChildCategory(name: "사이드프로젝트")
        ]
        
        let etcTags = [
            ChildCategory(name: "IDEA"),
            ChildCategory(name: "디자인"),
            ChildCategory(name: "Product"),
            ChildCategory(name: "UIUX")
        ]
        
        categories = [
            Category(title: "기술", tags: techTags),
            Category(title: "프로그래밍", tags: programmingTags),
            Category(title: "자기계발", tags: selfDevTags),
            Category(title: "기타", tags: etcTags)
        ]
    }
    
    func saveData() {
        guard let modelContext = modelContext else { return }
        
        // 기존 데이터 모두 삭제 시도 (실패해도 계속 진행)
        do {
            let descriptor = FetchDescriptor<Category>()
            let existingCategories = try modelContext.fetch(descriptor)
            
            for category in existingCategories {
                modelContext.delete(category)
            }
            
            // 새 데이터 저장
            for category in categories {
                modelContext.insert(category)
            }
            
            try modelContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func loadData() {
        guard let modelContext = modelContext else { 
            setupInitialData() // modelContext가 없으면 메모리에라도 초기 데이터 설정
            return 
        }
        
        do {
            let descriptor = FetchDescriptor<Category>()
            let fetchedCategories = try modelContext.fetch(descriptor)
            
            if !fetchedCategories.isEmpty {
                categories = fetchedCategories
                // 카테고리가 로드된 후 인덱스 유효성 확인
                if selectedCategoryIndex >= categories.count {
                    selectedCategoryIndex = 0
                }
            } else {
                // 데이터가 없으면 초기 데이터 설정
                setupInitialData()
                try? saveData() // 저장 시도 (오류 무시)
            }
        } catch {
            print("Error fetching data: \(error)")
            // 오류 발생 시 메모리에라도 초기 데이터 설정
            setupInitialData()
        }
    }
    
    func toggleTagSelection(tagIndex: Int) {
        guard let currentCategory = safeCurrentCategory,
              tagIndex >= 0, tagIndex < currentCategory.tags.count else {
            return // 안전하게 인덱스 검사
        }
        
        currentCategory.tags[tagIndex].isSelected.toggle()
    }
    
    // 안전하게 현재 카테고리 접근
    var safeCurrentCategory: Category? {
        guard !categories.isEmpty,
              selectedCategoryIndex >= 0,
              selectedCategoryIndex < categories.count else {
            return nil
        }
        return categories[selectedCategoryIndex]
    }
    
    var currentCategory: Category {
        return safeCurrentCategory ?? Category(title: "")
    }
}
