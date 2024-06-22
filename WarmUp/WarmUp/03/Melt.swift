//
//  Melt.swift
//  WarmUp
//
//  Created by 장석우 on 6/23/24.
//

import SwiftUI

struct Melt: View {
    @State var showOnboarding = false
    var body: some View {
        TabView {
            TabDetail1()
                .tabItem {
                    Label("홈", systemImage: "house")
                }.tag(1)
            
            TabDetail2()
                .badge(1)
                .tabItem {
                    Label("커스텀", systemImage: "paintbrush")
                }.tag(2)
            
            
            TabDetail3()
                .badge("오마갓")
                .tabItem {
                    Label("마이", systemImage: "person")
                }.tag(2)
        }
        .onAppear {
            showOnboarding = true
        }
        .sheet(isPresented: $showOnboarding) {
            TabView {
                OnboardingView(title: "우린 이런 서비스에요",
                               showModal: $showOnboarding,
                               isLast: false)
                
                OnboardingView(title: "이런 기능도 사용할 수 있어요",
                               showModal: $showOnboarding,
                               isLast: false)
                OnboardingView(title: "함께 해보실래요?",
                               showModal: $showOnboarding,
                               isLast: true)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}

#Preview {
    Melt()
}
