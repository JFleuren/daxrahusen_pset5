//
//  Constants.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import Foundation

struct SegueIdentifiers {
    static let detailSegue = "detailSegue"
}

struct CellIdentifiers {
    static let todoListCell = "todoListCell"
    static let todoItemCell = "todoItemCell"
}

struct CoreDataClasses {
    static let TODOLIST = "TodoList"
    static let TODOITEM = "TodoItem"
}

struct NotificationsIdentifiers {
    static let TEXTFIELDSTATE = Notification.Name("textFieldState")
    static let RELOADCONTROLLERSTATE = Notification.Name("ReloadControllerState")
}

struct ControllerIdentifiers {
    static let RootSplitViewController = "RootSplitViewController"
    static let MasterNavigationController = "MasterNavigationController"
    static let DetailNavigationController = "DetailNavigationController"
    static let ListTableViewController = "ListTableViewController"
    static let DetailViewController = "DetailViewController"
}

struct SaveStateIdentifiers {
    static let TextFieldStateKey = "TextFieldStateKey"
    static let ToDoListStateKey = "ToDoListStateKey"
}
