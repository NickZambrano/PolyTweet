//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class ViewController: CommonViewController {
    @IBOutlet weak var username: UITextField!
    var user: User?=nil;

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Connexion: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        alreadyConnected();

    }
    
        // Do any additional setup after loading the view, typically from a nib.
    //Calls this function when the tap is recognized.

    @IBAction func connexion(_ sender: Any) {
        
        if let username=self.username.text{

            if let pass=self.password.text{
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                    return
                }
                let context=appDelegate.persistentContainer.viewContext

                let request : NSFetchRequest<Etudiant> = Etudiant.fetchRequest();
                let predicate = NSPredicate(format: "mail == %@",username);
                request.predicate=predicate;
                do{
                    let result: [Etudiant] = try context.fetch(request)
                    if(result.count>0){
                        if(result[0].password==pass){
                            user=result[0];
                            SingleUser.setUser(userToSet: user!);
                            performSegue(withIdentifier: "login", sender: self)

                        }
                        else{
                            self.alert(title:"Erreur", message:"Erreur d'identifiant");
                        }
                    }
                    else{
                        self.alert(title:"Erreur", message:"Erreur d'identifiant");

                    }
                }
                catch let error as NSError{
                    print(error);
                }

            }
            self.alert(title:"Erreur", message:"Erreur d'identifiant");

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func alreadyConnected(){
        if (SingleUser.getUser() != nil){
            performSegue(withIdentifier: "login", sender: self)
        } else {
            // Have to login
        }
    }
    override func prepare (for segue:UIStoryboardSegue, sender : Any?){

    }

}

