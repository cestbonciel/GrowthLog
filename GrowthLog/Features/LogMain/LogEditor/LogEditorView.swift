//
//  LogEditorView.swift
//  GrowthLog
//
//  Created by Seohyun Kim on 5/12/25.
//

import SwiftUI

// MARK: - 개발회고 작성화면
struct LogEditorView: View {
    let logMainData: LogItem?
    
    var body: some View {
        if logMainData != nil {
            
        } else {
            VStack(alignment: .leading, spacing: 30) {
                Text("개발 회고 작성하는 공간입니다.")
                    .multilineTextAlignment(.center)
                VStack(spacing: 20) {
                    TextField("Keep", text: .constant(""))
                    TextField("Problem", text: .constant(""))
                    TextField("Try", text: .constant(""))
                }
            }
            .padding(
                EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
            )
            .navigationTitle("등록 / 수정")
        }
        
        Spacer()
    }
}

#Preview {
    LogEditorView(logMainData: nil)
}
