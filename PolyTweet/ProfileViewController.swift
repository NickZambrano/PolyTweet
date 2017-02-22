//
//  ProfileViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class ProfileViewController : CommonViewController {
    
    var user:User?=nil;
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
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

    }

    @IBAction override func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
