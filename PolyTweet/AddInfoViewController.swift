//
//  CommonViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class AddInfoViewController : CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
      var user:User?=nil;
    
    @IBOutlet weak var titreField: UITextField!
    
    @IBOutlet weak var photoTextField: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nomLien: UITextField!
    @IBOutlet weak var lienTextField: UITextField!
    @IBOutlet weak var contenuField: UITextField!
    
    let imagePickerController = UIImagePickerController()
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        self.photo.clipsToBounds = true;
        user=SingleUser.getUser();

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    @IBAction func addInfo(_ sender: Any) {
        if lienTextField.text != nil && lienTextField.text != "" {
            if !canOpenURL(string: lienTextField.text){
                /*let alert : UIAlertView = UIAlertView(title: "Erreur", message: "Mauvaise URL",       delegate: nil, cancelButtonTitle: "Retour")
                 
                 alert.show()*/
                let alert = UIAlertController(title: "Erreur", message: "Mauvaise URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                
                let context=CoreDataManager.context
                
                let info=Information(context:context);
                info.titre=titreField.text;
                info.contenu=contenuField.text;
                info.departement=user?.appartient;
                
                if self.photo.image != nil {     //On regarde s'il y a une piece jointe image
                    let pieceimage = PieceJointeImage(context:context);
                    
                    
                    
                    if self.photo.image != nil {
                        pieceimage.file = UIImageJPEGRepresentation(self.photo.image!,1) as NSData?
                        pieceimage.name = self.photoTextField.text
                    }
                    info.image=pieceimage

                }
                
                if self.lienTextField != nil{ //On regarde s'il y a un lien
                    let piecelien = PieceJointeLien(context:context);
                    piecelien.file = self.lienTextField.text?.data(using: .utf8)! as NSData?
                    piecelien.name = self.nomLien.text
                    info.lien=piecelien
                }
                CoreDataManager.save();
            }
        }
        else{
            let context=CoreDataManager.context
            
            let info=Information(context:context);
            info.titre=titreField.text;
            info.contenu=contenuField.text;
            info.departement=user?.appartient;
            
            if self.photo.image != nil {     //On regarde s'il y a une piece jointe image
                let pieceimage = PieceJointeImage(context:context);
                
                
                
                if self.photo.image != nil {
                    pieceimage.file = UIImageJPEGRepresentation(self.photo.image!,1) as NSData?
                    pieceimage.name = self.photoTextField.text
                }
                info.image=pieceimage
                
            }
            

            CoreDataManager.save();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    
    
}

