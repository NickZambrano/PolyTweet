//
//  datePopUpController.swift
//  PolyTweet
//
//  Created by QC on 20/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit

class datePopUpController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var titreTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

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
            
            if date?.compare(Date()) == ComparisonResult.orderedAscending {
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
