//
//  TodoDataStore.swift
//  todo-app
//
//  Created by liusy182 on 2/4/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import Foundation

class TodosDatastore {
    private var savedLists = [List]()
    private var savedTodos = [Todo]()
    
    init(){
        savedLists = [
            List(description: "Work"),
            List(description: "Family")
        ]
        
        savedTodos = [
            Todo(description: "Remember the Milk",
                list: List(description: "Family") ,
                dueDate: NSDate(),
                done: false,
                doneDate: nil),
            Todo(description: "Buy Spider Man Comics",
                list: List(description: "Personal") ,
                dueDate: NSDate(),
                done: true,
                doneDate: NSDate()
            ),
            Todo(description: "Release build",
                list: List(description: "Work") ,
                dueDate: NSDate(),
                done: false,
                doneDate: nil)
        ]
    }
    
    func todos() -> [Todo] {
        return savedTodos
    }
    
    func lists() -> [List] {
        return [defaultList()] + savedLists
    }
}

// MARK: Actions
extension TodosDatastore {
    func addTodo(todo: Todo) {
        savedTodos = savedTodos + [todo]
    }
    
    func deleteTodo(todo: Todo?) {
        if let todo = todo {
            savedTodos = savedTodos.filter({$0 != todo})
        }
    }
    
    func editTodo(oldTodo: Todo, newTodo: Todo) {
        deleteTodo(oldTodo)
        addTodo(newTodo)
    }
    
    func addListDescription(description: String) {
        if !description.isEmpty {
            savedLists = savedLists + [List(description: description)]
        }
    }
    
    func defaultList() -> List {
        return List(description: "Personal")
    }
    
    func defaultDueDate() -> NSDate {
        let now = NSDate()
        let secondsInADay = NSTimeInterval(24 * 60 * 60)
        return now.dateByAddingTimeInterval(secondsInADay)
    }
}


