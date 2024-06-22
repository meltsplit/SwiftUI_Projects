//
//  TabDetail.swift
//  WarmUp
//
//  Created by 장석우 on 6/23/24.
//

import SwiftUI

struct TabDetail1: View {
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            Text("1")
        }
    }
}

struct TabDetail2: View {
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            Text("2")
        }
    }
}

struct TabDetail3: View {
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            Text("3")
        }
    }
}
#Preview {
    TabDetail1()
}
