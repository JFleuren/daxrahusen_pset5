//
//  TodoItem+CoreDataClass.swift
//  
//
//  Created by Dax Rahusen on 29/11/2016.
//
//

import Foundation
import CoreData


public class TodoItem: NSManagedObject {

    // function which toggles the finished state
    func toggleChecked() {
        finished = !finished
    }
    
}
