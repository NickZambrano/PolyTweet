//
//  ViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
//Page principale de l'application permettant la gestion des messages des groupes et permet d'acceder aux autres fonctionnalité
class HomeViewController: CommonViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    
    var user:User?=nil;
    
    
    var messages : [Message] = []
    var filtredMessages: [Message] = []
    var groupSelected : Group?=nil

    var groupes : [Group]=[]
    
    var pieceImage:PieceJointeImage? = nil;
    var pieceLien:PieceJointeLien? = nil;
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    
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
        searchBar.delegate=self;
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
        pieceImage = nil
        pieceLien = nil
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

    //Charge le nombre de row par table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tableGroupes){
            return self.groupes.count
        }else{
            return 1
        }
    }
    //Charge le nombre de section par table
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == tableGroupes){
            return 1
        }else{
            //si la recherche est active on affiche le nombre de section égal au nombre message filtrée sinon on le nombre de section est égal au nombre de message total
            if searchActive {
                return self.filtredMessages.count
            }else{
                return self.messages.count
            }
            
        }
    }
    //Permet la selection d'un groupe
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tableGroupes){
            
                groupSelected=self.groupes[indexPath.row]
                loadMessage()
        }
        
    }
    //Charge les messages du coredata en fonction du groupe selectionné
    func loadMessage(){

        let request : NSFetchRequest<Message> = Message.fetchRequest();
        //Si le groupe selectionné est un groupe interDepartement on ne limite pas les message seulement au departement
        if(groupSelected?.interDepartement)!{
            request.predicate = NSPredicate(format: "groupe == %@",groupSelected!);
        }else{
            request.predicate = NSPredicate(format: "dep == %@ AND groupe == %@",(user?.appartient)!,groupSelected!);
        }
        do{
            messages = try CoreDataManager.context.fetch(request)
        }
        catch let error as NSError{
            print(error);
        }

        self.tableMessage.reloadData()
        //Partie de code permettant de d'afficher toujours les derniers messages en bas de la page.
        if (self.tableMessage.contentSize.height > self.tableMessage.frame.size.height){
            let offset = CGPoint(x:0,y:self.tableMessage.contentSize.height-self.tableMessage.frame.size.height)
            self.tableMessage.setContentOffset(offset, animated: false)
        }
    }
    //Charge les groupes de l'utilisateur
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
    //initialisation de la tableview en fonction de si c'est la table groupe ou la table message
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
            //si la recherche est active alors on met les messages filtrés sinon les messages classique

            var mess:[Message]=[];
            if searchActive {
                mess = filtredMessages
            }else{
                mess = messages
            }
            
            let cell = self.tableMessage.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
            cell.message.text=mess[indexPath.section].contenu
            cell.userName.text=(mess[indexPath.section].sendBy?.fname)!+(mess[indexPath.section].sendBy?.lname)!
            if let image=mess[indexPath.section].sendBy?.img{
                cell.profil.image=UIImage(data: image as Data)!
                cell.profil.layer.cornerRadius = cell.profil.layer.frame.size.width / 2;
                cell.profil.clipsToBounds = true;
                cell.profil.contentMode = .scaleAspectFill

            }
            if let date=mess[indexPath.section].date{
                cell.setTimeStamp(time: date)
            }
            
            let pieceImage = mess[indexPath.section].image
            if pieceImage == nil {
                cell.imagelien.isHidden = true
                
            }else { //S'il y a une image, l'afficher
                cell.imageMessage.image = UIImage(data: pieceImage?.file as! Data)!
                cell.imageMessage.contentMode = .scaleAspectFill
                cell.imageMessage.clipsToBounds = true
                cell.imagelien.tag = indexPath.section
                cell.imagelien.addTarget(self, action: #selector(showImage(sender:)), for: .touchUpInside)
                cell.imagelien.isHidden = false
            }
            //S'il y a un lien, l'afficher
            if let pieceLien = mess[indexPath.section].lien {
                cell.lien.setTitle(pieceLien.name,for: .normal)
                cell.lien.tag = indexPath.section
                cell.lien.addTarget(self, action: #selector(openLien(sender:)), for: .touchUpInside)
                cell.lien.isHidden = false
            }else{
                cell.lien.isHidden = true
            }
            if(mess[indexPath.section].lien == nil && mess[indexPath.section].image == nil){
                cell.pieceJointeLabel.isHidden=true
            }
            cell.layer.cornerRadius=10
            return cell
        }

    }

    //Fais en sorte que le row peut être supprimable seulement si le message appartient à l'utilisateur et si l'on modifie la tableview tableMessage
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(tableView == tableMessage){
            var mess:[Message]=[];
            if searchActive {
                mess = filtredMessages
            }else{
                mess = messages
            }
            if(mess[indexPath.section].sendBy==user){
                return true
            }else{
                return false
            }
        }else{
            return false;
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }
    //Fonction permettant la suppression du message
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]? {

        let delete = UITableViewRowAction(style: .normal, title: "Supprimer") { action, index in
            var mess:[Message]=[];
            if self.searchActive {
                mess = self.filtredMessages
            }else{
                mess = self.messages
            }
                CoreDataManager.context.delete(mess[indexPath.section])
                CoreDataManager.save()
            if(self.searchActive){
                self.filtredMessages.remove(at: indexPath.section)

            }else{
                self.messages.remove(at: indexPath.section)
            }
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section)
            self.tableMessage.deleteSections(indexSet as IndexSet, with : .fade)
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        notUpKeyboard=true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        notUpKeyboard=false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        notUpKeyboard=false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
        // searchBar() permet de rechercher en fonction des titres les messages dans le coredata en fonction de ce que l'utilisateur tape dans la barre de recherche
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Supprimer tous les éléments du filtredMessages
        self.filtredMessages.removeAll(keepingCapacity: false)
        if (searchText==""){
            self.filtredMessages=messages;
        }else{
            // Créer le Predicate et effectue la requete
            let request : NSFetchRequest<Message> = Message.fetchRequest();
            if(groupSelected?.interDepartement)!{
                request.predicate = NSPredicate(format: "contenu CONTAINS[c] %@ AND groupe == %@",searchText,groupSelected!);
            }else{
                request.predicate = NSPredicate(format: "contenu CONTAINS[c] %@ AND dep == %@ AND groupe == %@",searchText,(user?.appartient)!,groupSelected!);
            }
            do{
                self.filtredMessages = try CoreDataManager.context.fetch(request)
                
            }
            catch let error as NSError{
                print(error);
            }
        }
        
        // Actualisation du tableView
        self.tableMessage.reloadData()
    }
    //Fonction permettant d'ouvrir un lien si le lien est valide
    @IBAction func openLien(sender: UIButton){
        var mess:[Message]=[];
        if searchActive {
            mess = filtredMessages
        }else{
            mess = messages
        }
        let link = mess[sender.tag].lien
    
        let url = NSURL(string: String(data: link?.file as! Data, encoding: .utf8)!)!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
    }
    //Permet d'afficher l'image en grand
    @IBAction func showImage(sender: UIButton){
        indexImage = sender.tag
        performSegue(withIdentifier: "showImage", sender: sender)
    }
    
    //Actualise l'image apres un changement d'image
    @IBAction func unwindtoHome(segue: UIStoryboardSegue) {
        let newController = segue.source as! PopUpViewController
        photo.image = newController.photo.image
        photo.contentMode = .scaleAspectFill
        tableMessage.reloadData()
    }
    //Fonction permettant d'attacher les piece jointes et des les enregistrer
    @IBAction func unwindAttachedFiletoHome(segue: UIStoryboardSegue) {

        let newController = segue.source as! AttachedFilePopUpController
        
        
        if newController.photo.image != nil {     //On regarde s'il y a une piece jointe image
            let pieceimage = PieceJointeImage(context:CoreDataManager.context);

            if newController.photo.image != nil {
                pieceimage.file = UIImageJPEGRepresentation(newController.photo.image!,1) as NSData?
                pieceimage.name = newController.photoTextField.text
            }
            CoreDataManager.save();
                self.pieceImage = pieceimage
        }
        
        if newController.lienTextField.text != ""{ //On regarde s'il y a un lien
            let piecelien = PieceJointeLien(context:CoreDataManager.context);
            piecelien.file = newController.lienTextField.text?.data(using: .utf8)! as NSData?
            piecelien.name = newController.nomLien.text
            
            CoreDataManager.save();
                self.pieceLien = piecelien
        }
        
    }
    
//Permet d'enregistrer le groupe créé
    @IBAction func unwindtoHomeFomGroupView(segue: UIStoryboardSegue) {
        let oldController = segue.source as! GroupPopUpViewController
        let group = Group(context:CoreDataManager.context)
        group.name=oldController.nameGroup.text
        group.interDepartement=true
        for userToAdd in oldController.usersSelected {
            userToAdd.addToContribue(group)
            group.addToContient(userToAdd)
        }
        CoreDataManager.save();
        
        loadGroupes();
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue permettant d'afficher l'image en grand
        if (segue.identifier == "showImage"){
            var mess:[Message]=[];
            if searchActive {
                mess = filtredMessages
            }else{
                mess = messages
            }
            let upcomming: ImagePopUpViewController = segue.destination as! ImagePopUpViewController
            if let button:UIButton = sender as! UIButton? {
                indexImage = button.tag
            }
            let pieceimage = mess[indexImage!].image

            upcomming.image = UIImage(data: pieceimage!.file as! Data)
            upcomming.desc = pieceimage!.name
            
        }
    }
    //permet la deconnection de l'utilisateur
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
