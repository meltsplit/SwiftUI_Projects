//
//  TodoView.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            ClovaNavigationBar(
                leftButtonAction: {
                    pathModel.paths.removeLast()
                },
                rightButtonAction: {
                    todoListViewModel.addTodo(
                        .init(
                            title: viewModel.title,
                            time: viewModel.time,
                            day: viewModel.day,
                            selected: false)
                    )
                    
                    pathModel.paths.removeLast()
                    
                },
                rightButtonType: .create
            )
            
            TitleView()
                .padding(.top, 20)
            
            TodoTitleView(viewModel: viewModel)
                .padding(.vertical, 20)
            
            SelectTimeView(viewModel: viewModel)
                .padding(.vertical, 20)
            
            SelectDayView(viewModel: viewModel)
                .padding(.vertical, 20)
            
            Spacer()
            
            
        }
        
    }
}

private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("To do list를\n추가해 보세요.")
                .font(.system(size: 26))
                .bold()
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

private struct TodoTitleView: View {
    
    @ObservedObject private var viewModel: TodoViewModel
    
    fileprivate init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력해보세요", text: $viewModel.title)
            .padding(.horizontal, 20)
        
    }
}

private struct SelectTimeView: View {
    
    @ObservedObject private var viewModel: TodoViewModel
    
    fileprivate init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Divider()
            DatePicker(
                "",
                selection: $viewModel.time,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(.wheel)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Divider()
        }
    }
}

private struct SelectDayView: View {
    
    @ObservedObject private var viewModel: TodoViewModel
    
    fileprivate init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("날짜")
                    .font(.system(size: 16))
                    .foregroundStyle(.iconOn)
                    .padding(.bottom, 5)
                
                Spacer()
            }
            
            HStack {
                Button(action: {viewModel.setIsDisplayCalender(true)}, label: {
                    Text(viewModel.day.formattedDay)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.key)
                })
                .popover(isPresented: $viewModel.isDisplayCalender) {
                    DatePicker(
                        "",
                        selection: $viewModel.day,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .onChange(of: viewModel.day) { oldValue, newValue in
                        viewModel.setIsDisplayCalender(false)
                    }
                    Spacer()
                    
                }
                
                Spacer()
                
            }
            
            
            
        }
        .padding(.horizontal, 20)
    }
}


#Preview {
    TodoView()
}
