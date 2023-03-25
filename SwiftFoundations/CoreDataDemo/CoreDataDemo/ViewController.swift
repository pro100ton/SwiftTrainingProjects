//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Антон Шалимов on 30.01.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Link to AppDelegate file
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Creating CoreData context
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Creating entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        // Creating managed object
        let managedObject = NSManagedObject(entity: entityDescription!, insertInto: context)
        
        // Setting up attributes values
        managedObject.setValue("Anton", forKey: "name")
        managedObject.setValue(28, forKey: "age")
        
        // Getting values from attributes
        let name = managedObject.value(forKey: "name")
        let age = managedObject.value(forKey: "age")
        print("Name: \(name); Age: \(age)")
        
        // Saving object to database
        appDelegate.saveContext()
    }


}

