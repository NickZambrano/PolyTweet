//
//  CommonViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData

//Permet d'ajouter une nouvelle information
class AddInfoViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
      var user:User?=nil;
    
    @IBOutlet weak var titreField: UITextField!
    
    @IBOutlet weak var photoTextField: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nomLien: UITextField!
    @IBOutlet weak var lienTextField: UITextField!
    @IBOutlet weak var contenuField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        self.photo.clipsToBounds = true;
        user=SingleUser.getUser();
        
    }
    
    let imagePickerController = UIImagePickerController()
    
    //Fonction permettant de charger des images de la librairie
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //enleve la popup pour l'image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //affiche l'image selectionné
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.contentMode = .scaleAspectFit
            photo.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    //Fonction permettant de tester si c'est un lien valide
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    
    
}

