//
//  ListLoop.swift
//  WarmUp
//
//  Created by 장석우 on 6/22/24.
//

import SwiftUI

struct ListLoop: View {
    
    var fruits = [
        "Apple",
        "Banana",
        "Cherry",
        "Durian",
        "Elder Berry"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fruits, id: \.self) { f in
                    HStack {
                        Text(f)
                    }
                }
            }
        }
        .navigationTitle("Fruit Test")
        
    }
}

#Preview {
    ListLoop()
}
