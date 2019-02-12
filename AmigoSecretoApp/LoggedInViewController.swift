//
//  LoggedInViewController.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 4/12/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import UIKit


class LoggedInViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var userLoggedLabel: UILabel!
    @IBOutlet weak var numEventsLabel: UILabel!
    @IBOutlet weak var crearEventoBtn: UIButton!
    
    
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
        
        prelaodGlobalSettings()
    }
    
    func prelaodGlobalSettings(){
        
        let userLoggedEmail = appDelegate?.globalAppSettings?.adminUserEmail
        self.userLoggedLabel.text = "Bienvenido : " + userLoggedEmail! + "!"
        self.userLoggedLabel.isHidden = false
        
        self.numEventsLabel.text = "No hay eventos creados!"
        
        if (appDelegate?.globalAppSettings?.isEventActive ?? false){
            self.numEventsLabel.text = "Tienes un evento creado!"
        }else{
            self.numEventsLabel.text = "No hay eventos creados!"
        }
        
        
    }
    
    @IBAction func logoutOfApp(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        appDelegate?.globalAppSettings?.isLogged = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIViewController.removeSpinner(spinner: sv)
            self.loadLoginScreen()
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


}
