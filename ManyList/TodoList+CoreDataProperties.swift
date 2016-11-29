//
//  TodoList+CoreDataProperties.swift
//  
//
//  Created by Dax Rahusen on 28/11/2016.
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
    @NSManaged public var toDoItem: TodoItem?

}
