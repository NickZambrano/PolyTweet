//
//  InscriptionEnseignantViewController.swift
//  PolyTweet
//
//  Created by QC on 02/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class InscriptionEnseignantViewController: UIViewController, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate {
    
    var nom : String = "";
    var departements : [Departement] = [];
    var pickOption : [String : Any] = [:];
    var departement : Departement?=nil;
    

    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var pickerDepartement: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        imagePicker.delegate = self
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Departement> = Departement.fetchRequest();
        do{
            try departements = context.fetch(request)
            pickOption = ["Departement" : departements] as [String : Any]
            
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
        departement = departements[pickerView.selectedRow(inComponent: 0)]
        pickerDepartement.text = (departement?.fullName!)!;
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        pickerDepartement.resignFirstResponder()
        
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        let actionsheet = UIAlertController(title: "Changer ma photo :", message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }else{print("Camera non disponible")}
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Bibliothèque Photo", style: .default, handler: {(action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        
        if let popoverPresentationController = actionsheet.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        self.present(actionsheet, animated: true, completion: nil)
        
        /*imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var co : Int=0;
        if(component==0){
            co=(pickOption["Departement"] as AnyObject).count
        }
        return co
    }/*
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return departement[row].name;
     }*/
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var co : String = "";
        if(component==0){
            co=departements[row].name!;
        }
        return co
    }
    
    override func prepare (for segue:UIStoryboardSegue, sender : Any?){
        if segue.identifier=="signIn"{
            let user = Enseignant(context: CoreDataManager.context)
            user.lname=self.lname.text;
            user.fname=self.fname.text;
            user.lname=self.lname.text;
            user.password=self.password.text;
            user.mail=self.mail.text;
            user.appartient=departement;
            user.img=UIImageJPEGRepresentation(imageView.image!,1) as NSData?
            let requestGroup : NSFetchRequest<Group> = Group.fetchRequest();
            
            do{

                let predicateGroupGeneral = NSPredicate(format:"name = %@","Général")
                requestGroup.predicate=predicateGroupGeneral;
                do{
                    let group = try CoreDataManager.context.fetch(requestGroup)
                    user.addToContribue(group[0])
                    group[0].addToContient(user);
                    
                }
                catch let error as NSError{
                    print(error);
                }
                
            }
            
            departement?.addToContient(user);
            CoreDataManager.save();
        }
    }
    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
