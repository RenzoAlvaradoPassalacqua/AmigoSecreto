//
//  SettingsViewController.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/5/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate/*,tableViewCartaDelegate*/,UITextFieldDelegate{
    
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var minGiftPriceLabel: UITextField!
    
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
        
    }
    func getCoreData(){
        
    }

    func initView(){
        
        self.tableViewPersonas.delegate = self
        self.tableViewPersonas.dataSource = self
        //self.tableViewPersonas.estimatedRowHeight = 40.0
        //self.tableViewPersonas.rowHeight = UITableView.automaticDimension;
        self.tableViewPersonas.tableFooterView?.tintColor = UIColor.clear
        
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //self.players.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //self.players[section].personas!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as! PersonaCell
        cell.lblName.text = " ej persona1 " // +self.dishe[indexPath.section].dishes![indexPath.row].name
        cell.lblState.text = " ej estado 1"  // +self.dishe[indexPath.section].dishes![indexPath.row].description!
         
        return cell
    }
  
}

