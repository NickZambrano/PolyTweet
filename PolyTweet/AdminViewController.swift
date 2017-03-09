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
        }
            cell.fname.text=self.users[indexPath.section].fname
            cell.lname.text=self.users[indexPath.section].lname
            cell.mail.text=self.users[indexPath.section].mail
            cell.user=self.users[indexPath.section]
            if let userEnseignant=self.users[indexPath.section] as? Enseignant {
                cell.unsetResponsable.isHidden = !(userEnseignant.respoDepartement);
                cell.setResponsable.isHidden=(userEnseignant.respoDepartement);
            }else{
                cell.unsetResponsable.isHidden=true;
                cell.setResponsable.isHidden=true;
        }
            cell.layer.cornerRadius=10

            return cell

        
    }
    
    func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alert(title: errorMsg, message: userInfoMsg)
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func delete(userWithIndex index: Int) -> Bool{
        guard let context = self.getContext(errorMsg: "Could not delete user") else {return false}
        let user = self.users[index]
        context.delete(user)
        do{
            try context.save()
            self.users.remove(at: index)
            return true
        }
        catch let error as NSError{
            self.alert(WithTitle: "error")
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle==UITableViewCellEditingStyle.delete){
            self.tableUsers.beginUpdates()
            if self.delete(userWithIndex: indexPath.row){
                self.tableUsers.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.tableUsers.endUpdates()
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



