//
//  ProfileViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class ProfileViewController : CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2;
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
        
        /*let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
            
            
        }))
        
        actionSheet.popoverPresentationController?.sourceView = photo
        
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)*/
    }
    

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
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
    
    @IBAction override func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
