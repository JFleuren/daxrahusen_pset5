//
//  TodoItem+CoreDataProperties.swift
//  
//
//  Created by Dax Rahusen on 29/11/2016.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem");
    }

    @NSManaged public var finished: Bool
    @NSManaged public var picture: NSData?
    @NSManaged public var subtext: String?
    @NSManaged public var title: String?
    @NSManaged public var listId: String?
    @NSManaged public var toDoList: TodoList?

}
