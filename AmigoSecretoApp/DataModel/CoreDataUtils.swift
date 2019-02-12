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
        request.predicate = NSPredicate(format: "id = %@", "2")

        
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "appCurrentDate") as? String)
                print(data.value(forKey: "appName") as? String)
                print(data.value(forKey: "appSubtitle") as? String)
                print(data.value(forKey: "isEventActive") as? String)
                print(data.value(forKey: "isLogged") as? String)
                print(data.value(forKey: "adminUserEmail") as? String)
               
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func readAppConfigsToDelegate (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        request.predicate = NSPredicate(format: "id = %@", "2")
      
        
        do {
            let result = try managedContext.fetch(request)
            
            if (result.count <= 1){
                appDelegate.initValueAppGlobalSettings()
            }
            let appConfig = AppConfigs(context: managedContext)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "appName") as? String)
                
                appConfig.appName = (data.value(forKey: "appName") as? String)
                
                appConfig.appSubtitle = (data.value(forKey: "appSubtitle") as? String)
                appConfig.id = (data.value(forKey: "id") as? Int16 ?? 0)
                appConfig.adminUserEmail = (data.value(forKey: "adminUserEmail") as? String ?? " ")
                
                print ("CoreDataUtils appConfig.appName ", appConfig.appName)
                print ("CoreDataUtils appConfig.appSubtitle ", appConfig.appSubtitle)
                print ("CoreDataUtils appConfig.id ", appConfig.id)
                print ("CoreDataUtils appConfig.adminUser?.email ", appConfig.adminUserEmail)
                appDelegate.globalAppSettings = appConfig
            }
            
            
        } catch {
            fatalError("Failed to fetch globalAppSetting: \(error)")
        }
      
    }
    func preloadAppGlobalSettings (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "2")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.isEmpty{
                print ("no se encontro ID 0001")
                appDelegate.globalAppSettings = AppConfigs (context: managedContext)
                appDelegate.initValueAppGlobalSettings()
                createAppGlobalSettings(appConfig: appDelegate.globalAppSettings!)
            }
            else{
                print ("si se encontro ID 0001")
                for data in test as! [NSManagedObject] {
                
                    let appConfig = AppConfigs(context: managedContext)
                    appConfig.appName = (data.value(forKey: "appName") as? String)
                    
                    appConfig.appSubtitle = (data.value(forKey: "appSubtitle") as? String)
                    appConfig.id = (data.value(forKey: "id") as? Int16 ?? 0)
                    print ("CoreDataUtils appConfig.appName ", appConfig.appName)
                    print ("CoreDataUtils appConfig.appSubtitle ", appConfig.appSubtitle)
                    print ("CoreDataUtils appConfig.id ", appConfig.id)
                    print ("CoreDataUtils appConfig.adminUser?.email ", appConfig.adminUserEmail)
                    appDelegate.globalAppSettings = appConfig
                }
                
                 
            }
            
        }
        catch let error as NSError {
            print("Could not save appconfigs. \(error), \(error.userInfo)")
        }
    }
    
    func updateAppGlobalSettings (appConfig:AppConfigs){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "2")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.isEmpty{
                print ("no se encontro ID 0001")
                appDelegate.initValueAppGlobalSettings()
                createAppGlobalSettings(appConfig: appDelegate.globalAppSettings!)
            }
            else{
                print ("updateAppGlobalSettings si se encontro ID 0001")
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(appDelegate.globalAppSettings!.appName, forKey: "appName")
                objectUpdate.setValue(appDelegate.globalAppSettings!.appSubtitle, forKey: "appSubtitle")
                objectUpdate.setValue(appDelegate.globalAppSettings?.isLogged, forKey: "isLogged")
                objectUpdate.setValue(appDelegate.globalAppSettings?.isEventActive, forKey: "isEventActive")
                objectUpdate.setValue(appDelegate.globalAppSettings!.appCurrentDate, forKey: "appCurrentDate")
                objectUpdate.setValue(appDelegate.globalAppSettings!.adminUserEmail, forKey: "adminUserEmail")
                objectUpdate.setValue(appDelegate.globalAppSettings!.currentAppLoggedUserEmail, forKey: "currentAppLoggedUserEmail")
                objectUpdate.setValue(appDelegate.globalAppSettings!.id + 1 , forKey: "id")
                
                print ("CoreDataUtils appConfig.appName ", appDelegate.globalAppSettings!.appName)
                print ("CoreDataUtils appConfig.appSubtitle ",appDelegate.globalAppSettings!.appSubtitle)
                print ("CoreDataUtils appConfig.id ", appDelegate.globalAppSettings!.id)
                print ("CoreDataUtils appConfig.adminUser?.email ", appDelegate.globalAppSettings!.adminUserEmail)
                
                appDelegate.globalAppSettings = appConfig
                
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
            
        }
        catch let error as NSError {
            print("Could not save appconfigs. \(error), \(error.userInfo)")
        }
}
        
    func createAppGlobalSettings (appConfig:AppConfigs){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
    
        let userEntity = NSEntityDescription.entity(forEntityName: "AppConfigs", in: managedContext)!
        
        let appConfigsCoreData = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        let appName : String? = appConfig.appName ?? " "
        let appSubtitle : String? = appConfig.appSubtitle ?? " "
        let isLogged : Bool? = appConfig.isLogged
        let isEventActive : Bool? = appConfig.isEventActive
        let appCurrentDate : Date? = appConfig.appCurrentDate
        let adminUser : String? = appConfig.adminUserEmail
        let currentappLoggedUser : String? = appConfig.currentAppLoggedUserEmail
        let id : Int16 = appConfig.id + 1
        appConfig.id = id
        
        print ( " createAppGlobalSettings ", appName)
        print ( " createAppGlobalSettings ", appSubtitle)
        print ( " createAppGlobalSettings ", adminUser)
        print ( " createAppGlobalSettings ", id)
        print ( " createAppGlobalSettings ", currentappLoggedUser)
        
        appConfigsCoreData.setValue(appName, forKey: "appName")
        appConfigsCoreData.setValue(appSubtitle, forKey: "appSubtitle")
        appConfigsCoreData.setValue(isLogged, forKey: "isLogged")
        appConfigsCoreData.setValue(isEventActive, forKey: "isEventActive")
        appConfigsCoreData.setValue(appCurrentDate, forKey: "appCurrentDate")
        appConfigsCoreData.setValue(adminUser, forKey: "adminUserEmail")
        appConfigsCoreData.setValue(currentappLoggedUser, forKey: "currentAppLoggedUserEmail")
        appConfigsCoreData.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save createAppGlobalSettings appconfigs. \(error), \(error.userInfo)")
        }
    }
    
    func saveAppGlobalSettings (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "AppConfigs", in: managedContext)!
        
        let appConfigsCoreData = NSManagedObject(entity: userEntity, insertInto: managedContext)
        let appConfig : AppConfigs = appDelegate.globalAppSettings!
        
        let appName : String? = appConfig.appName ?? "AmigoSecretoApp"
        let appSubtitle : String? = appConfig.appSubtitle ?? "@ by Belatrix "
        let isLogged : Bool? = appConfig.isLogged
        let isEventActive : Bool? = appConfig.isEventActive
        let appCurrentDate : Date? = appConfig.appCurrentDate
        let adminUser : String? = appConfig.adminUserEmail
        let currentappLoggedUser : String? = appConfig.currentAppLoggedUserEmail
        let id : Int16 = appConfig.id + 1
        appConfig.id = id
        
        print ( " saveAppGlobalSettings ", appName)
        print ( " saveAppGlobalSettings ", appSubtitle)
        print ( " saveAppGlobalSettings ", adminUser)
        print ( " saveAppGlobalSettings ", id)
        print ( " saveAppGlobalSettings ", currentappLoggedUser)
        
        appConfigsCoreData.setValue(appName, forKey: "appName")
        appConfigsCoreData.setValue(appSubtitle, forKey: "appSubtitle")
        appConfigsCoreData.setValue(isLogged, forKey: "isLogged")
        appConfigsCoreData.setValue(isEventActive, forKey: "isEventActive")
        appConfigsCoreData.setValue(appCurrentDate, forKey: "appCurrentDate")
        appConfigsCoreData.setValue(adminUser, forKey: "adminUserEmail")
        appConfigsCoreData.setValue(currentappLoggedUser, forKey: "currentAppLoggedUserEmail")
        appConfigsCoreData.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save createAppGlobalSettings appconfigs. \(error), \(error.userInfo)")
        }
    }
}
