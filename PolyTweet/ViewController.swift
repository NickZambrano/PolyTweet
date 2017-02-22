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

    }
    
        // Do any additional setup after loading the view, typically from a nib.
    //Calls this function when the tap is recognized.

    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest :NSFetchRequest<Departement> = Departement.fetchRequest();
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
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
                            UserDefaults.standardUserDefaults.setValue(user, forKey: "defaultUser")
                            
                            UserDefaults.standard.synchronize()
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
        if let token =   UserDefaults.standard.value(forKey: "defaultUser") as? NSString {
            // Token stored in NSUserDefaults.
        } else {
            // Have to login
        }
    }
    override func prepare (for segue:UIStoryboardSegue, sender : Any?){
        if segue.identifier=="login"{
            let homeViewController = segue.destination as! HomeViewController;
            if let userConnected=user{
                homeViewController.user=userConnected;
            }
            
        }
    }

}

