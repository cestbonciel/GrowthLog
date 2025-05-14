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
        "Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma – which is living with the results of other people’s thinking.",
        "Don’t let the noise of other’s opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition.",
        "They somehow already know what you truly want to become. Everything else is secondary."
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
                                .multilineTextAlignment(.center)
                                .font(.body)
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
