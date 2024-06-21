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
    
    @State var name: String = ""
    
    @State var fruits = [
        Fruit(name: "Apple", price: 1000),
        Fruit(name: "Banana", price: 1500),
        Fruit(name: "Cherry", price: 1400),
        Fruit(name: "Durian", price: 1500),
        Fruit(name: "Elder Berry", price: 1300)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("과일 이름 입력", text: $name)
                    Button {
                        fruits.append(.init(name: self.name, price: 1000))
                    } label: {
                        Text("추가")
                            .padding()
                            .foregroundStyle(.white)
                            .background(.blue)
                            .clipShape(.buttonBorder)
                    }
                }
                .padding()
                
                List {
                    ForEach(fruits, id: \.self) { f in
                        HStack {
                            Text(f.name)
                            Spacer()
                            Text(String(f.price))
                        }
                    }.onDelete { indexSet in
                        fruits.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Fruit Test")
            
        }
        
        
    }
}

#Preview {
    ListLoop()
}
