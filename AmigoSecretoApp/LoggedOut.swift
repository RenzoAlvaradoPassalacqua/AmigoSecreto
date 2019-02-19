//
//  LoggedOut.swift
//  Manyar
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/5/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//
import UIKit
import CoreData

class LoggedOut: UIViewController, UITabBarControllerDelegate{
    @IBOutlet weak var lblMensaje: UILabel!
    
    var alertMensaje = "¿ Está seguro que desea salir de la aplicación ? "
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblMensaje.text = self.alertMensaje
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Cerrar tab")
    }                         
}
