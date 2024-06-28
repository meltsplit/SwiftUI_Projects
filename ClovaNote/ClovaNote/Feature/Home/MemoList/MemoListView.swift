//
//  MemoListView.swift
//  ClovaNote
//
//  Created by 장석우 on 6/28/24.
//

import SwiftUI

struct MemoListView: View {
  
  @EnvironmentObject private var viewModel: MemoListViewModel
  @EnvironmentObject private var pathModel: PathModel
  
  var body: some View {
    
    ZStack {
      VStack {
        if !viewModel.memos.isEmpty {
          ClovaNavigationBar(
            isDisplayLeftButton: false,
            rightButtonAction: { viewModel.navigationRightButtonDidTap() },
            rightButtonType: viewModel.navigationBarRightButtonMode
          )
        } else {
          Spacer()
            .frame(height: 30)
        }
        
        MemoTitleView()
        
        if viewModel.memos.isEmpty {
          MemoGuideView()
            .frame(alignment: .center)
        } else {
          MemoListContentView()
        }
        
        
        Spacer()
        
      }
      
      WriteMemoButtonView()
      
    }
    .alert("\(viewModel.willRemoveMemos.count)개의 메모를 삭제하시겠습니까?",
           isPresented: $viewModel.showDeleteAlert, actions: {
      Button("삭제", role: .destructive) { viewModel.removeSelectedMomos()}
      Button("취소", role: .cancel) { }
    })
    
  }
}

private struct MemoTitleView: View {
  @EnvironmentObject private var viewModel : MemoListViewModel
  fileprivate var body: some View {
    HStack {
      Text(viewModel.memos.isEmpty
           ? "메모를\n추가해보세요"
           : "메모 \(viewModel.memos.count)개가\n있습니다")
      .font(.system(size: 26, weight: .bold))
      Spacer()
    }
    .padding(.horizontal, 30)
    .padding(.top, 39)
  }
}

private struct MemoGuideView: View {
  fileprivate var body: some View {
    VStack(spacing: 5) {
      Spacer()
      Image(systemName: "pencil")
      Text("\"이건 설명이에요\"")
      Text("\"메모를 추가해보세요\"")
      
      Spacer()
    }
    .font(.system(size: 14))
    .foregroundStyle(.gray2)
    
    
  }
}

private struct MemoListContentView: View {
  
  @EnvironmentObject private var viewModel: MemoListViewModel
  
  fileprivate var body: some View {
    VStack {
      HStack {
        Text("메모 목록")
        Spacer()
      }
      .font(.system(size: 18, weight: .bold))
      .padding(.horizontal, 30)
      .padding(.bottom, 10)
      
      ScrollView {
        
        VStack {
          ForEach(viewModel.memos, id: \.id) { memo in
            MemoCellView(memo: memo)
          }
        }
      }
    }
    .padding(.top)
    
  }
}


private struct MemoCellView: View {
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var viewModel: MemoListViewModel
  @State private var isSelected: Bool
  private var memo: Memo
  
  
  init(
    memo: Memo,
    isSelected: Bool = false
  ) {
    self.memo = memo
    self._isSelected = State(initialValue: isSelected)
  }
  
  fileprivate var body: some View {
    Button(
      action: {
        pathModel.paths.append(.memo(isCreateModel: false, memo: memo))
      },
      label: {
        VStack {
          Divider()
          
          HStack {
            VStack(alignment: .leading, spacing: 5) {
              
              Text(memo.title)
                .font(.system(size: 16))
                .lineLimit(1)
              
              Text(
                memo.date.formattedDay
                + " - "
                + memo.date.formattedTime
              )
              .font(.system(size: 12))
              .foregroundStyle(.gray2)
            }
            Spacer()
            
            if viewModel.isEditMode {
              Button(
                action: {
                  isSelected.toggle()
                  viewModel.cellRemoveButtonDidSelected(memo)
                },
                label: {
                  Image(isSelected
                        ? .checkOn
                        : .check)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 25, height: 25)
                }
              )
            }
          }
          .padding(.horizontal, 30)
          .padding(.vertical, 24)
        }
        
      })
  }
}

private struct WriteMemoButtonView: View {
  @EnvironmentObject private var pathModel: PathModel
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Spacer()
        
        Button(
          action: {
            pathModel.paths.append(.memo(isCreateModel: true, memo: nil))
          },
          label: {
            Image(.writeBtn)
              .resizable()
              .scaledToFit()
              .frame(width: 50, height: 50)
          }
        )
      }
      .padding(.trailing, 30)
    }.padding(.bottom, 39)
  }
}

#Preview {
  MemoListView()
    .environmentObject(MemoListViewModel(
      memos : []
    ))
    .environmentObject(PathModel())
}
