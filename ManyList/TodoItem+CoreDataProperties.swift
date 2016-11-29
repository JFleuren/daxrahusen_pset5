//
//  TodoItem+CoreDataProperties.swift
//  
//
//  Created by Dax Rahusen on 28/11/2016.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem");
    }

    @NSManaged public var backgroundcolor: String?
    @NSManaged public var duration: NSDate?
    @NSManaged public var finished: Bool
    @NSManaged public var inprogress: Bool
    @NSManaged public var picture: NSData?
    @NSManaged public var subtext: String?
    @NSManaged public var title: String?
    @NSManaged public var toDoList: NSSet?

}

// MARK: Generated accessors for toDoList
extension TodoItem {

    @objc(addToDoListObject:)
    @NSManaged public func addToToDoList(_ value: TodoList)

    @objc(removeToDoListObject:)
    @NSManaged public func removeFromToDoList(_ value: TodoList)

    @objc(addToDoList:)
    @NSManaged public func addToToDoList(_ values: NSSet)

    @objc(removeToDoList:)
    @NSManaged public func removeFromToDoList(_ values: NSSet)

}
