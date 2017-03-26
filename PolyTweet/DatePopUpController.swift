//
//  datePopUpController.swift
//  PolyTweet
//
//  Controller pour l'ajout d'un evenement
//
//  Created by QC on 20/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit

class DatePopUpController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var titreTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    
    var date:Date? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Préremplissage du dateTextField avec la date selectionnée sur le calendrier
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium //Affichage de la date sous la forme : Mer 23, 2017
        let datebis = dateFormatter.string(from: date!)
        dateTextField.text = datebis

        
    }

    //Affichage du date picker lorsque l'on clique sur le dateTextField
    @IBAction func dateEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    override func prepare (for segue:UIStoryboardSegue, sender : Any?){
        if segue.identifier=="addevent"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let date = dateFormatter.date(from: dateTextField.text!)
            
            if date?.compare(Date()) == ComparisonResult.orderedAscending && date?.compare(Date()) == ComparisonResult.orderedSame{
                let alert = UIAlertController(title: "Erreur", message: "Date passée", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            let context=appDelegate.persistentContainer.viewContext
            let event = Evenement(context: context)
            
            event.titre = titreTextField.text
            
            
            event.date =  date as NSDate?
            event.detail = descTextField.text
            
            CoreDataManager.save()
            }
        }
    }
    
    //Fonction pour prendre la date du date picker et la mettre dans le textField
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
