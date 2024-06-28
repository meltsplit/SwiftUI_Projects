//
//  MemoViewModel.swift
//  ClovaNote
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

class MemoViewModel: ObservableObject {
    
  @Published var memo: Memo
    
  init(memo: Memo) {
        self.memo = memo
    }
    
}
