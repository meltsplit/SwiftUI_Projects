//
//  Detail.swift
//  WarmUp
//
//  Created by 장석우 on 6/23/24.
//

import SwiftUI

struct Detail: View {
    @Binding var showModal: Bool
    var body: some View {
        Text("모달 페이지 입니다")
        Button {
            showModal = false
        } label: {
            Text("화면 닫기")
        }
    }
}

#Preview {
    Detail(showModal: .constant(true))
}
