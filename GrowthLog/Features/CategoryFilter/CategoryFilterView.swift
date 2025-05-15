//
//  CategoryFilterView.swift
//  GrowthLog
//
//  Created by 백현진 on 5/12/25.
//

import SwiftUI
import SwiftData

struct CategoryFilterView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    //카테고리 필터 뷰모델을 SearchFilterView에서 생성했음.
    @ObservedObject var viewModel: CategoryFilterViewModel
    @Binding var selectedTags: [ChildCategoryType]

    @Environment(\.dismiss) private var dismiss

    @State private var showLimitAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {

                if !viewModel.selectedTags.isEmpty {
                    SelectedTagsHeaderView(
                        tags: viewModel.selectedTags,
                        onClear: viewModel.clearSelections
                    )
                }

                VStack(alignment: .leading, spacing: 24) {
                    ForEach(viewModel.categories) { category in
                        CategorySectionView(
                            showLimitAlert: $showLimitAlert, category: category,
                            viewModel: viewModel
                        )
                    }

                    Button("적용하기") {
                        print("선택된 태그:", viewModel.selectedTags.map { $0.name })

                        selectedTags = viewModel.selectedTags.map(\.type)
                        dismiss()
                    }

                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .bold()
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                }
                .padding(.vertical, 20)
            }
            .padding(.vertical, 20)
            .navigationTitle("카테고리 필터")
            .navigationBarTitleDisplayMode(.inline)
            .alert("태그는 최대 3개까지만 선택할 수 있습니다.", isPresented: $showLimitAlert) {
                Button("확인", role: .cancel) { }
            }
        }
    }
}


//카테고리 및 상단 태그 매칭
private struct SelectedTagsHeaderView: View {
    let tags: [ChildCategory]
    let onClear: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag.name)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        //.bold()
                        .background(Color.green)
                        .foregroundColor(tag.isSelected ? .black : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
        }
        .overlay(alignment: .trailing) {
            Button(action: onClear) {
                Image(systemName: "x.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray)
                    .padding()
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray.opacity(0.6), lineWidth: 1)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        }
        .padding(.top, 60)
        .padding(.horizontal, 10)
    }
}

//태그 ScrollView
private struct CategorySectionView: View {
    @Binding var showLimitAlert: Bool

    let category: Category
    @ObservedObject var viewModel: CategoryFilterViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(category.title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(category.tags) { tag in
                        Button {
                            if tag.isSelected || viewModel.selectedTags.count < 3 {
                                viewModel.toggleSelection(for: tag)
                            } else {
                                showLimitAlert = true
                            }
                        } label: {
                            Text(tag.name)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .font(.footnote)
                                .background(tag.isSelected ? Color.green : Color.gray.opacity(0.2))
                                .foregroundColor(tag.isSelected ? .black : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)

            Rectangle()
                .fill(.gray.opacity(0.4))
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
    }
}



struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}





#Preview {
    StatefulPreviewWrapper([ChildCategoryType.swift]) { binding in
    	CategoryFilterView(viewModel: CategoryFilterViewModel(), selectedTags: binding)
    }
}
