//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
class AdminViewController: CommonViewController, UITableViewDataSource, UITableViewDelegate,SwipeTableViewCellDelegate{
    
    
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
            return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
            return self.users.count

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
        
        if let image=self.users[indexPath.section].img{
            cell.photo.image=UIImage(data: image as Data)!
            cell.photo.layer.cornerRadius = cell.photo.layer.frame.size.width / 2;
            cell.photo.clipsToBounds = true;
            cell.photo.contentMode = .scaleAspectFill
        }else{
            cell.photo.image=nil;
        }
            cell.fname.text=self.users[indexPath.section].fname
            cell.lname.text=self.users[indexPath.section].lname
            cell.mail.text=self.users[indexPath.section].mail
            cell.user=self.users[indexPath.section]
            cell.delegate = self
        if let userEnseignant=self.users[indexPath.section] as? Enseignant {
                cell.setResponsable.isHidden=false;
                if(userEnseignant.respoDepartement){
                    cell.setResponsable.setTitle("Responsable", for: .normal);
                }else{
                    cell.setResponsable.setTitle("Non Responsable", for: .normal)
                }

            }else{
                cell.setResponsable.isHidden=true;
        }
        
            cell.layer.cornerRadius = 10

            return cell

        
    }
    
    func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alert(title: errorMsg, message: userInfoMsg)
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }



    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        switch orientation{
        case .right :
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                let user = self.users[indexPath.section]
                CoreDataManager.context.delete(user)
                CoreDataManager.save()
                self.users.remove(at: indexPath.section)
                self.tableUsers.reloadData()
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
            
        
        
        case .left :
            let respoAction = SwipeAction(style: .default, title: "Responsable") { action, indexPath in
                if let enseignant = self.users[indexPath.section] as? Enseignant{
                    print("hey")
                    enseignant.respoDepartement = !(enseignant.respoDepartement);
                    CoreDataManager.save();
                    self.tableUsers.reloadData()
                    
                }
            }
            
            // customize the action appearance
            respoAction.image = UIImage(named: "modify")

            
            return [respoAction]
        }

        

    }
    
    func alert(WithTitle title: String, andMessage msg: String = "") {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated:true)
    }
    
    @IBAction override func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

}



