//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class HomeViewController: CommonViewController, UITableViewDataSource,UITableViewDelegate{
    
    
    var user:User?=nil;
    
    
    var messages : [Message] = []
    var groupSelected : Group?=nil;

    var groupes : [Group]=[]
    @IBOutlet weak var tableMessage: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var tableGroupes: UITableView!
    
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        user=SingleUser.getUser();
        let context=appDelegate.persistentContainer.viewContext

        let requestGroupeGeneral : NSFetchRequest<Group> = Group.fetchRequest();
        let nameGroupe : String = "Général"
        let predicateGroupeGeneral = NSPredicate(format: "name == %@",nameGroupe);
        requestGroupeGeneral.predicate=predicateGroupeGeneral;
        do{
            let groupeSel = try context.fetch(requestGroupeGeneral)
            print(groupeSel.count)
            groupSelected=groupeSel[0]
        }
        catch let error as NSError{
                print(error);
        }
        groupes=(user?.contribue)!.allObjects as! [Group];
        loadMessage()

        //
        self.username.text="@"+(user?.fname)!+(user?.lname)!;
        self.username.textAlignment = .center
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2;
        self.photo.clipsToBounds = true;
        if let image=user?.img {
            photo.image=UIImage(data: image as Data)!
        }
        self.tableGroupes.allowsSelection = true
        


        
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
            message.date=NSDate()
            message.dep=user?.appartient
            message.groupe=groupSelected
        }
        do{
            try context.save()
            messages.append(message)
            messageField.text=""
            self.tableMessage.reloadData()
            if (self.tableMessage.contentSize.height > self.tableMessage.frame.size.height){
                let offset = CGPoint(x:0,y:self.tableMessage.contentSize.height-self.tableMessage.frame.size.height)
                self.tableMessage.setContentOffset(offset, animated: false)
            }
        }
        catch let error as NSError{
            print(error);
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tableGroupes){
            return self.groupes.count
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == tableGroupes){
            return 1
        }else{
            return self.messages.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tableGroupes){
            
                groupSelected=self.groupes[indexPath.row]
                loadMessage()
        }
        
    }
    func loadMessage(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Message> = Message.fetchRequest();
        let predicate = NSPredicate(format: "dep == %@ AND groupe == %@",(user?.appartient)!,groupSelected!);
        request.predicate=predicate;
        do{
            messages = try context.fetch(request)
        }
        catch let error as NSError{
            print(error);
        }

        self.tableMessage.reloadData()
        if (self.tableMessage.contentSize.height > self.tableMessage.frame.size.height){
            let offset = CGPoint(x:0,y:self.tableMessage.contentSize.height-self.tableMessage.frame.size.height)
            self.tableMessage.setContentOffset(offset, animated: false)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableGroupes){
            let cell = self.tableGroupes.dequeueReusableCell(withIdentifier: "groupeCell", for: indexPath) as! GroupeTableViewCell
            cell.buttonGroupe.setTitle(self.groupes[indexPath.row].name, for: .normal)
            cell.accessoryType = .none
            if(self.groupes[indexPath.row].name == "Général"){
                tableGroupes.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }
            return cell
        }
       else{
            let cell = self.tableMessage.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
            cell.message.text=self.messages[indexPath.section].contenu
            cell.userName.text=self.messages[indexPath.section].sendBy?.fname
            if let image=self.messages[indexPath.section].sendBy?.img{
                cell.profil.image=UIImage(data: image as Data)!
                cell.profil.layer.cornerRadius = cell.profil.layer.frame.size.width / 2;
                cell.profil.clipsToBounds = true;
                cell.profil.contentMode = .scaleAspectFill

            }
            if let date=self.messages[indexPath.section].date{
                cell.setTimeStamp(time: date)
            }
            cell.layer.cornerRadius=10
            return cell
        }

    }
    
    //Permet de changer (mettre a jour le changement d'image de profil
    @IBAction func unwindToThisView(segue: UIStoryboardSegue) {
        let newController = segue.source as! ProfileViewController
        photo.image = newController.photo.image
        photo.contentMode = .scaleAspectFill
        tableMessage.reloadData()
    }

    
    
    // MARK: - Table View delegate methods
    

    @IBAction func disconnect(_ sender: Any) {
        SingleUser.destroy();
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



