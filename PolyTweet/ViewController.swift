//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Connexion: UIButton!
    var nom : String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func connexion(_ sender: Any) {
        
        if let user=self.username.text{
            self.nom=user;
        }else{
            self.nom="";
        }
        self.password.text=self.nom;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare (for segue:UIStoryboardSegue, sender : Any?){
        if segue.identifier=="toInscription"{
            let inscriptionViewController = segue.destination as! InscriptionViewController;
            if let user=self.username.text{
                inscriptionViewController.nom=self.username.text!;
            }else{
                inscriptionViewController.nom="";
            }
            
        }
    }

}

