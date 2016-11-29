//
//  TodoList+CoreDataClass.swift
//  
//
//  Created by Dax Rahusen on 28/11/2016.
//
//

import Foundation
import CoreData


public class TodoList: NSManagedObject {

    // function which toggles the finished state
    func toggleChecked() {
        finished = !finished
    }
    
}
