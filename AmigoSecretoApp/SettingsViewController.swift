//
//  SettingsViewController.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/5/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//

import UIKit

public protocol CustomStringConvertible {
    /// A textual representation of `self`.
    var description: String { get }
}

protocol PlayerStateConvertible {
    func getPlayerState(_ value: String) throws -> String
}

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate/*,tableViewCartaDelegate*/,UITextFieldDelegate, ModalViewControllerDelegate{
    
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var minGiftPriceLabel: UITextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()
    static var sharedInstance = SettingsViewController()

    @IBAction func openModalView(_ sender: Any) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        self.overlayBlurredBackgroundView()
    }
    
    
    func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .extraLight)
        
        view.addSubview(blurredBackgroundView)
        
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowModalView" {
                if let viewController = segue.destination as? ModalViewController {
                    viewController.delegate = self 
                    viewController.modalPresentationStyle = .overFullScreen
                }
            }
        }
    }
    
    func getState(personaState: PlayerState) throws -> String {
        let validator = playerStateFactory.validatorFor(type: PlayerState.pendiente_Descarga_App)
        return try! validator.getPlayerState(" ")
    }
    
   public enum PlayerState {
        case pendiente_Descarga_App
        case resgistrado_App
        case acepto_Jugar_App
        case pendiente_Elegir_Regalo
        case eligio_Regalo
        case sabe_Quien_Regala
        case jugo
    }
    
    public enum playerStateFactory {
        static func validatorFor(type: PlayerState) -> PlayerStateConvertible {
            switch type {
            case .pendiente_Descarga_App:
                return appValidator()
            case .resgistrado_App:
                return appValidator()
            case .acepto_Jugar_App:
                return appValidator()
            case .pendiente_Elegir_Regalo:
                return appValidator()
            case .eligio_Regalo:
                return appValidator()
            case .sabe_Quien_Regala:
                return appValidator()
            case .jugo:
                return appValidator()
            }
        }
    }
    
    struct appValidator: PlayerStateConvertible {
        func getPlayerState(_ value: String) throws -> String {
           
            return "Pendiente de descargar el App"
        }
    }
    
    @IBOutlet weak var tableViewPersonas: UITableView!
    var selectIndexPath : IndexPath!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var players : [Person] = []
    
    override func viewDidLoad() {
        initView()
        super.viewDidLoad()
        selectIndexPath = IndexPath(row : -1, section: -1)
        //let nib = UINib(nibName: "tableViewCarta", bundle: nil)
        
        //tableViewPersonas.register(nib, forHeaderFooterViewReuseIdentifier: "tableviewCarta")
        self.getCoreData()
        showDatePicker()
        
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func addPlayer(player: Person){
        self.players.append(player)
    }
    
    func getCoreData(){
        let managedContext = appDelegate.persistentContainer.viewContext

        var person : Person?
        person = Person(context: managedContext)
        person?.name = "Person 1"
        person?.email = "EmailPerson1@gmail.com"
        person?.state = "Pendiente de descargar el app"
        self.players.append(person!)
        
        var person2 : Person?
        person2 = Person(context: managedContext)
        person2?.name = "Person 2"
        person2?.email = "EmailPerson2@gmail.com"
        person2?.state = "Pendiente de descargar el app"
        self.players.append(person2!)
    }

    func initView(){
        
        self.tableViewPersonas.delegate = self
        self.tableViewPersonas.dataSource = self
        //self.tableViewPersonas.estimatedRowHeight = 40.0
        //self.tableViewPersonas.rowHeight = UITableView.automaticDimension;
        self.tableViewPersonas.tableFooterView?.tintColor = UIColor.clear
        
        let userName = "Mike"
        let url = "www.google.com"
        let degrees: Float = 103.4587254
    }
        
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as! PersonaCell
        cell.lblName.text = self.players[indexPath.row].name
        cell.lblState.text = self.players[indexPath.row].state
         
        return cell
    }
  
}

