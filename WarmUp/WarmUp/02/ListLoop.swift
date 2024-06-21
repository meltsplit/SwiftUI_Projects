//
//  ListLoop.swift
//  WarmUp
//
//  Created by 장석우 on 6/22/24.
//

import SwiftUI

struct Fruit: Hashable {
    let name: String
    let price: Int
}

struct ListLoop: View {
    
    var fruits = [
        Fruit(name: "Apple", price: 1000),
        Fruit(name: "Banana", price: 1500),
        Fruit(name: "Cherry", price: 1400),
        Fruit(name: "Durian", price: 1500),
        Fruit(name: "Elder Berry", price: 1300)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fruits, id: \.self) { f in
                    HStack {
                        Text(f.name)
                        Spacer()
                        Text(String(f.price))
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
