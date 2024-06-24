//
//  TodoListViewModel.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveTodoAlert: Bool
    
    var removeTodosCount: Int {
        removeTodos.count
    }
    
    var navigationBarRightButtonMode: NavigationType {
        isEditMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditMode = isEditMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

extension TodoListViewModel {
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo}) {
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func navigationButtonDidTap() {
        if isEditMode {
            if removeTodos.isEmpty {
                isEditMode = false
            } else {
                setIsDisplayRemoveTodoAlert(true)
            }
        } else {
            isEditMode = true
        }
    }
    
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    func todoRemoveSelectedBoxDidTap(_ todo: Todo) {
        if let index = removeTodos.firstIndex(where: { $0 == todo }) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    func removeButtonDidTap() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
            
        }
        removeTodos.removeAll()
        isEditMode = false
    }
}
