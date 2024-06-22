//
//  Tab.swift
//  WarmUp
//
//  Created by 장석우 on 6/23/24.
//

import SwiftUI

struct Tab: View {
    var body: some View {
        TabView(selection: .constant(1)) {
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
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
}

#Preview {
    Tab()
}
