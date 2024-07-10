//
//  TodoListView.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import SwiftUI

struct TodoListView: View {
  
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var viewModel: TodoListViewModel
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  var body: some View {
    
    //투두 리스트
    VStack {
      if !viewModel.todos.isEmpty {
        ClovaNavigationBar(
          isDisplayLeftButton: false,
          rightButtonAction: { viewModel.navigationButtonDidTap() },
          rightButtonType: viewModel.navigationBarRightButtonMode
          
        )
      } else {
        Spacer()
          .frame(height: 30)
      }
      
      
      TitleView()
        .padding(.top, 20)
      
      if viewModel.todos.isEmpty {
        GuideView()
        
      } else {
        TodoListContentView()
          .padding(.bottom, 20)
      }
    }
    .writeButton {
      pathModel.paths.append(.todo)
    }
//    .modifier(WriteButtonViewModifier(action: { pathModel.paths.append(.todo)}))
    .alert(
      "삭제하시겠습니까?",
      isPresented: $viewModel.isDisplayRemoveTodoAlert
    ) {
      Button("삭제", role: .destructive) { viewModel.removeButtonDidTap()}
      Button("취소", role: .cancel) { }
    }
    .onChange(of: viewModel.todos.count) { _, newValue in
      homeViewModel.setTodosCount(newValue)
    }
    
  }
  
}

private struct TitleView: View {
  @EnvironmentObject private var viewModel: TodoListViewModel
  fileprivate var body: some View {
    HStack {
      if viewModel.todos.isEmpty {
        Text("To do List를\n추가해보세요.")
      } else {
        Text("\(viewModel.todos.count)개가 있습니다.")
      }
      
      Spacer()
      
      
    }
    .font(.system(size: 30, weight: .bold))
    .padding(.leading, 20)
    
  }
}

//MARK: - Todo 안내뷰
private struct GuideView: View {
  
  fileprivate var body: some View {
    VStack(spacing: 15) {
      Spacer()
      Image("pencil")
        .renderingMode(.template)
      Text("\"내일 아침 러닝하자\"")
      Text("\"강의 꼭 듣자\"")
      Text("\"점심약속 가자\"")
      
      Spacer()
    }
    .font(.system(size: 16))
    .foregroundStyle(.gray2)
  }
}

//MARK: - Todo 컨텐츠 뷰
private struct TodoListContentView: View {
  @EnvironmentObject private var viewModel: TodoListViewModel
  
  fileprivate var body: some View {
    VStack {
      HStack {
        Text("할일 목록")
          .font(.system(size: 16, weight: .bold))
          .padding(.leading, 20)
        Spacer()
      }
      
      ScrollView(.vertical) {
        VStack(spacing: 0) {
          Rectangle()
            .fill(.gray0)
            .frame(height: 1)
          
          ForEach(viewModel.todos, id: \.self) { todo in
            TodoCellView(todo: todo)
            
          }
        }
      }
    }
  }
}

private struct TodoCellView: View {
  @EnvironmentObject private var viewModel: TodoListViewModel
  @State private var isRemoveSelected: Bool
  private var todo: Todo
  
  fileprivate init(
    isRemoveSelected: Bool = false,
    todo: Todo
  ) {
    _isRemoveSelected = State(initialValue: isRemoveSelected)
    self.todo = todo
  }
  
  fileprivate var body: some View {
    VStack(spacing: 20) {
      HStack {
        // 좌측 선택 버튼
        if !viewModel.isEditMode {
          Button(
            action: { viewModel.selectedBoxTapped(todo) },
            label: {
              todo.selected
              ? Image(.checkOn)
              : Image(.check)
            })
          
        }
        
        // 내용
        VStack(alignment: .leading, spacing: 5) {
          Text(todo.title)
            .font(.system(size: 16))
            .foregroundStyle(todo.selected ? .iconOn : .black)
            .strikethrough(todo.selected ? true : false)
          
          Text(todo.convertedDayAndTime)
            .font(.system(size: 16))
            .foregroundStyle(.iconOn)
          
        }
        
        Spacer()
        
        // 우측 삭제 버튼
        if viewModel.isEditMode {
          Button(
            action: {
              isRemoveSelected.toggle()
              viewModel.todoRemoveSelectedBoxDidTap(todo)
            },
            label: {
              isRemoveSelected
              ? Image(.checkOn)
              : Image(.check)
            }
          )
        }
        
        
        
      }
      .padding(.horizontal, 20)
      .padding(.top, 10)
      
      Rectangle()
        .fill(.gray0)
        .frame(height: 1)
      
    }
  }
}

//MARK: - Todo 작성버튼 뷰 -> Modifier로 수정함
//
//private struct WriteTodoButtonView: View {
//  @EnvironmentObject private var pathModel: PathModel
//
//  fileprivate var body: some View {
//    VStack {
//      Spacer()
//      HStack {
//        Spacer()
//
//        Button(
//          action: {
//            pathModel.paths.append(.todo)
//          },
//          label: {
//            Image(.writeBtn)
//          }
//        )
//      }
//    }
//  }
//}

#Preview {
  TodoListView()
    .environmentObject(PathModel())
    .environmentObject(TodoListViewModel())
    .environmentObject(HomeViewModel())
}
