//
//  SettingsViewController.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/5/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//

import UIKit
import PromiseKit

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
    private let refreshControl = UIRefreshControl()
    
    @IBAction func openModalView(_ sender: Any) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        self.overlayBlurredBackgroundView()
    }
    
    @IBAction func crearEventoAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let event = Event(context: managedContext)
        
        
        event.date = self.txtDatePicker.text!
        event.name = self.eventNameLabel.text
        event.minprice = self.minGiftPriceLabel.text
        
        CoreDataUtils.sharedInstance.createNewEvent(event: event)
        
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
        
        //self.getCoreData()
        self.setupTableView()
        self.refreshListData()
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
    
    private func setupTableView() {
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableViewPersonas.refreshControl = refreshControl
        } else {
            tableViewPersonas.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.3882352941, green: 0.4941176471, blue: 0.9960784314, alpha: 1)
        self.appDelegate.tableViewReference = self.tableViewPersonas
    }
    
    @objc private func  refreshListData(_ sender: Any) {
        // Fetch data
        refreshListData()
    }
    
    
    private func refreshListData() {
        // temporalmente cargamos data hardcore, hasta leer de coredata tabla eventos y persons
        self.getCoreData()
        
    }
    func addPlayer(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.appDelegate.tableViewReference!.beginRefreshing()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.appDelegate.tableViewReference!.endRefreshing()
        }
    }
    
    func getCoreData(){
        
        let userPromise = self.getPlayersFromCoreData()
        userPromise
            .done { (users) in
                
                print("encontro usuarios coredata",users)
                
                self.players.removeAll()
                self.players = users.0!
                
            }
            .catch { (error) in
                
                print("error no hay coredata personas", error)
                
            }
            .finally {
                self.appDelegate.tableViewReference!.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.appDelegate.tableViewReference!.endRefreshing()
                }
                print("finally")
        }
        
        
    }
    
    
    func getPlayersFromCoreData()->Promise<([Person]? , error: NSError?)> {
        return Promise<([Person]? , error: NSError?)> { resolve in
            CoreDataUtils.sharedInstance.getAllPersonsOfEvent(){ (personCoreData, error) in
                var errorLocal:NSError?
                if(personCoreData != nil){
                    print("LOGIN---> Sencontro personas en CORE DATA  count = " , personCoreData?.count as Any)
                    
                    resolve.fulfill((personCoreData!,nil))
                }else{
                    if (error == nil){
                        errorLocal = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "No data Found on Person"])
                    }
                    
                    print("LOGIN--> No encontro Datos en el Core Data Person ", errorLocal as Any)
                    resolve.reject(errorLocal!)
                }
            }
        }
    }
    
    func initView(){
        
        self.tableViewPersonas.delegate = self
        self.tableViewPersonas.dataSource = self
        //self.tableViewPersonas.estimatedRowHeight = 40.0
        //self.tableViewPersonas.rowHeight = UITableView.automaticDimension;
        self.tableViewPersonas.tableFooterView?.tintColor = UIColor.clear
        
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as! PersonaCell
        cell.lblName.text = self.players[indexPath.row].email
        cell.lblState.text = self.players[indexPath.row].state
         
        return cell
    }
  
}

