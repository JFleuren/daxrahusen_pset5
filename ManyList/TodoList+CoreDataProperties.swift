//
//  TodoList+CoreDataProperties.swift
//  
//
//  Created by Dax Rahusen on 29/11/2016.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList");
    }

    @NSManaged public var title: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var finished: Bool
    @NSManaged public var id: String?
    @NSManaged public var toDoItem: NSSet?

}

// MARK: Generated accessors for toDoItem
extension TodoList {

    @objc(addToDoItemObject:)
    @NSManaged public func addToToDoItem(_ value: TodoItem)

    @objc(removeToDoItemObject:)
    @NSManaged public func removeFromToDoItem(_ value: TodoItem)

    @objc(addToDoItem:)
    @NSManaged public func addToToDoItem(_ values: NSSet)

    @objc(removeToDoItem:)
    @NSManaged public func removeFromToDoItem(_ values: NSSet)

}
