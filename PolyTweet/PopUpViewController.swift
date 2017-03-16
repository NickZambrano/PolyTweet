//
//  PopUpViewController.swift
//  PolyTweet
//
//  Created by QC on 07/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class PopUpViewController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var user:User?=nil;
    
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var statusUser: UILabel!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user=SingleUser.getUser();
        username.text="@"+(user?.fname)!+(user?.lname)!;
        username.textAlignment = .center;
        self.photo.clipsToBounds = true;
        if let image=user?.img {
            photo.image=UIImage(data: image as Data)!
        }
        imagePickerController.delegate = self
        if (user as? Etudiant) != nil {
            statusUser.text="Etudiant";
        }
        if (user as? Administration) != nil {
            statusUser.text="Administration";
        }
        if (user as? Enseignant) != nil {
            statusUser.text="Enseignant";
        }
        
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePickerController, animated: true, completion: nil)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.contentMode = .scaleAspectFit
            photo.image = pickedImage
            photo.contentMode = .scaleAspectFill
            user?.img=UIImageJPEGRepresentation(pickedImage,1) as NSData?
            //picker.dismiss(animated: true, completion: nil)
            
            CoreDataManager.save();
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func dismissPopUp(_ sender: UIButton) {
    }
}
