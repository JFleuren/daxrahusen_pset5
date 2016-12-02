//
//  ListTableViewController.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

protocol TodoListDelegate: class {
    func deleteTodoList()
}

class ListTableViewController: UITableViewController {
    
    // defined properties
    var delegate: AppDelegate!
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>!
    var todolists: [TodoList]?
    var addListView: AddListItemAlert?
    weak var toDoListDelegate: TodoListDelegate? = nil
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch new data from the CoreData Database
        fetchNewData(manager: CoreDataManager.sharedInstance.managedObjectContext)
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // set selection preservation between presentations
        clearsSelectionOnViewWillAppear = false
        
        // set the splitViewController delegate to this vc
        splitViewController?.delegate = self
        
        // set the emptyDataSource to this vc
        tableView.emptyDataSetSource = self
        
        // 
        tableView.separatorStyle = .none
        
        // set the primary vc layered on top of the secondary view controller,
        // leaving the secondary view controller partially visible.
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
    }
    
    // function which fetch new data from the DataBase
    private func fetchNewData(manager: NSManagedObjectContext) {
        
        // set the fetchrequest to the entity table 'ToDoList'
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataClasses.TODOLIST)
        
        do {
            
            // try to fetch the new (up to date) To-Do items from Database
            todolists = try manager.fetch(fetchRequest) as? [TodoList]
            
            // reload the tableview
            tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifiers.detailSegue {
            
            let navigationVC = segue.destination as! UINavigationController
            
            let detailVC = navigationVC.viewControllers.first as! DetailViewController
            self.toDoListDelegate = detailVC
            detailVC.todoList = sender as? TodoList
        }
    }
    
    // function which will give the option to create a TodoList
    @IBAction func AddListButtonClicked(sender: UIBarButtonItem) {
        
        // initialize a custom AlertViewController
        addListView = AddListItemAlert()
        
        // add the listview to the screen with completion handler
        addListView!.addListView(controller: self) { (succeed, text) in
            if succeed {
                
                // get the appropriate table path for writing newly objects
                let entity = NSEntityDescription.entity(forEntityName: CoreDataClasses.TODOLIST, in: CoreDataManager.sharedInstance.managedObjectContext)
                
                // initialize a Core Data To-Do List object
                let todoList = TodoList(entity: entity!, insertInto: CoreDataManager.sharedInstance.managedObjectContext)
                
                // set the user id in the To-Do List title object
                todoList.id = "\(NSDate())"
                
                // set the user text in the To-Do List title object
                todoList.title = text!
                
                // set the finished state to the To-Do List title object
                todoList.finished = false
                
                // append the todoList to the local array
                self.todolists!.append(todoList)
                
                // save the new Core Data base
                CoreDataManager.sharedInstance.saveContext()
                
                // tell the table it will begin updating
                self.tableView.beginUpdates()
                
                // get the last index from the array
                let indexPath = IndexPath(row: self.todolists!.count - 1, section: 0)
                
                // insert the element in the tableview by given index
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
                // tell the table it will end updating
                self.tableView.endUpdates()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolists!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.todoListCell, for: indexPath)
        
        cell.textLabel?.text = todolists![indexPath.row].title

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: SegueIdentifiers.detailSegue, sender: todolists![indexPath.row])
    }
    
    // function which set the options for editing a row in the tableview
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // function which the logic of swipe row actions are defined
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action which deletes the todo item in the Database, tableview and local array
        let deleteActtion = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            
            // get the todo item form the array by index
            let todoList = self.todolists![indexPath.row]
            
            // delete the todo item from the database
            CoreDataManager.sharedInstance.managedObjectContext.delete(todoList)
            
            do {
                
                // try to save the new database state
                try CoreDataManager.sharedInstance.managedObjectContext.save()
                
                // remove the row from the local array by index
                self.todolists!.remove(at: indexPath.row)
                
                // animate the indexed row from the tableview
                tableView.deleteRows(at: [indexPath], with: .left)
                
                DispatchQueue.main.async {
                    self.toDoListDelegate?.deleteTodoList()
                }
                
                // check if the array is empty
                if (self.todolists!.isEmpty) {
                    
                    // define dispatch time now + 0.2 sec
                    let when = DispatchTime.now() + 0.2
                    
                    // delay the main thread with define dispatch time
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        
                        // reload the tableview
                        tableView.reloadData()
                    }
                }
                
                // show an error if fails
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        // return all actions in array
        return [deleteActtion]
    }
}

// MARK: - UISplitViewControllerDelegate
extension ListTableViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

//MARK: - DZNEmptyDataSetSource (https://github.com/dzenbot/DZNEmptyDataSet)
extension ListTableViewController: DZNEmptyDataSetSource {
    
    // function which set an image to the empty state view
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty_state")!
    }
    
    // function which changes the image tint of the empty state view
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.lightGray
    }
    
    // function to define a custom empty text for the empty state view
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        // set the text as NSString
        let text: NSString = "Make your first To-Do List and never forget something!"
        
        // initialize a paragraphstyle class
        let paragraph = NSMutableParagraphStyle()
        
        // set the paragraph line break mode value to wordWarpping style
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // set the paragraph allignment to center
        paragraph.alignment = NSTextAlignment.center
        
        // define a NSDictionary with text options
        let attr: NSDictionary = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0),
                                   NSForegroundColorAttributeName: UIColor.lightGray,
                                   NSParagraphStyleAttributeName: paragraph
        ]
        
        // return a NSAttributedString object with defined text and attributes parameters
        return NSAttributedString.init(string: text as String, attributes: attr as? [String : Any])
    }
}














