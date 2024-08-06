//
//  RecentSearchView.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import SwiftUI

struct RecentSearchView: View {
  @Environment(\.managedObjectContext) var objectContext
  @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var results: FetchedResults<SearchResult>
  
  var body: some View {
    VStack {
      titleView
        .padding(.bottom, 20)
      
      if results.isEmpty {
        Text("검색 내역이 없읍니다.")
          .padding(.vertical, 54)
      } else {
        listView
      }
      
      
    }
    .padding(.horizontal, 20)
  }
  
  var titleView: some View {
    HStack {
      Text("최근 검색어")
        .font(.system(size: 16, weight: .semibold))
      Spacer()
    }
  }
  
  var listView: some View {
    ScrollView {
      LazyVStack {
        ForEach(results, id: \.self) { result in
          HStack {
            Text(result.name ?? "" )
              .font(.system(size: 14))
            Spacer()
            Button {
              objectContext.delete(result)
              try? objectContext.save()
            } label: {
              Image(systemName: "xmark")
            }
          }
          
        }
      }
    }
  }
}

#Preview {
  RecentSearchView()
}
