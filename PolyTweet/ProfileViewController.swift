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
    let imagePicker = UIImagePickerController()
    
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
        imagePicker.delegate = self
    }

    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.contentMode = .scaleAspectFit
            photo.image = pickedImage
            photo.contentMode = .scaleAspectFill
            user?.img=UIImageJPEGRepresentation(pickedImage,1) as NSData?
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
