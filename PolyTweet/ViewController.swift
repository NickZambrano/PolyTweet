//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Connexion: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Departement> = Departement.fetchRequest();
        do{
            let result: [Departement] = try context.fetch(request)

            print(result.count);
                if(result.count==0){
                    let ig = Departement(context:context);
                    ig.name="IG";
                    ig.fullName="Informatique et Gestion";
                    let mea = Departement(context:context);
                    mea.name="MEA";
                    mea.fullName="Microélectronique et Automatique";
                    let mat = Departement(context:context);
                    mat.name="MAT";
                    mat.fullName="Matériaux";

                    let gba = Departement(context:context);
                    gba.name="GBA";
                    gba.fullName="Génie biologique et Agroalimentaire";

                    let ste = Departement(context:context);
                    ste.name="STE";
                    ste.fullName="Sciences et Technologies de l'eau";

                    let mi = Departement(context:context);
                    mi.name="MI";
                    mi.fullName="Mécanique et Interactions";

                    let msi = Departement(context:context);
                    msi.name="MSI";
                    msi.fullName="Mécanique structures industrielles";

                    let se = Departement(context:context);
                    se.name="SE";
                    se.fullName="Systèmes embarqués";

                    do{
                        try context.save();
                    }
                    catch let error as NSError{
                        print(error);
                    }
              }
        }
        catch let error as NSError{
            print(error);
        }

    }
    
        // Do any additional setup after loading the view, typically from a nib.
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 100
            }
        
    }
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
        
        if let user=self.username.text{

            if let pass=self.password.text{
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                    return
                }
                let context=appDelegate.persistentContainer.viewContext

                let request : NSFetchRequest<Etudiant> = Etudiant.fetchRequest();
                let predicate = NSPredicate(format: "mail == %@",user);
                request.predicate=predicate;
                do{
                    let result: [Etudiant] = try context.fetch(request)
                    if(result.count>0){
                        if(result[0].password==pass){
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
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
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

