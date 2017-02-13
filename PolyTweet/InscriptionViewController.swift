//
//  InscriptionViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class InscriptionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var nom : String = "";
    var departement : [Departement] = [];
    var pickOption : [String : Any] = [:];
    var years : [Int] = [3,4,5];
    @IBOutlet weak var pickerDepartement: UITextField!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Departement> = Departement.fetchRequest();
        do{
           try departement = context.fetch(request)
             pickOption = ["Departement" : departement, "Année" : ["3","4","5"]] as [String : Any]
            
        }
        catch let error as NSError{
            print(error);
        }
            let pickerView = UIPickerView()
            
            pickerView.delegate = self
            pickerDepartement.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Avenir Next", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Choisissez une année"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        pickerDepartement.inputAccessoryView = toolBar
        
            // Do any additional setup after loading the view, typically from a nib.

        // Do any additional setup after loading the view, typically from a nib.
    }
    /*func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int, inComponent component: Int) {
        pickerDepartement.text = departement[row].fullName
    }*/
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dep = departement[pickerView.selectedRow(inComponent: 0)].fullName
        let year = years[pickerView.selectedRow(inComponent: 1)]
        pickerDepartement.text = dep! + " en " + String(year)+" ème année";
    }

    func donePressed(_ sender: UIBarButtonItem) {
        
        pickerDepartement.resignFirstResponder()
        
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2;
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var co : Int=0;
        if(component==0){
            co=(pickOption["Departement"] as AnyObject).count
        }
        if(component==1){
            co=(pickOption["Année"] as AnyObject).count
        }
        return co
    }/*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departement[row].name;
    }*/
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var co : String = "";
        if(component==0){
            co=departement[row].name!;
        }
        if(component==1){
            co=String(years[row])+" ème année";
        }
        return co
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
