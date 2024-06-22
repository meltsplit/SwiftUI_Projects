//
//  Navigation.swift
//  WarmUp
//
//  Created by 장석우 on 6/23/24.
//

import SwiftUI

struct Navigation: View {
    
    @State var showModal = false
    
    var body: some View {
        NavigationStack {
            
            List {
                NavigationLink {
                    Text("eptmxlspdltus dlqslek.")
                } label: {
                    Text("디테일뷰로 이동하기")
                }
                
                NavigationLink {
                    Text("eptmxlspdltus dlqslek.")
                } label: {
                    Text("디테일뷰로 이동하기")
                }
            }
            .navigationTitle("네비네비")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        showModal = true
                    } label: {
                        Text("Add")
                    }
                }
            }
            .padding(.vertical)
            .sheet(isPresented: $showModal) {
                Detail(showModal: $showModal)
            }
        }
    }
}

#Preview {
    Navigation()
}
