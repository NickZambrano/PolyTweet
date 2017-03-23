//
//  AttachedFilePopUpController.swift
//  PolyTweet
//
//  Created by QC on 14/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class AttachedFilePopUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet var photo: UIImageView!
    @IBOutlet weak var photoTextField: UITextField!
    
    @IBOutlet weak var lienTextField: UITextField!
    @IBOutlet weak var nomLien: UITextField!


    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        self.photo.clipsToBounds = true;
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        let actionsheet = UIAlertController(title: "Changer ma photo :", message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }else{print("Camera non disponible")}
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Bibliothèque Photo", style: .default, handler: {(action:UIAlertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        
        if let popoverPresentationController = actionsheet.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        self.present(actionsheet, animated: true, completion: nil)
        
    }
    
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
     {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.contentMode = .scaleAspectFit
            photo.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func sendFiles(_ sender: Any) {
        if lienTextField.text != nil && lienTextField.text != "" {
            if !canOpenURL(string: lienTextField.text){

                let alert = UIAlertController(title: "Erreur", message: "Mauvaise URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "unwindFromAttachedFile", sender: sender)
            }
        }
        else{
            self.performSegue(withIdentifier: "unwindFromAttachedFile", sender: sender)
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

