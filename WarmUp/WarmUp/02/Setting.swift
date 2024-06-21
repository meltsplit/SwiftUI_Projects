//
//  Setting.swift
//  WarmUp
//
//  Created by 장석우 on 6/22/24.
//

import SwiftUI

struct SettingInfo: Hashable {
    let systemName: String
    let title: String
    let backgroundColor: Color
    let foregoundColor: Color
}
struct Setting: View {
    
    @State var data: [SettingInfo] = [
        SettingInfo(systemName: "person",
                    title: "스크린타임",
                    backgroundColor: .purple,
                    foregoundColor: .white)
    ]
    
    @State var data2: [SettingInfo] = [
        SettingInfo(systemName: "person",
                    title: "일반",
                    backgroundColor: .gray,
                    foregoundColor: .white),
        SettingInfo(systemName: "person",
                    title: "일반",
                    backgroundColor: .blue,
                    foregoundColor: .white),
        SettingInfo(systemName: "person",
                    title: "일반",
                    backgroundColor: .blue,
                    foregoundColor: .white)
    ]
    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                    ForEach(data, id: \.self) { d in
                        Label {
                            Text(d.title)
                        } icon: {
                            Image(systemName: d.systemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .padding(.all, 7)
                                .foregroundStyle(d.foregoundColor)
                                .background(d.backgroundColor)
                                .clipShape(.buttonBorder)
                            
                        }
                    }
                    
                }
                
                Section {
                    
                    ForEach(data2, id: \.self) { d in
                        Label {
                            Text(d.title)
                        } icon: {
                            Image(systemName: d.systemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .padding(.all, 7)
                                .foregroundStyle(d.foregoundColor)
                                .background(d.backgroundColor)
                                .clipShape(.buttonBorder)
                            
                        }
                    }
                    
                }
            }
            .navigationTitle("설정")
        }
    }
}

#Preview {
    Setting()
}
