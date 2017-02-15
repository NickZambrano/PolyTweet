//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
class HomeViewController: CommonViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    var user:User?=nil;
    
    
    var messages : [Message] = []

    @IBOutlet weak var tableMessage: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var photo: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<Message> = Message.fetchRequest();
        let predicate = NSPredicate(format: "dep == %@",(user?.appartient)!);
        request.predicate=predicate;
        do{
            messages = try context.fetch(request)
            print(messages.count)
        }
        catch let error as NSError{
            print(error);
        }
        
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
            message.date=NSDate()
            message.dep=user?.appartient
        }
        do{
            try context.save()
            messages.append(message)
            messageField.text=""
            self.tableMessage.reloadData()
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
        return self.messages.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableMessage.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.message.text=self.messages[indexPath.row].contenu
        cell.userName.text=self.messages[indexPath.row].sendBy?.fname
        if let image=self.messages[indexPath.row].sendBy?.img{
            cell.profil.image=UIImage(data: image as Data)!
        }
        if let date=self.messages[indexPath.row].date{
            cell.setTimeStamp(time: date)
        }
        cell.layer.cornerRadius=10
        return cell
    }
    

    
}

