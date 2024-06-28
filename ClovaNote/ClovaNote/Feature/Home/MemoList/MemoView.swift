//
//  MemoView.swift
//  ClovaNote
//
//  Created by 장석우 on 6/28/24.
//

import SwiftUI

struct MemoView: View {
  
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  @StateObject var viewModel: MemoViewModel
  @State var isCreateMode: Bool
  
  var body: some View {
    ZStack {
      VStack {
        ClovaNavigationBar(
          leftButtonAction: { pathModel.paths.removeLast() },
          rightButtonAction: {
            isCreateMode
            ? memoListViewModel.addMemo(viewModel.memo)
            : memoListViewModel.updateMemo(viewModel.memo)
            pathModel.paths.removeLast()
          },
          rightButtonType:
            isCreateMode ? .create : .complete
        )
        
        MemoTitleInputView(
          viewModel: viewModel,
          isCreateMode: $isCreateMode
        )
        .padding(.top, 20)
        
        MemoContentInputView(viewModel: viewModel)
          .padding(.top, 10)
        
        
        
        // 타이틀 인풋뷰
        // 컨텐츠 인풋뷰
        // 삭제 플로팅 버튼 뷰
      }
      
      if !isCreateMode {
        MemoDeleteView(viewModel: viewModel)
          .padding(.trailing, 20)
          .padding(.bottom, 10)
      }
      
      
    }
  }
}

private struct MemoTitleInputView: View {
  
  @ObservedObject private var viewModel: MemoViewModel
  @FocusState private var isTitlefieldFouced: Bool
  @Binding private var isCreateMode: Bool
  
  fileprivate init(
    viewModel: MemoViewModel,
    isCreateMode: Binding<Bool>
  ) {
    self.viewModel = viewModel
    self._isCreateMode = isCreateMode
  }
  
  fileprivate var body: some View {
    TextField("제목 입력해주세요",
              text: $viewModel.memo.title)
    .font(.system(size: 30))
    .padding(.horizontal, 30)
    .focused($isTitlefieldFouced)
    .onAppear {
      if isCreateMode {
        isTitlefieldFouced = true
      }
    }
  }
}

private struct MemoContentInputView: View {
  
  @ObservedObject private var viewModel: MemoViewModel
  
  fileprivate init(
    viewModel: MemoViewModel
  ) {
    self.viewModel = viewModel
  }
  
  fileprivate var body: some View {
    ZStack(alignment: .topLeading) {
      TextEditor(text: $viewModel.memo.content)
        .font(.system(size: 20))
      
      if viewModel.memo.content.isEmpty {
        Text("메모를 입력하세요.")
          .font(.system(size: 16))
          .foregroundStyle(.gray1)
          .allowsHitTesting(false)
          .padding(.top, 10)
          .padding(.leading, 5)
      }
    }
    .padding(.horizontal, 20)
    
  }
}

//MARK: - Memo 삭제 버튼 뷰

private struct MemoDeleteView: View {
  
  @EnvironmentObject private var pathModel : PathModel
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  @ObservedObject private var viewModel: MemoViewModel
  
  
  fileprivate init(viewModel: MemoViewModel) {
    self.viewModel = viewModel
  }
  
  fileprivate var body: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Button(
          action: {
            memoListViewModel.removeMemo(viewModel.memo)
            pathModel.paths.removeLast()
          },
          label: {
            Image(systemName: "trash")
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
          })
      }
    }
    
  }
}



#Preview {
  MemoView(viewModel:
      .init(memo:
          .init(
            title: "제목이다",
            content: "콘첸츠다",
            date: Date())
      ), isCreateMode: true
  )
  .environmentObject(PathModel())
  .environmentObject(MemoListViewModel())
}
