//
//  ViewController.swift
//  CoreDataSample
//
//  Created by sudhakar krishnan on 20/8/20.
//  Copyright © 2020 sudhakar krishnan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        saveToCoreData()
        
        updateRecord()
        
        deleteRecord()
        
        retriveFromCoreData()
    }
    
    func saveToCoreData() -> () {
        /*
         1. Create reference to persistent container (Already created in Appdelegate)
         2. Create context form persistent container (Managed object context)
         3. Create entity using context
         4. Create Managed Object
         */
        
        guard  let appDelegate = appDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let optionalEntity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        guard let entity = optionalEntity else {
            return
        }
        let managedObject =  NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue("sudhakar", forKey: "name")
        managedObject.setValue("pwd", forKey: "password")
        managedObject.setValue("sudhakar", forKey: "gender")
        
        //        appDelegate.saveContext()
        // OR
        do {
            try context.save()
        }catch let error as NSError{
            print(error)
        }
    }
    
    func retriveFromCoreData() -> () {
        /*
         1. Create the context
         2. Create the FetchRequest for the entity
         3. Fetch the result from context
         */
        guard  let appDelegate = appDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false // Enable faulting
        /*
         Fault is a placehoder object in Persistent store.
         Which refers to other managed objects
         */
        
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            for record in result {
                print(record)
            }
        } catch {
            print("failed")
        }
    }
    
    func updateRecord() -> () {
        /*
         1. Create the context From Persistent container
         2. Create the FetchRequest for the entity
         3. Fetch the result from context
         4. Update record and save
         */
        guard  let appDelegate = appDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false // Enable faulting
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            let record = result.first
            record?.setValue("Krishnan", forKey: "name")
            
        } catch {
            print("failed")
        }
        appDelegate.saveContext()
    }
    
    func deleteRecord() -> () {
        /*
         1. Create the context From Persistent container
         2. Create the FetchRequest for the entity
         3. Fetch the result from context
         4. Update record and save
         */
        guard  let appDelegate = appDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false // Enable faulting
        request.predicate = NSPredicate(format: "name = %@", "Krishnan")
        
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            if let record = result.first{
                context.delete(record) // Deleted
            }
            
        } catch {
            print("failed")
        }
        appDelegate.saveContext()
    }
}

