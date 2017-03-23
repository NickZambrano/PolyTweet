//
//  ProfileViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class ResetPasswordViewController : UIViewController {
    
    var user:User?=nil;
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user=SingleUser.getUser();
    }
    @IBAction func valider(_ sender: Any) {
        if(user?.password == oldPassword.text){
            user?.password=newPassword.text
            CoreDataManager.save();
            dismiss(animated: true, completion: nil)
        }else {
            self.alert(title:"Erreur", message:" L'ancien mot de passe n'est pas le bon");
        }
        
    }
    
}
