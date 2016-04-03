//
//  Todo.swift
//  todo-app
//
//  Created by liusy182 on 2/4/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import Foundation

struct Todo: Equatable {
    let description: String
    let list: List
    let dueDate: NSDate
    let done: Bool
    let doneDate: NSDate?
}

func ==(todo1: Todo, todo2: Todo) -> Bool {
    return todo1.description == todo2.description
        && todo1.dueDate == todo2.dueDate
}

struct List: Equatable {
    let description: String
}

func ==(list1: List, list2: List) -> Bool {
    return list1.description == list2.description
}
