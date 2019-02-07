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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var person: Person?
    var appConfig: AppConfigs?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInUsernameField.text = ""
        signInPasswordField.text = ""
        signUpUsernameField.text = ""
        signUpPasswordField.text = ""
        appNameLabel.text = ""
        appSubtitleLabel.text = ""
         
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

    fileprivate func searchForRegUser(spiner:UIView) {
        let userPromise = self.getUserCoreDataByEmail(emailParam: signInUsernameField.text ?? " ")
        userPromise
            .done { (user) in
                
                print("encontro usuario coredata",user)
            }
            .catch { (error) in
                
                print("error no hay coredata", error)
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
        person = Person(context: managedContext)
        appConfig = appDelegate.globalAppSettings
        appNameLabel.text = appConfig?.appName
        appSubtitleLabel.text = appConfig?.appSubtitle
        
    }
    
    func register(spiner : UIView){
        person?.email = signUpUsernameField.text
        person?.password = signUpPasswordField.text
        
        CoreDataUtils.sharedInstance.createNewPerson(person: person!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIViewController.removeSpinner(spinner: spiner)
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
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        register(spiner: sv)
        
       
        
        /*let user = PFUser()
        user.username = signUpUsernameField.text
        user.password = signUpPasswordField.text
        let sv = UIViewController.displaySpinner(onView: self.view)
        user.signUpInBackground { (success, error) in
            UIViewController.removeSpinner(spinner: sv)
            if success{
                self.loadHomeScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
         ∫*/
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

}
