//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class AdminViewController: CommonViewController, UITableViewDataSource,UITableViewDelegate{
    
    
    var user:User?=nil;
    
    
    var users : [User] = []
    
    
    

    @IBOutlet weak var tableUsers: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user=SingleUser.getUser();
        loadUsers()
      
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.users.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1

    }

    func loadUsers(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<User> = User.fetchRequest();
        let predicate = NSPredicate(format: "appartient == %@",(user?.appartient)!);
        request.predicate=predicate;
        do{
            users = try context.fetch(request)

        }
        catch let error as NSError{
            print(error);
        }
        
        self.tableUsers.reloadData()
    }

    @IBAction func loadAll(_ sender: Any) {
        loadUsers()
    }

    @IBAction func loadAllEtudiants(_ sender: Any) {
        loadEtudiants()
    }

    @IBAction func loadAllEnseignants(_ sender: Any) {
        loadProfesseur()
    }
    

    func loadEtudiants(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Etudiant> = Etudiant.fetchRequest();
        let predicate = NSPredicate(format: "appartient == %@",(user?.appartient)!);
        request.predicate=predicate;
        do{
            users = try context.fetch(request)
            
        }
        catch let error as NSError{
            print(error);
        }
        
        self.tableUsers.reloadData()
    }
    func loadProfesseur(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Enseignant> = Enseignant.fetchRequest();
        let predicate = NSPredicate(format: "appartient == %@",(user?.appartient)!);
        request.predicate=predicate;
        do{
            users = try context.fetch(request)
            
        }
        catch let error as NSError{
            print(error);
        }
        
        self.tableUsers.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.tableUsers.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
            cell.fname.text=self.users[indexPath.row].fname
            cell.lname.text=self.users[indexPath.row].lname
            cell.mail.text=self.users[indexPath.row].mail
            cell.user=self.users[indexPath.row]
            if let userEnseignant=self.users[indexPath.row] as? Enseignant {
                cell.unsetResponsable.isHidden = !(userEnseignant.respoDepartement);
                cell.setResponsable.isHidden=(userEnseignant.respoDepartement);
            }else{
                cell.unsetResponsable.isHidden=true;
                cell.setResponsable.isHidden=true;
        }
            return cell

        
    }
    
    
}



