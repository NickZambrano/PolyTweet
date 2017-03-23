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
    
    var pieceImage:PieceJointeImage? = nil;
    var pieceLien:PieceJointeLien? = nil;
    
    
    var indexImage: Int? = nil;
    
    
    @IBOutlet weak var tableMessage: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var attachedfile: UIButton!
    @IBOutlet weak var tableGroupes: UITableView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet var userStatus: UILabel!
    
    @IBOutlet weak var adminButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user=SingleUser.getUser();
        loadGroupes()
        loadMessage()

        //
        self.username.text="@"+(user?.fname)!+(user?.lname)!;
        self.username.textAlignment = .center
        
        if (user as? Etudiant) != nil {
            adminButton.isHidden=true;
            userStatus.text="Etudiant "+(user?.appartient?.name)!;
        }
        if (user as? Administration) != nil {
            adminButton.isHidden=false;

            userStatus.text="Administration "+(user?.appartient?.name)!;
        }
        if let enseignant=user as? Enseignant {
            adminButton.isHidden = !(enseignant.respoDepartement);
            userStatus.text="Enseignant "+(user?.appartient?.name)!;
        }
        
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2;
        self.photo.clipsToBounds = true;
        
        if let image=user?.img {
            photo.image=UIImage(data: image as Data)!
        }
        self.tableGroupes.allowsSelection = true
        
        attachedfile.layer.cornerRadius = 5
        
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {

        let message = Message(context: CoreDataManager.context);
        if let contenu=messageField.text{
            message.contenu=contenu
            message.sendBy=user
            message.date=NSDate()
            message.dep=user?.appartient
            message.groupe=groupSelected
            message.image = pieceImage
            message.lien = pieceLien
        }
        CoreDataManager.save()
        messages.append(message)
        messageField.text=""
        self.tableMessage.reloadData()
        if (self.tableMessage.contentSize.height > self.tableMessage.frame.size.height){
            let offset = CGPoint(x:0,y:self.tableMessage.contentSize.height-self.tableMessage.frame.size.height)
            self.tableMessage.setContentOffset(offset, animated: false)
        }

        
    }
    // Do any additional setup after loading the view, typically from a nib.
    //Calls this function when the tap is recognized.


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


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

        let request : NSFetchRequest<Message> = Message.fetchRequest();
        let predicate = NSPredicate(format: "dep == %@ AND groupe == %@",(user?.appartient)!,groupSelected!);
        request.predicate=predicate;
        do{
            messages = try CoreDataManager.context.fetch(request)
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
    func loadGroupes(){
        
        let requestGroupeGeneral : NSFetchRequest<Group> = Group.fetchRequest();
        let nameGroupe : String = "Général"
        let predicateGroupeGeneral = NSPredicate(format: "name == %@",nameGroupe);
        requestGroupeGeneral.predicate=predicateGroupeGeneral;
        do{
            let groupeSel = try CoreDataManager.context.fetch(requestGroupeGeneral)
            groupSelected=groupeSel[0]
        }
        catch let error as NSError{
            print(error);
        }
        groupes=(user?.contribue)!.allObjects as! [Group];
        tableGroupes.reloadData()
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
            
            if let pieceImage = self.messages[indexPath.section].image {
                cell.imageMessage.image = UIImage(data: pieceImage.file as! Data)!
                cell.imageMessage.contentMode = .scaleAspectFill
                cell.imageMessage.clipsToBounds = true
                cell.imagelien.tag = indexPath.section
                cell.imagelien.addTarget(self, action: #selector(showImage(sender:)), for: .touchUpInside)
                
            }
            if let pieceLien = self.messages[indexPath.section].lien {
                cell.lien.setTitle(pieceLien.name,for: .normal)
                cell.lien.tag = indexPath.section
                cell.lien.addTarget(self, action: #selector(openLien(sender:)), for: .touchUpInside)
            }else {
                cell.lien.isHidden = true
            }
            cell.layer.cornerRadius=10
            return cell
        }

    }
    
    @IBAction func openLien(sender: UIButton){
        let link = self.messages[sender.tag].lien
    
        let url = NSURL(string: String(data: link?.file as! Data, encoding: .utf8)!)!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func showImage(sender: UIButton){
        indexImage = sender.tag
        performSegue(withIdentifier: "showImage", sender: sender)
    }
    

    @IBAction func unwindtoHome(segue: UIStoryboardSegue) {
        let newController = segue.source as! PopUpViewController
        photo.image = newController.photo.image
        photo.contentMode = .scaleAspectFill
        tableMessage.reloadData()
    }
    
    @IBAction func unwindAttachedFiletoHome(segue: UIStoryboardSegue) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let newController = segue.source as! AttachedFilePopUpController
        
        
        if newController.photo.image != nil {     //On regarde s'il y a une piece jointe image
            let pieceimage = PieceJointeImage(context:CoreDataManager.context);

        
        
            if newController.photo.image != nil {
                pieceimage.file = UIImageJPEGRepresentation(newController.photo.image!,1) as NSData?
                pieceimage.name = newController.photoTextField.text
            }
            
            do{
                try CoreDataManager.context.save();
                self.pieceImage = pieceimage

        
            }catch let error as NSError{
                print(error);
            }
        }
        
        if newController.lienTextField != nil{ //On regarde s'il y a un lien
            let piecelien = PieceJointeLien(context:CoreDataManager.context);
            piecelien.file = newController.lienTextField.text?.data(using: .utf8)! as NSData?
            piecelien.name = newController.nomLien.text
            
            do{
                try CoreDataManager.context.save();
                self.pieceLien = piecelien
                
            }catch let error as NSError{
                print(error);
            }
        }
        
    }
    
    // MARK: - Table View delegate methods
    
    @IBAction func unwindtoHomeFomGroupView(segue: UIStoryboardSegue) {
        let oldController = segue.source as! GroupPopUpViewController
        let group = Group(context:CoreDataManager.context);
        group.name=oldController.nameGroup.text;
        for userToAdd in oldController.usersSelected {
            userToAdd.addToContribue(group);
            group.addToContient(userToAdd);
        }
        CoreDataManager.save();
        
        loadGroupes();
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImage"){
            let upcomming: ImagePopUpViewController = segue.destination as! ImagePopUpViewController
            if let button:UIButton = sender as! UIButton? {
                indexImage = button.tag
            }
            let pieceimage = self.messages[indexImage!].image

            upcomming.image = UIImage(data: pieceimage!.file as! Data)
            upcomming.desc = pieceimage!.name
            
        }
    }
    
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
