//
//  LoggedInViewController.swift
//  AddingParseSDK
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/5/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//

import UIKit
import PromiseKit

class LoggedInViewController: UIViewController, UITabBarControllerDelegate {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var event :Event?
    
    @IBOutlet weak var userLoggedLabel: UILabel!
    @IBOutlet weak var numEventsLabel: UILabel!
  
    @IBOutlet weak var fechaEvento: UILabel!
    
   
    @IBAction func crearEventoAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        appDelegate?.startPushNotifications()
        
        initView()
        
        
    }

    func initView(){
        
        self.userLoggedLabel.isHidden = true
        self.userLoggedLabel.text = ""
        self.numEventsLabel.text = ""
        self.getGlobalSettingsFromCoreData()
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let userLoggedEmail = appDelegate?.globalAppSettings?.adminUserEmail
        searchForEvents(spiner: sv, userLogged: userLoggedEmail)
        tabBarController?.delegate = self
    }
    
    func prelaodGlobalSettings(){
        
        let userLoggedEmail = appDelegate?.globalAppSettings?.currentAppLoggedUserEmail
        self.userLoggedLabel.text = "Bienvenido : " + (userLoggedEmail ?? " ") + "!"
        self.userLoggedLabel.isHidden = false
        
        self.numEventsLabel.text = "No hay eventos creados!"
        
        if (appDelegate?.globalAppSettings?.isEventActive ?? false){
            self.numEventsLabel.text = "Tienes un evento creado!"
        }else{
            self.numEventsLabel.text = "No hay eventos creados!"
        }
        
        
    }
    
    @IBAction func logoutOfApp(_ sender: UIButton) {
       self.logOut()
    }

    func logOut(){
        let sv = UIViewController.displaySpinner(onView: self.view)
        appDelegate?.globalAppSettings?.isLogged = false
        appDelegate?.globalAppSettings?.currentAppLoggedUserEmail = ""
        appDelegate?.globalUser?.logged = false
        
        CoreDataUtils.sharedInstance.deleteAllConfigData()
        CoreDataUtils.sharedInstance.createAppGlobalSettings(appConfig: appDelegate!.globalAppSettings!)
        CoreDataUtils.sharedInstance.readAppConfigsToDelegate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIViewController.removeSpinner(spinner: sv)
            self.loadLoginScreen()
        }
    }
    func getEventsCoreDataByEmail(emailParam:String)->Promise<(Event? , error: NSError?)> {
        return Promise<(Event? , error: NSError?)> { resolve in
            CoreDataUtils.sharedInstance.searchEventByEmail(email: emailParam){ (eventCoreData, error) in
                var errorLocal:NSError?
                if(eventCoreData != nil){
                    print("LOGGED---> Encontro eventos en CORE DATA by Email = ", eventCoreData?.name as Any)
                    
                    resolve.fulfill((eventCoreData!,nil))
                }else{
                    if (error == nil){
                        errorLocal = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Event"])
                    }
                    
                    print("LOGIN--> No encontro Datos event en el Core Data Person by Email ", errorLocal as Any)
                    resolve.reject(errorLocal!)
                }
            }
        }
    }
    
    fileprivate func searchForEvents(spiner:UIView, userLogged:String?) {
        
        let userPromise = self.getEventsCoreDataByEmail(emailParam: userLogged ?? " ")
        userPromise
            .done { (event) in
                
                print("encontro event coredata",event)
                
                self.event = event.0!
                self.numEventsLabel.text = "Tienes un evento creado! nombre : " + self.event!.name! 
                self.fechaEvento.text = "Fecha : " + (self.event?.date)!
            }
            .catch { (error) in
                
                print("error no hay eventos en coredata", error)
                 
            }
            .finally {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIViewController.removeSpinner(spinner: spiner)
                    
                    
                }
                print("finally")
        }
    
    }
    
    func displayMessage(message:String) {
        let alertView = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }

    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(viewController, animated: true, completion: nil)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is LoggedOut {
            
            let alertMensaje = "¿ Está seguro que desea cerrar sesión ? "
            self.showMessage(Message: (alertMensaje))
            return false
            
        }
        
        return true
    }
    
    func showMessage( Message : String){
        let alert = UIAlertController(title: "Cerrar Sesión", message: Message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.logOut()
          
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getGlobalSettingsFromCoreData(){
        
        let userPromise = self.getGlobalSetingsFromCoreData()
        userPromise
            .done { (settings) in
                
                print("encontro settings coredata",settings)
                
                
                self.appDelegate?.globalAppSettings = settings.0!
                self.prelaodGlobalSettings()
            }
            .catch { (error) in
                
                print("error no hay coredata personas", error)
                
            }
            .finally {
                
                
                print("finally getGlobalSettingsFromCoreData ")
        }
        
        
    }
    
    func getGlobalSetingsFromCoreData()->Promise<(AppConfigs? , error: NSError?)> {
        return Promise<(AppConfigs? , error: NSError?)> { resolve in
            CoreDataUtils.sharedInstance.readAppConfigsToDelegateAdmin(){ (globalSetings, error) in
                var errorLocal:NSError?
                if(globalSetings != nil){
                    print("LOGIN---> Se encontro globalSetings en CORE DATA  = " , globalSetings as Any)
                    
                    resolve.fulfill((globalSetings,nil))
                }else{
                    if (error == nil){
                        errorLocal = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on globalSetings "])
                    }
                    
                    print("LOGIN--> No encontro Datos en el Core Data globalSetings ", errorLocal as Any)
                    resolve.reject(errorLocal!)
                }
            }
        }
    }
    
    
}
