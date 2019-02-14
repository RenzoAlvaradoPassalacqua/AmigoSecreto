//
//  ModalViewController.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/14/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate: class {
    func removeBlurredBackgroundView()
}
class ModalViewController: UIViewController {
    
    weak var delegate: ModalViewControllerDelegate?

    @IBOutlet weak var playerNameLabel: UITextField!
    @IBOutlet weak var playerEmailLabel: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addPlayer: UIButton!
    
    @IBAction func addPlayerAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        var player : Person?
        player = Person(context: managedContext)
        player?.name = playerNameLabel.text
        player?.email = playerEmailLabel.text
        player?.admin = false
        player?.logged = false
        player?.state = "0" //SettingsViewController.sharedInstance.getState(personaState: SettingsViewController.PlayerState.pendiente_Descarga_App)
        
        CoreDataUtils.sharedInstance.createNewPerson(person: player!)
        SettingsViewController.sharedInstance.addPlayer(player: player!)
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIViewController.removeSpinner(spinner: sv)
            self.dismiss(animated: true, completion: nil)
            self.delegate?.removeBlurredBackgroundView()
        }
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        
        //ensure that the icon embeded in the cancel button fits in nicely
        cancelButton.imageView?.contentMode = .scaleAspectFit
        
        //add a white tint color for the Cancel button image
        let cancelImage = UIImage(named: "Cancel")
        
        let tintedCancelImage = cancelImage?.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(tintedCancelImage, for: .normal)
        cancelButton.tintColor = .white
    }
  
    
}
