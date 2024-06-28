//
//  MemoListViewModel.swift
//  ClovaNote
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

class MemoListViewModel: ObservableObject {
  @Published var memos: [Memo]
  @Published var showDeleteAlert: Bool
  @Published var isEditMode: Bool
  
  var willRemoveMemos: [Memo]
  
  init(
    memos: [Memo] = [],
    showDeleteAlert: Bool = false,
    isEditMode: Bool = false,
    willRemoveMemos: [Memo] = []
  ) {
    self.memos = memos
    self.showDeleteAlert = showDeleteAlert
    self.isEditMode = isEditMode
    self.willRemoveMemos = willRemoveMemos
  }
  
  var navigationBarRightButtonMode: NavigationType {
    isEditMode ? .complete : .edit
  }
  
  
}

extension MemoListViewModel {
  func navigationRightButtonDidTap() {
    if isEditMode { // 완료 누른 경우
      if willRemoveMemos.isEmpty {
        isEditMode = false
      } else {
        showDeleteAlert = true
      }
    } else {
      isEditMode = true
    }
  }
  
  func cellRemoveButtonDidSelected(_ memo: Memo) {
    if let index = willRemoveMemos.firstIndex(of: memo) {
      willRemoveMemos.remove(at: index)
    } else {
      willRemoveMemos.append(memo)
    }
    
  }
  
  func addMemo(_ memo: Memo) {
    memos.append(memo)
  }
  
  func updateMemo(_ memo: Memo) {
    if let index = memos.firstIndex(where: { $0.id == memo.id }) {
      memos[index] = memo
    }
  }
  
  func removeMemo(_ memo: Memo) {
    if let index = memos.firstIndex(where: { $0.id == memo.id }) {
      memos.remove(at: index)
    }
  }
  
  func removeSelectedMomos() {
    memos.removeAll { memo in
      willRemoveMemos.contains(memo)
    }
    
    willRemoveMemos = []
    isEditMode = false
  }
  
  
}
