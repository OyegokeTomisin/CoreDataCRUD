//
//  ViewController.swift
//  CoreDataCRUD
//
//  Created by OYEGOKE TOMISIN on 19/06/2019.
//  Copyright © 2019 OYEGOKE TOMISIN. All rights reserved.
//

import UIKit
import CoreData

//https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Create records to core data
    
    func createData(){
        //1: Refer to persistence container from appDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //2: Create the context from persistentContainer
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //3: Create an entity
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else { return }
        
        //4: Create new record
        for i in 1...5 {
            let user = NSManagedObject(entity: entity, insertInto: managedContext)
            
            //5: Set values fo the records for each key
            user.setValue("Tomi\(i)", forKey: "username")
            user.setValue("tomi\(i)@test.com", forKey: "email")
            user.setValue("tomi\(i)", forKey: "password")
        }
        
        do{
            try managedContext.save()
            
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK:- Retrieve Data
    
    func retrieveData() {
        //A: Refer to persistence container from appDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //B: Create the context from persistentContainer
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //1: Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        //2: If required use predicate for filter data
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Tomi")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        
        do{
            //3: Fetch the result from context in the form of array of [NSManagedObject]
            let result = try managedContext.fetch(fetchRequest)
            
            //4: Iterate through an array to get value for the specific key
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "usermane") as! String)
            }
            
        } catch let error as NSError{
            print("Failed \(error), \(error.userInfo)")
        }
    }
    
    // MARK:- Update Data
    
    func updateData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Tomi")
        
        do{
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "username")
            objectUpdate.setValue("newEmail", forKey: "email")
            objectUpdate.setValue("newPassword", forKey: "password")
            
            do{
                try managedContext.save()
                
            } catch {
                print(error)
            }
            
        } catch let error as NSError{
            print("Failed \(error), \(error.userInfo)")
        }
    }
    
    // MARK:- Delete Data
    
    func deleteData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Tomi")
        
        do{
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                
            } catch {
                print(error)
            }
            
        } catch let error as NSError{
            print("Failed \(error), \(error.userInfo)")
        }
    }
    
}

