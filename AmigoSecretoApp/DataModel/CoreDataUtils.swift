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
        let admin : Bool = person.admin
        
        userCoreData.setValue(name, forKey: "name")
        userCoreData.setValue(email, forKey: "email")
        userCoreData.setValue(password, forKey: "password")
        userCoreData.setValue(logged, forKey: "logged")
        userCoreData.setValue(gift, forKey: "gift")
        userCoreData.setValue(state, forKey: "state")
        userCoreData.setValue(admin, forKey: "admin")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func createNewEvent (event:Event, persona:Person){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)!
        
        let userCoreData = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        let date : String? = event.date
        let maxprice : String? = event.maxprice ?? " "
        let minprice : String? = event.minprice ?? " "
        let name : String? = event.name ?? " "
        let state : String? = event.state ?? " "
        
        print ("persona globalUser ", persona)
        
        var owner : Person? = Person(context: managedContext)
        owner?.email = persona.email
        owner?.admin = persona.admin
        owner?.logged = persona.logged
        owner?.name = persona.name
        
        
        print ("createNewEvent owner ", persona)
        
        userCoreData.setValue(date, forKey: "date")
        userCoreData.setValue(maxprice, forKey: "maxprice")
        userCoreData.setValue(minprice, forKey: "minprice")
        userCoreData.setValue(name, forKey: "name")
        userCoreData.setValue(state, forKey: "state")
        userCoreData.setValue(owner, forKey: "owner")
      
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save event. \(error), \(error.userInfo)")
        }
    }
    
    func searchEventByEmail ( email:String, completion: @escaping (_ personObj:Event?, _ error:NSError?) -> Void) {
        var retEventObj : Event?
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
            
            //fetchRequest.predicate = NSPredicate(format: "owner = %@", email)
            
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let retEvent = Event(context:managedContext)
                print("date: ", data.value(forKey: "date") as? String ?? " ")
                print("name: ",data.value(forKey: "name") as? String ?? " ")
                print("state: ",data.value(forKey: "state") as? String ?? " ")
                print("owner: ",data.value(forKey: "owner") as? String ?? " ")
                print("draw: ",data.value(forKey: "draw") as? NSSet ?? " ")
                
                retEvent.date = data.value(forKey: "date") as? String
                retEvent.name = data.value(forKey: "name") as? String
                retEvent.state = data.value(forKey: "state") as? String
                retEvent.owner = data.value(forKey: "owner") as? Person
                retEvent.draw = data.value(forKey: "draw") as? NSSet
               
                
                retEventObj = retEvent
            }
            completion(retEventObj,nil)
            
        } catch {
            var error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Person"])
            completion(nil, error as NSError)
            fatalError("Failed to fetch person: \(error)")
            
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
                print("logged: ",data.value(forKey: "logged") as? Bool ?? false)
                print("admin: ",data.value(forKey: "admin") as? Bool ?? false)
                
                retPerson.name = data.value(forKey: "name") as? String
                retPerson.email = data.value(forKey: "email") as? String
                retPerson.password = data.value(forKey: "password") as? String
                retPerson.logged = data.value(forKey: "logged") as? Bool ?? false
                retPerson.gift = data.value(forKey: "gift") as? String
                retPerson.state = data.value(forKey: "state") as? String
                retPerson.admin = data.value(forKey: "admin") as? Bool ?? false
                
                retPersonObj = retPerson
            }
             completion(retPersonObj,nil)
            
        } catch {
            var error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Person"])
            completion(nil, error as NSError)
            fatalError("Failed to fetch person: \(error)")
            
        }
     
    }
   
    func getAllPersonsOfEvent (completion: @escaping (_ personArr:[Person]?, _ error:NSError?) -> Void) {
        var personArr : [Person] = []
        var retPersonObj : Person?
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
       
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            fetchRequest.returnsDistinctResults = true
            fetchRequest.propertiesToFetch = ["email"]
        
            fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
            fetchRequest.predicate = NSPredicate(format: "state = %@", "0")
            
         do {
                let results = try managedContext.fetch(fetchRequest)
                
                // 2) cast the results to the expected dictionary type:
                let resultsDict = results as! [[String: String]]
            
                for r in resultsDict {
                    print ("r ",  r["email"])
                     print ("r ",  r["name"])
                     print ("r ",  r["state"])
                    let retPerson = Person(context:managedContext)
                    retPerson.name = r["name"]
                    retPerson.email = r["email"]
                    retPerson.password = r["password"]
                    retPerson.logged = (r["logged"] != nil)
                    retPerson.gift = r["gift"]
                    retPerson.state = r["state"]
                    retPerson.admin = (r["admin"] != nil)
                    
                    if ( ((retPerson.email?.count)! > 3 )  ){
                        retPersonObj = retPerson
                        personArr.append(retPersonObj!)
                    }
                }
            
            print ("numero de registros: ", personArr.count)
            completion(personArr,nil)

            }
        
         catch {
            let error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Person"])
            completion(nil, error as NSError)
            fatalError("Failed to fetch person: \(error)")
            
        }
            
            /*
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let retPerson = Person(context:managedContext)
                print("name: ", data.value(forKey: "name") as? String ?? " ")
                print("email: ",data.value(forKey: "email") as! String)
                print("logged: ",data.value(forKey: "logged") as? Bool ?? false)
                
                retPerson.name = data.value(forKey: "name") as? String ?? " "
                retPerson.email = data.value(forKey: "email") as? String ?? " "
                retPerson.password = data.value(forKey: "password") as? String
                retPerson.logged = data.value(forKey: "logged") as? Bool ?? false
                retPerson.gift = data.value(forKey: "gift") as? String
                retPerson.state = data.value(forKey: "state") as? String
                retPerson.admin = data.value(forKey: "admin") as? Bool ?? false
                
                if ( ((retPerson.email?.count)! > 3 ) && (((retPerson.name)?.count)! > 3) ){
                    retPersonObj = retPerson
                    personArr.append(retPersonObj!)
                }
            }
            print ("numero de registros: ", personArr.count)
            completion(personArr,nil)
            
        } catch {
            let error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Person"])
            completion(nil, error as NSError)
            fatalError("Failed to fetch person: \(error)")
            
        }
             */
        
    }
    
    func readAppConfigs (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        //request.predicate = NSPredicate(format: "id = %@", "2")

        
        do {
            let result = try managedContext.fetch(request)
            let appConfig = AppConfigs(context: managedContext)
            
            for data in result as! [NSManagedObject] {
                appConfig.adminUserEmail = (data.value(forKey: "adminUserEmail") as? String ?? "0")
                appConfig.currentAppLoggedUserEmail = ((data.value(forKey: "currentAppLoggedUserEmail") as? String ?? "0"))
                if ((appConfig.adminUserEmail)! != "0") && ((appConfig.adminUserEmail?.count)! > 3) && ((appConfig.currentAppLoggedUserEmail?.count)! > 3){
                    
                   
                    print ("(readAppConfigs currentAppLoggedUserEmail?.count) ",(appConfig.currentAppLoggedUserEmail?.count))
                    print("readAppConfigs" ,data.value(forKey: "currentAppLoggedUserEmail") as? String)
                    print("readAppConfigs" ,data.value(forKey: "appCurrentDate") as? String)
                    print("readAppConfigs" ,data.value(forKey: "appName") as? String)
                    print("readAppConfigs" ,data.value(forKey: "appSubtitle") as? String)
                    print("readAppConfigs" ,data.value(forKey: "isEventActive") as? String)
                    print("readAppConfigs" ,data.value(forKey: "isLogged") as? String)
                    print("readAppConfigs" ,data.value(forKey: "adminUserEmail") as? String)
                }
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func readAppConfigsToDelegate (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let active :Bool = false
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        request.predicate = NSPredicate(format: "id >= %@", "1")
        request.predicate = NSPredicate(format: "isLogged = %i", active)
        //request.predicate = NSPredicate(format: "adminUserEmail != nil" )
      
        
        do {
            let result = try managedContext.fetch(request)
            
            if (result.count == 0){
                appDelegate.initValueAppGlobalSettings()
                
            }else{
                let appConfig = AppConfigs(context: managedContext)
                for data in result as! [NSManagedObject] {
                    
                    
                    appConfig.appName = (data.value(forKey: "appName") as? String)
                    
                    appConfig.appSubtitle = (data.value(forKey: "appSubtitle") as? String)
                    appConfig.id = (data.value(forKey: "id") as? Int16 ?? 0)
                    appConfig.adminUserEmail = (data.value(forKey: "adminUserEmail") as? String ?? "0")
                    appConfig.isLogged = (data.value(forKey: "isLogged") as! Bool)
                    appConfig.currentAppLoggedUserEmail = (data.value(forKey: "currentAppLoggedUserEmail") as? String)
                    appConfig.isEventActive = (data.value(forKey: "isEventActive") as! Bool)
                    appConfig.appCurrentDate = (data.value(forKey: "appCurrentDate") as? String)
                    
                   
                    
                    if ((appConfig.adminUserEmail)! != "0") && ((appConfig.adminUserEmail?.count)! > 3){
                        print ("(appConfig.adminUserEmail?.count) ",(appConfig.adminUserEmail?.count))
                        
                        print ("CoreDataUtils appConfig.appName ", appConfig.appName)
                        print ("CoreDataUtils appConfig.appSubtitle ", appConfig.appSubtitle)
                        print ("CoreDataUtils appConfig.id ", appConfig.id)
                        print ("CoreDataUtils appConfig.adminUser?.email ", appConfig.adminUserEmail)
                        print ("CoreDataUtils appConfig.isLogged  ", appConfig.isLogged)
                        
                        appDelegate.globalAppSettings = appConfig
                    }
                    
                }
            }
            
            
            
        } catch {
            fatalError("Failed to fetch readAppConfigsToDelegate globalAppSetting: \(error)")
        }
      
    }
    func readAppConfigsToDelegateAdmin (completion: @escaping (_ retAppConfigObj:AppConfigs?, _ error:NSError?) -> Void) {
    var retAppConfigObj : AppConfigs?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let active :Bool = true
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        request.predicate = NSPredicate(format: "id >= %@", "0")
        request.predicate = NSPredicate(format: "isLogged = %i", active)
        
        
        do {
            let result = try managedContext.fetch(request)
            
            if (result.count == 0){
                appDelegate.initValueAppGlobalSettings()
                
            }else{
                let appConfig = AppConfigs(context: managedContext)
                for data in result as! [NSManagedObject] {
                    
                    
                    appConfig.appName = (data.value(forKey: "appName") as? String)
                    
                    appConfig.appSubtitle = (data.value(forKey: "appSubtitle") as? String)
                    appConfig.id = (data.value(forKey: "id") as? Int16 ?? 0)
                    appConfig.adminUserEmail = (data.value(forKey: "adminUserEmail") as? String ?? " ")
                    appConfig.isLogged = (data.value(forKey: "isLogged") as! Bool)
                    appConfig.currentAppLoggedUserEmail = (data.value(forKey: "currentAppLoggedUserEmail") as? String)
                    appConfig.isEventActive = (data.value(forKey: "isEventActive") as! Bool)
                    appConfig.appCurrentDate = (data.value(forKey: "appCurrentDate") as? String)
                    
                    if (appConfig.currentAppLoggedUserEmail != nil){
                        
                        
                        if ( ((appConfig.adminUserEmail?.count)! > 3) && ((appConfig.currentAppLoggedUserEmail?.count)! > 3) ){
                            print ("(appConfig.adminUserEmail?.count) ",(appConfig.adminUserEmail?.count))
                            print("CoreDataUtils admin appConfig.currentAppLoggedUserEmail " ,appConfig.currentAppLoggedUserEmail)
                            print ("CoreDataUtils admin appConfig.appName ", appConfig.appName)
                            print ("CoreDataUtils admin appConfig.appSubtitle ", appConfig.appSubtitle)
                            print ("CoreDataUtils admin appConfig.id ", appConfig.id)
                            print ("CoreDataUtils admin appConfig.adminUser?.email ", appConfig.adminUserEmail)
                            print ("CoreDataUtils admin appConfig.isLogged  ", appConfig.isLogged)
                            retAppConfigObj = appConfig
                            completion(retAppConfigObj,nil)
                            break;
                        }
                    }
                }
                
            }
            
            
            
        } catch {
            completion(nil, error as NSError)
            fatalError("Failed to fetch readAppConfigsToDelegate globalAppSetting: \(error)")
            
        }
        
    }
    func preloadAppGlobalSettings (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        //fetchRequest.predicate = NSPredicate(format: "id = %@", "2")
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
                    appConfig.adminUserEmail = (data.value(forKey: "adminUserEmail") as? String ?? "")
                    appConfig.appSubtitle = (data.value(forKey: "appSubtitle") as? String)
                    appConfig.id = (data.value(forKey: "id") as? Int16 ?? 0)
                    
                    if ((appConfig.adminUserEmail)! != "0") && ((appConfig.adminUserEmail?.count)! > 3){
                        print ("(appConfig.adminUserEmail?.count) ",(appConfig.adminUserEmail?.count))
                        
                        print ("CoreDataUtils preloadAppGlobalSettings appConfig.appName ", appConfig.appName)
                        print ("CoreDataUtils preloadAppGlobalSettings appConfig.appSubtitle ", appConfig.appSubtitle)
                        print ("CoreDataUtils preloadAppGlobalSettings appConfig.id ", appConfig.id)
                        print ("CoreDataUtils preloadAppGlobalSettings appConfig.adminUser?.email ", appConfig.adminUserEmail)
                        appDelegate.globalAppSettings = appConfig
                    }
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
        let appCurrentDate : String? = appConfig.appCurrentDate
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
        let isLogged : Bool? = appConfig.isLogged || appDelegate.globalUser!.logged
        let isEventActive : Bool? = appConfig.isEventActive
        let appCurrentDate : String? = appConfig.appCurrentDate
        var adminUser : String? = ""
        if (appDelegate.globalUser!.admin){
             adminUser = appDelegate.globalUser?.email
        }
        
        
        let currentappLoggedUser : String? = appConfig.currentAppLoggedUserEmail
        let id : Int16 = appConfig.id + 1
        appConfig.id = id
        
        print ( " saveAppGlobalSettings ", appName)
        print ( " saveAppGlobalSettings ", appSubtitle)
        print ( " saveAppGlobalSettings ", adminUser)
        print ( " saveAppGlobalSettings ", id)
        print ( " saveAppGlobalSettings ", currentappLoggedUser)
        print ( " saveAppGlobalSettings isLogged ", isLogged)
        
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
            print("Could not save saveAppGlobalSettings appconfigs. \(error), \(error.userInfo)")
        }
    }
    
    
    func deleteAllConfigData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppConfigs")
        //fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur3")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            for data in test as! [NSManagedObject] {
                managedContext.delete(data)
            }
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
}
