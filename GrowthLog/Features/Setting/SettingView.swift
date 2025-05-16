//
//  SettingView.swift
//  GrowthLog
//
//  Created by 백현진 on 5/15/25.
//

import SwiftUI

enum ThemeMode: String {
    case light
    case dark
    case system
}

struct SettingView: View {
    //온보딩
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = true
    //테마 모드
    @AppStorage("themeMode") var themeMode: String = ThemeMode.system.rawValue

    @State private var selectedFontSize = "기본"
    @State private var showNoneMailAlert = false

    var body: some View {
        NavigationStack {
            Form {
                // 테마모드
                Section(header: Text("화면 테마")) {
                    Picker("모드 선택", selection: $themeMode) {
                        Text("시스템 설정").tag(ThemeMode.system.rawValue)
                        Text("라이트 모드").tag(ThemeMode.light.rawValue)
                        Text("다크 모드").tag(ThemeMode.dark.rawValue)
                    }
                    .pickerStyle(.navigationLink)
                }


                // 회고 도움말
                Section(header: Text("도움말")) {
                    Button("GrowthLog 사용법") {
                        hasSeenOnboarding = false
                    }
                }


                // 앱 정보
                Section(header: Text("앱 정보")) {
                    HStack {
                        Text("버전")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")
                            .foregroundColor(.gray)
                    }
                    Button {
                        sendFeedbackEmail()
                    } label: {
                        Text("앱 피드백 보내기")
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationTitle("환경설정")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showNoneMailAlert) {
                Alert(
                    title: Text("메일 앱이 없습니다"),
                    message: Text("기기에 메일 앱이 설치되어있지 않습니다."),
                    dismissButton: .destructive(Text("확인"))
                )
            }
        }

    }


    private func sendFeedbackEmail() {
        let subject = "GrowthLog 피드백"
        let body = "여러분의 의견을 기다립니다."
        let email = "qorguswls00@gmail.com"

        if let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showNoneMailAlert = true
            }
        } else {
            showNoneMailAlert = true
        }

    }
}


#Preview {
    SettingView()
}
