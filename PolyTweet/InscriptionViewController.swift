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
class InscriptionViewController: UIViewController, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate {

    var nom : String = "";
    var departements : [Departement] = [];
    var pickOption : [String : Any] = [:];
    var years : [Int] = [3,4,5];
    var year : Int?=nil;
    var departement : Departement?=nil;
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var pickerDepartement: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        imagePicker.delegate = self

        let request : NSFetchRequest<Departement> = Departement.fetchRequest();
        do{
           try departements = CoreDataManager.context.fetch(request)
             pickOption = ["Departement" : departements, "Année" : ["3","4","5"]] as [String : Any]
            
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
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        departement = departements[pickerView.selectedRow(inComponent: 0)]
        year = years[pickerView.selectedRow(inComponent: 1)]
        pickerDepartement.text = (departement?.fullName!)! + " en " + String(describing: year!)+" ème année";
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
        if(component==1){
            co=(pickOption["Année"] as AnyObject).count
        }
        return co
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var co : String = "";
        if(component==0){
            co=departements[row].name!;
        }
        if(component==1){
            co=String(years[row])+" ème année";
        }
        return co
    }
    
    override func prepare (for segue:UIStoryboardSegue, sender : Any?){
        guard self.lname.text != "" && self.fname.text != "" && self.password.text != "" && self.mail.text != "" && departement != nil else {
            let alert = UIAlertController(title: "Erreur", message: "Veuillez remplir tous les champs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } //On vérifie que les champs sont bien remplis
        
        let request : NSFetchRequest<User> = User.fetchRequest();
        let predicate = NSPredicate(format: "mail == %@",self.mail.text!);
        request.predicate=predicate;
         do{
            let result: [User] = try CoreDataManager.context.fetch(request)
            guard result.count==0
                else{
                    let alert = UIAlertController(title: "Erreur", message: "Adresse mail déjà utilisée", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
        }
        catch let error as NSError{
            print(error);
        }
        
    
        if segue.identifier=="signIn"{
            let user = Etudiant(context: CoreDataManager.context)
            user.lname=self.lname.text;
            user.fname=self.fname.text;
            user.lname=self.lname.text;
            user.password=self.password.text;
            user.mail=self.mail.text;
            user.appartient=departement;
            if let image=imageView.image{
                user.img=UIImageJPEGRepresentation(image,1) as NSData?
            }
            let requestYear : NSFetchRequest<Years> = Years.fetchRequest();
            let predicateYear = NSPredicate(format: "numero = %d",year!);
            requestYear.predicate=predicateYear;
            let requestGroup : NSFetchRequest<Group> = Group.fetchRequest();

            do{
                let year = try CoreDataManager.context.fetch(requestYear)
                user.annee=year[0]
                
                let predicateGroup = NSPredicate(format:"annee = %@",year[0])
                requestGroup.predicate=predicateGroup;
                do{
                    let group = try CoreDataManager.context.fetch(requestGroup)
                    user.addToContribue(group[0])
                    group[0].addToContient(user);
                    
                }
                catch let error as NSError{
                    print(error);
                }
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
                year[0].addToEtudiants(user)

            }
            catch let error as NSError{
                print(error);
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
    }
}
