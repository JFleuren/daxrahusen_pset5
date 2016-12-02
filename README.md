# ## Many List

A many to-do list app that has a list of tasks that the user needs to complete. 
The application supports splitview for iPad and iPhone plus. 
Also it supports restiration support.

## Code Example

The application makes use of the following 3rd party pods:

- [DateTools by MatthewYork](https://github.com/MatthewYork/DateTools)
- [DZNEmptyDataSet by dzenbot](https://github.com/dzenbot/DZNEmptyDataSet)


```swift
    // function which adds dummy todo items in the database before loading the table
    private func addDummyData(manager: NSManagedObjectContext) {
        
        // get the entity for the To-Do item with the defined managedcontext
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext)
        
        // parse the json to a array of dictionaries
        let parsedArray = parseJsonToDict()
        
        // loop through all the dictionary items in the array
        for item in parsedArray {
            
            // initialize a Core Data To-Do  object
            let todo = Todo(entity: entity!, insertInto: manager)
            
            // get the subject value and set in the object
            todo.subject = item["subject"] as? String
            
            // get the finished value and set in the object
            todo.finished = item["finished"] as! Bool
            
            // get the date value and set in the object
            todo.date = NSDate().addingMinutes(item["date"] as! Int) as NSDate?
            
            // append the To-Do object to the array
            todos?.append(todo)
        }
        
        do {
            // try to save the new Database state
            try manager.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
```

## Assignment

The application is the result of an assignment of the Minor Programmeren at the [UvA](http://www.uva.nl/en/home).


## Installation

- Download Github Project
- Download Xcode 8.1
- Open project directory in terminal
- Write `pod install` in terminal 
- Open ManyList.xcworkspace


## License

license MIT
