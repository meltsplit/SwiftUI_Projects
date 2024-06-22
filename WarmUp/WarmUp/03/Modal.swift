//
//  Modal.swift
//  WarmUp
//
//  Created by 장석우 on 6/23/24.
//

import SwiftUI

struct Modal: View {
    
    @State var showModal = false
    
    var body: some View {
        VStack {
            Text("메인 페이지 입니다")
            Button {
                showModal.toggle()
            } label: {
                Text("Modal 화면 전환")
            }
        }
        .sheet(isPresented: $showModal) {
            Detail(showModal: $showModal)
        }
            
    }
}

#Preview {
    Modal()
}
