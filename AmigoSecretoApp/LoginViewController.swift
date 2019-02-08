//
//  ViewController.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 12/8/17.
//  Copyright © 2017 Back4App. All rights reserved.
//

import UIKit
import PromiseKit

class LoginViewController: UIViewController {
    @IBOutlet fileprivate var signInUsernameField: UITextField!
    @IBOutlet fileprivate var signInPasswordField: UITextField!
    @IBOutlet fileprivate var signUpUsernameField: UITextField!
    @IBOutlet fileprivate var signUpPasswordField: UITextField!
    @IBOutlet fileprivate var appNameLabel: UILabel!
    @IBOutlet fileprivate var appSubtitleLabel: UILabel!
    @IBOutlet fileprivate var statusLabel: UILabel!
    @IBOutlet fileprivate var signUpBtn: UIButton!
    @IBOutlet fileprivate var SignInBtn: UIButton!
    @IBOutlet fileprivate var adminSw: UISwitch!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var person: Person?
    var appConfig: AppConfigs?
    var isRegistered : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInUsernameField.text = ""
        signInPasswordField.text = ""
        signUpUsernameField.text = ""
        signUpPasswordField.text = ""
        appNameLabel.text = ""
        appSubtitleLabel.text = ""
        statusLabel.text = ""
        adminSw.isOn = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        /*
         let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
        */
        self.initView()
    }
 
    func validateRegistro() {
        do {
            let email = try self.signUpUsernameField.validatedText(validationType: .requiredField(field: "email"))
            let password = try self.signUpPasswordField.validatedText(validationType: .requiredField(field: "password"))
            let emailVal = try signUpUsernameField.validatedText(validationType: ValidatorType.email)
            let passwordVal = try signUpPasswordField.validatedText(validationType: ValidatorType.password)
            let data = RegisterData(email: email, password: password )
            save(data)
        } catch(let error) {
            self.statusLabel.text = (error as! ValidationError).message
            //showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func save(_ data: RegisterData) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        signUpBtn.isEnabled = false
     
        
        register(spiner: sv)
        
        
    }
    
    fileprivate func searchForRegUser(spiner:UIView) {
        let userPromise = self.getUserCoreDataByEmail(emailParam: signInUsernameField.text ?? " ")
        userPromise
            .done { (user) in
                
                print("encontro usuario coredata",user)
                self.statusLabel.text = "Se encontró el usuario: " + self.signInUsernameField.text! + ", Iniciando Sessión..."
                self.signInUsernameField.text = ""
                self.signInPasswordField.text = ""
                self.signInUsernameField.isEnabled = false
                self.signInPasswordField.isEnabled = false
                self.SignInBtn.isEnabled = false
                self.person?.logged = true
            }
            .catch { (error) in
                
                print("error no hay coredata", error)
                self.statusLabel.text = "No se encontro el usuario: " + self.signInUsernameField.text! + " registrado."
            }
            .finally {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIViewController.removeSpinner(spinner: spiner)
                }
                print("finally")
        }
    }
    
    func initView(){
        let managedContext = appDelegate.persistentContainer.viewContext
   
        // CoreDataUtils.sharedInstance.updateAppGlobalSettings(appConfig: self.globalAppSettings!)
        CoreDataUtils.sharedInstance.preloadAppGlobalSettings()
        person = Person(context: managedContext)
        appConfig = appDelegate.globalAppSettings
        appNameLabel.text = appConfig?.appName
        appSubtitleLabel.text = appConfig?.appSubtitle
        let adminUser: Person? = (appConfig?.adminUser)
        if (adminUser != nil){
            self.isRegistered = true
            appConfig?.isLogged = true
            
            loadHomeScreen()
        }
        else{
            self.isRegistered = false
        }
        
    }
    
    func register(spiner : UIView){
        person?.email = signUpUsernameField.text
        person?.password = signUpPasswordField.text
       
        
        
        CoreDataUtils.sharedInstance.createNewPerson(person: person!)
        let managedContext = appDelegate.persistentContainer.viewContext
        let appConfig = appDelegate.globalAppSettings
        appConfig!.appName = "Amigo Secreto"
        appConfig!.appSubtitle = "@ by Belatrixsf"
        appConfig!.id = 1
        if (self.adminSw.isOn){
            appConfig!.adminUser = person
        }
        CoreDataUtils.sharedInstance.updateAppGlobalSettings(appConfig: appConfig!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIViewController.removeSpinner(spinner: spiner)
            self.statusLabel.text = "Registro Satisfactorio !"
            
           
            
            self.signUpUsernameField.text = ""
            self.signUpPasswordField.text = ""
            self.signUpUsernameField.isEnabled = false
            self.signUpPasswordField.isEnabled = false
            self.adminSw.isEnabled = false
            
        }
    }
    
    func getUserCoreDataByEmail(emailParam:String)->Promise<(Person? , error: NSError?)> {
        return Promise<(Person? , error: NSError?)> { resolve in
            CoreDataUtils.sharedInstance.searchPersonByEmail(email: emailParam){ (personCoreData, error) in
                var errorLocal:NSError?
                if(personCoreData != nil){
                    print("LOGIN---> Encontro una persona en CORE DATA by Email = ", personCoreData?.email as Any)
                    
                    resolve.fulfill((personCoreData!,nil))
                }else{
                    if (error == nil){
                        errorLocal = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Person"])
                    }
                    
                    print("LOGIN--> No encontro Datos en el Core Data Person by Email ", errorLocal as Any)
                    resolve.reject(errorLocal!)
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadHomeScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
    }

    @IBAction func signIn(_ sender: UIButton) {
        let sv: UIView = UIViewController.displaySpinner(onView: self.view)
        
        searchForRegUser(spiner: sv)
        
    }

    @IBAction func signUp(_ sender: UIButton) {
        validateRegistro()
        
    }

    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }

    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
