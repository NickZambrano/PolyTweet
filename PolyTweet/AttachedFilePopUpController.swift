//
//  AttachedFilePopUpController.swift
//  PolyTweet
//
//  Created by QC on 14/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class AttachedFilePopUpController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
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
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePickerController, animated: true, completion: nil)
        
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
                let alert : UIAlertView = UIAlertView(title: "Erreur", message: "Mauvaise URL",       delegate: nil, cancelButtonTitle: "Retour")
                
                alert.show()
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

