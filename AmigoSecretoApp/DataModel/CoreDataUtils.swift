//
//  CoreDataUtils.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/6/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataUtils{
    
    static var sharedInstance = CoreDataUtils()

    func createNewPerson (person:Person){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let userCoreData = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        let name : String? = person.name ?? " "
        let email : String? = person.email ?? " "
        let password : String? = person.password ?? " "
        let logged : Bool? = person.logged
        let gift : String? = person.gift ?? " "
        let state : String? = person.state ?? " "
        
        userCoreData.setValue(name, forKey: "name")
        userCoreData.setValue(email, forKey: "email")
        userCoreData.setValue(password, forKey: "password")
        userCoreData.setValue(logged, forKey: "logged")
        userCoreData.setValue(gift, forKey: "gift")
        userCoreData.setValue(state, forKey: "state")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func searchPersonByEmail ( email:String, completion: @escaping (_ personObj:Person?, _ error:NSError?) -> Void) {
        var retPersonObj : Person?
       
        //As we know that container is set up in the AppDelegates so we need to refer that container.
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
  
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            
            fetchRequest.predicate = NSPredicate(format: "email = %@", email)
            
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let retPerson = Person(context:managedContext)
                print("name: ", data.value(forKey: "name") as? String ?? " ")
                print("email: ",data.value(forKey: "email") as! String)
               
                retPerson.name = data.value(forKey: "name") as? String
                retPerson.email = data.value(forKey: "email") as? String
                retPerson.password = data.value(forKey: "password") as? String
                retPerson.logged = data.value(forKey: "logged") as? Bool ?? false
                retPerson.gift = data.value(forKey: "gift") as? String
                retPerson.state = data.value(forKey: "state") as? String
                
                retPersonObj = retPerson
            }
             completion(retPersonObj,nil)
            
        } catch {
            var error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Person"])
            completion(nil, error as NSError)
            fatalError("Failed to fetch employees: \(error)")
            
        }
     
    }
    
    func readAppConfigs (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "appCurrentDate") as? String)
                print(data.value(forKey: "appName") as? String)
                print(data.value(forKey: "appSubtitle") as? String)
                print(data.value(forKey: "isEventActive") as? String)
                print(data.value(forKey: "isLogged") as? String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func readAppConfigsToObj (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "appName") as? String)
                
                let appConfig = AppConfigs(context: managedContext)
                appConfig.appName = (data.value(forKey: "appName") as? String)
                
                print ("appConfig.appName ", appConfig.appName)
            }
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
      
    }
    
    
    
}
