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
            """
            [개발자의 성장, 기록에서 시작됩니다]\n
            ✍️ 작은 회고가 쌓여, 큰 성장을 만듭니다
            개발자라면 누구나 겪는 문제와 해결, 오늘의 배움들을 놓치지 마세요.
            GrowthLog는 그런 하루를 차곡차곡 담아두는 공간입니다.
            """,

            """
            [KPT 회고, 쉽고 체계적으로]\n
            📂 카테고리와 태그를 이용해 회고를 명확하게 분류하세요.
            기본 문법, 사이드 프로젝트, 인터뷰 준비 등 어떤 주제든
            명확하게 Keep, Problem, Try로 하루를 정리할 수 있어요.
            """,

            """
            [내 성장의 흐름을 통계로 확인하세요]\n
            📊 얼마나 성장했는지 그래프로 직관적으로 확인
            회고 빈도, 주요 주제, 자주 등장하는 키워드까지 한 눈에 볼 수 있어요.
            """,

            """
            [지금, 나만의 성장 로그를 시작해보세요]\n
            🚀 기록하는 습관이 만드는 성장 곡선
            지금 첫 회고를 작성하고, 당신만의 개발 여정을 시작해보세요.
            """
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 24) {


                        Image("apple")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 400)
                            .background(.gray.opacity(0.1))

                        Rectangle()
                            .fill(.gray.opacity(0.4))
                            .frame(height: 1)


                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.3))

                            Text(pages[index])
                                .multilineTextAlignment(.leading)
                                .font(.caption)
                                .padding(.horizontal)

                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)


                        Spacer()


                    }
                    .tag(index)
                    .frame(maxWidth: .infinity)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            //.tabViewStyle(.page)


            // ✅ SwiftUI 기본 페이지 인디케이터
            .animation(.easeInOut, value: currentPage)

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
        .padding(0)
    }
}

#Preview {
    OnboardingView()
}
