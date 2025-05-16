//
//  OnboardingView.swift
//  GrowthLog
//
//  Created by 백현진 on 5/15/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var currentPage = 0

    let pages = [
        "[ 반갑습니다 ]\n\nGrowthLog는 오늘의 배움과\n고민을 기록하는 공간입니다.\nKeep, Problem, Try로\n오늘을 구조화할 수 있어요.",
        " [ 필터링 ]\n\n카테고리와 태그로 회고를 정리하고,\n필터와 검색으로 필요한 회고를 빠르게 찾으세요.",
        "[ 내 성장의 흐름을 통계로 ]\n\n회고 빈도와 키워드를 그래프로 확인하며\n나의 성장 패턴을 한눈에 파악하세요.",
        "[ 지금, 시작하세요 ]\n\n기록하는 습관이 성장의 곡선을 만듭니다.\n오늘 첫 회고를 써보세요."
    ]

    let images = ["detail", "filter", "statics", "enroll"]

    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    if isPad {
                        // 아이패드 전용: 가로 레이아웃
                        HStack(spacing: 32) {
                            Image(images[index])
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                                .padding()

                            Spacer()

                            VStack(spacing: 24) {
                                Text(pages[index])
                                    .font(.title)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()


                            }
                            .padding(.vertical, 40)
                            .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .tag(index)
                    } else {
                        // 아이폰: 기존 세로 레이아웃
                        VStack {
                            Image(images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400)
                                .clipped()

                            Rectangle()
                                .fill(.gray.opacity(0.4))
                                .frame(height: 1)

                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.clear)


                                Text(pages[index])
                                    .multilineTextAlignment(.center)
                                    .font(.body)
                                    .bold()
                                    .padding()
                            }
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)

                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)

            // ✅ 버튼은 공통
            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    hasSeenOnboarding = true
                }
            }) {
                Text(currentPage < pages.count - 1 ? "다음" : "시작하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.black)
                    .bold()
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
    }
}



#Preview {
    OnboardingView()
}
