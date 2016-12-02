//
//  DetailViewController.swift
//  ManyList
//
//  Created by Dax Rahusen on 28/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class DetailViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todoItemTextField: UITextField!
    @IBOutlet weak var todoAddButton: RadiusButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    // defined properties
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>!
    var todoList: TodoList?
    var imageData: NSData?
    
    // initialized properties
    var todoItems = [TodoItem]()
    var imagePicked = false
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNewData()
        setTextFieldBoardState()
    }

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        
        todoItemTextField.delegate = self
    
        // set a Notification listener for when the Keyboard will be shown
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // set a Notification listener for when the Keyboard will be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        // remove the Notification listeners when the view will disapear
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        super.viewWillDisappear(animated)
    }
    
    // function which fetch new data from the DataBase
    private func fetchNewData() {
        
        todoItems.removeAll()
        
        if let todolistId = todoList?.id {
            
            navigationController?.navigationItem.title = todoList!.title
            
            // set the fetchrequest to the entity table 'ToDoList'
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataClasses.TODOITEM)
            
            // filter for the given To-DO Items with giving To-Do List
            let predicate = NSPredicate(format: "listId = %@", todolistId)
            
            fetchRequest.predicate = predicate
            
            do {
                
                // try to fetch the new (up to date) To-Do items from Database
                todoItems = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest) as! [TodoItem]
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        // reload the tableview
        tableView.reloadData()
    }
    
    @IBAction func AddItemClicked(_ sender: RadiusButton) {
        
        // get the appropriate table path for writing newly objects
        let entity = NSEntityDescription.entity(forEntityName: CoreDataClasses.TODOITEM, in: CoreDataManager.sharedInstance.managedObjectContext)
        
        // create a new ToDoItem object pointing to the right identity and contextmanager
        let todoItem = TodoItem(entity: entity!, insertInto: CoreDataManager.sharedInstance.managedObjectContext)
        
        // set the list Primary identifier key
        todoItem.listId = todoList?.id
        
        // set the title object from the textFields text
        todoItem.title = todoItemTextField.text
        
        // set the finished state
        todoItem.finished = true
        
        // append the todoItem to the array
        todoItems.append(todoItem)
        
        // save the database changes
        CoreDataManager.sharedInstance.saveContext()
        
        // reload the tableview
        tableView.reloadData()
        
        // empty the text in the textfield
        todoItemTextField.text = ""
        
        // resign the keyboard focus on the textfield
        todoItemTextField.resignFirstResponder()
    }
    
    // function which sets the textfield interactions state
    func setTextFieldBoardState() {
        if todoList != nil {
            todoItemTextField.isUserInteractionEnabled = true
        } else {
            todoItemTextField.isUserInteractionEnabled = false
        }
    }
    
    // function which calculates the keyboard height and set the views new y in canvas
    func keyboardWasShown(notification: NSNotification) {
        
        // get the notification information
        let info = notification.userInfo!
        
        // get the keybaord size value from the info dictory and cast as a CGRect
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey]! as! NSValue).cgRectValue
        
        // get the keyboards height frame
        let keyboardHeight = keyboardSize.height
        
        // set the views bottom constant to the keyboard height
        bottomConstraint.constant = keyboardHeight
        
        // animate the view the to the new y state
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // function which set the views to original y in canvas
    func keyboardWillBeHidden(notification: NSNotification) {
        
        // set the bottom constant to original: 0
        bottomConstraint.constant = 0
        
        // animate the the view to original view state
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        
        if let textFieldString = todoItemTextField.text {
            coder.encode(textFieldString, forKey: SaveStateIdentifiers.TextFieldStateKey)
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        if let textFieldString = coder.decodeObject(forKey: SaveStateIdentifiers.TextFieldStateKey) as? String {
            todoItemTextField.text = textFieldString
            todoItemTextField.isUserInteractionEnabled = true
        }
        
        super.decodeRestorableState(with: coder)
    }
    
}

// MARK: - TodoListDelegate
extension DetailViewController: TodoListDelegate {
    
    // delegate function which will reload the tableview
    func deleteTodoList() {
        
        // check if size of the todoItems
        if todoItems.count > 0 {
            
            // loop through all avaliable TodoItems
            for todoItem in todoItems {
                
                CoreDataManager.sharedInstance.managedObjectContext.delete(todoItem)
                
                // remove all th items from the array
                todoItems.removeAll()
                
                // reload the tableview
                tableView.reloadData()
            }
            
            // save the database changes
            CoreDataManager.sharedInstance.saveContext()
        }
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.todoItemCell, for: indexPath)
        cell.accessoryType = todoItems[indexPath.row].finished ? .none : .checkmark
        cell.textLabel?.text = todoItems[indexPath.row].title
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            cell.accessoryType = todoItems[indexPath.row].finished ? .checkmark : .none
            todoItems[indexPath.row].toggleChecked()
        }
        
        CoreDataManager.sharedInstance.saveContext()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            
            // get the todo item form the array by index
            let todoItem = self.todoItems[index.row]
            
            // delete the todo item from the database
            CoreDataManager.sharedInstance.managedObjectContext.delete(todoItem)
            
            // remove the row from the local array by index
            self.todoItems.remove(at: index.row)
            
            // try to save the new database state
            CoreDataManager.sharedInstance.saveContext()
            
            // animate the indexed row from the tableview
            tableView.deleteRows(at: [index], with: .left)
            
            // check if the array is empty
            if self.todoItems.isEmpty {
                
                // define dispatch time now + 0.2 sec
                let when = DispatchTime.now() + 0.2
                
                // delay the main thread with define dispatch time
                DispatchQueue.main.asyncAfter(deadline: when) {
                    
                    // reload the tableview
                    tableView.reloadData()
                }
            }
        }
        
        return [deleteAction]
    }
}

// MARK: - UITextFieldDelegate
extension DetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the range of the between 0 and the amount of characters in the defined textField
        let nounTextFieldRange: NSRange = NSMakeRange(0, (textField.text?.characters.count)!)
        
        // check if the range of the defined textField and the given string are 0
        if (NSEqualRanges(range, nounTextFieldRange) && string.characters.count == 0) {
            
            // set the nounButton state to disabled
            self.todoAddButton.setState(state: false)
            
        } else {
            
            // set the nounButton state to enabled
            self.todoAddButton.setState(state: true)
        }
        
        return true
    }
    
}

// MARK: - DZNEmptyDataSetSource (https://github.com/dzenbot/DZNEmptyDataSet)
extension DetailViewController: DZNEmptyDataSetSource {
    
    // function to define a custom empty text for the empty state view
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var text: NSString!
        
        // set the text as NSString depending on To-Do items value
        if todoItems.isEmpty {
            text = "Please add a List item first"
        } else {
            text = "Write your first To-Do item!!"
        }
        
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
