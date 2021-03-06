//
//  AppDelegate.swift
//  To-Do List
//
//  Created by Dax Rahusen on 19/11/2016.
//  Copyright © 2016 Dax. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coreDataManager: CoreDataManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        coreDataManager = CoreDataManager.sharedInstance
        
        // intitalize the navigationbar appearance object
        let navigationBar = UINavigationBar.appearance()
        
        // set the background color to the navigationbar
        navigationBar.backgroundColor = .black
        
        // set the tintColor color to the navigationbar
        navigationBar.tintColor = .white
        
        // set the barstyle color to the navigationbar
        navigationBar.barStyle = .black
        
        //initialize first object for detailVC
        
        let device = UIDevice.current
        
        if device.orientation == .landscapeLeft || device.orientation == .landscapeRight {
            setFirstObjectForDetail()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataManager.saveContext()
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    //initialize first object for detailVC
    private func setFirstObjectForDetail() {
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        
        let leftNavController = splitViewController.viewControllers.first as! UINavigationController
        let masterViewController = leftNavController.topViewController as! ListTableViewController
        
        let rightNavController = splitViewController.viewControllers.last as! UINavigationController
        let detailViewController = rightNavController.topViewController as! DetailViewController
        
        // set the fetchrequest to the entity table 'ToDoList'
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataClasses.TODOLIST)
        
        do {
            
            // try to fetch the new (up to date) To-Do items from Database
            let todolists = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest) as? [TodoList]
            
            // set first object to
            detailViewController.todoList = todolists?.first
            masterViewController.toDoListDelegate = detailViewController
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}

