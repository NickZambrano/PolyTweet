//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class HomeViewController: CommonViewController {
    
    
    var user:User?=nil;
    
    


    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var photo: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2;
        self.photo.clipsToBounds = true;
        if let image=user?.img {
            photo.image=UIImage(data: image as Data)!
        }
        

        
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let message = Message(context:context);
        if let contenu=messageField.text{
            message.contenu=contenu
            message.sendBy=user
            message.dep=user?.appartient
        }
    }
    // Do any additional setup after loading the view, typically from a nib.
    //Calls this function when the tap is recognized.


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*override func prepare (for segue:UIStoryboardSegue, sender : Any?){
     if segue.identifier=="toInscription"{
     let inscriptionViewController = segue.destination as! InscriptionViewController;
     if let user=self.username.text{
     inscriptionViewController.nom=user;
     }else{
     inscriptionViewController.nom="";
     }
     
     }
     }*/
    
}

