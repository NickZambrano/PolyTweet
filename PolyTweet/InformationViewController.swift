//
//  InformationViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 20/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class InformationViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating{

    var user:User?=nil;

    @IBOutlet weak var addInfoButton: UIButton!
    @IBOutlet weak var tableInformations: UITableView!
    var filtredInfo: [Information] = [];
    var resultSeachController = UISearchController()
    var informations:[Information] = [];
    var infoSelected:Information?=nil;
    override func viewDidLoad() {
            super.viewDidLoad()
            
            user=SingleUser.getUser();
        if (user as? Etudiant) != nil {
            addInfoButton.isHidden=true;
        }
        if let enseignant=user as? Enseignant {
            if(!enseignant.respoDepartement){
               addInfoButton.isHidden=true;
            }
        }
        
        // l'initialisation de SeachController avec un UISearchController vide
        self.resultSeachController = UISearchController(searchResultsController: nil)
        
        // Paramétrer le SeachController
        self.resultSeachController.searchResultsUpdater = self
        self.resultSeachController.dimsBackgroundDuringPresentation = false
        self.resultSeachController.searchBar.sizeToFit()
        
        // Ajout de SeachController au Header du tableView
        self.tableInformations.tableHeaderView = self.resultSeachController.searchBar
        
            loadInformation()
    }
func loadInformation(){
    let context=CoreDataManager.context
    let request : NSFetchRequest<Information> = Information.fetchRequest();
    let predicate = NSPredicate(format: "departement == %@",(user?.appartient)!);
    request.predicate=predicate;
    do{
        informations = try context.fetch(request)
        
    }
    catch let error as NSError{
        print(error);
    }
    
    self.tableInformations.reloadData()
}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.resultSeachController.isActive {
            return self.filtredInfo.count
        } else {
            return self.informations.count
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var info:[Information]=[];
            if self.resultSeachController.isActive {
                info = filtredInfo
            }else{
                info = informations
            }
            let cell = self.tableInformations.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InformationTableViewCell
            cell.titreLabel.text=info[info.count-1-indexPath.section].titre

            cell.layer.cornerRadius=10
        
            cell.contenu.text=info[info.count-1-indexPath.section].contenu
            if let pieceImage = info[info.count-1-indexPath.section].image {
                cell.imageInformation.image = UIImage(data: pieceImage.file as! Data)!
                cell.imageInformation.contentMode = .scaleAspectFill
                cell.imageInformation.clipsToBounds = true
                
            }
        cell.imageInformation.layer.cornerRadius=5
            if let pieceLien = info[info.count-1-indexPath.section].lien {
                cell.lien.setTitle(pieceLien.name,for: .normal)
                cell.lien.tag = indexPath.section
            }else {
                cell.lien.isHidden = true
            }
            cell.accessoryType = .none
            return cell
    
        
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var info:[Information]=[];
        if self.resultSeachController.isActive {
            info = filtredInfo
        }else{
            info = informations
        }
            infoSelected=info[info.count-1-indexPath.section]
            performSegue(withIdentifier: "showInfo", sender : self)
        
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Supprimer tous les éléments du filtredTeams
        self.filtredInfo.removeAll(keepingCapacity: false)
        if (searchController.searchBar.text==""){
            self.filtredInfo=informations;
        }else{
        // Créer le Predicate
        let searchPredicate = NSPredicate(format: "titre CONTAINS[c] %@ AND departement == %@",searchController.searchBar.text!,(user?.appartient)!)
        let request : NSFetchRequest<Information> = Information.fetchRequest();
        request.predicate=searchPredicate;
        // Créer un NSArray (ce array représente SELF dans le Predicate créé)
        do{
            self.filtredInfo = try CoreDataManager.context.fetch(request)
            
        }
        catch let error as NSError{
            print(error);
        }
        }
        // Nouveau filtredTeams de la requête du Predicate
        //self.filtredInfo = array as! [Information]
        
        // Actualisation du tableView
        self.tableInformations.reloadData()
        
    }

    @IBAction func unwindtoHomeFomAddInfoView(segue: UIStoryboardSegue) {
        let oldController = segue.source as! AddInfoViewController
        if oldController.lienTextField.text != nil && oldController.lienTextField.text != "" {
            if !oldController.canOpenURL(string: oldController.lienTextField.text){
                /*let alert : UIAlertView = UIAlertView(title: "Erreur", message: "Mauvaise URL",       delegate: nil, cancelButtonTitle: "Retour")
                 
                 alert.show()*/
                let alert = UIAlertController(title: "Erreur", message: "Mauvaise URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                
                
                let info=Information(context: CoreDataManager.context);
                info.titre=oldController.titreField.text;
                info.contenu=oldController.contenuField.text;
                info.departement=user?.appartient;
                
                if oldController.photo.image != nil {     //On regarde s'il y a une piece jointe image
                    let pieceimage = PieceJointeImage(context: CoreDataManager.context);
                    
                    
                    
                    if oldController.photo.image != nil {
                        pieceimage.file = UIImageJPEGRepresentation(oldController.photo.image!,1) as NSData?
                        pieceimage.name = oldController.photoTextField.text
                    }
                    info.image=pieceimage
                    
                }
                
                if oldController.lienTextField != nil{ //On regarde s'il y a un lien
                    let piecelien = PieceJointeLien(context:CoreDataManager.context);
                    piecelien.file = oldController.lienTextField.text?.data(using: .utf8)! as NSData?
                    piecelien.name = oldController.nomLien.text
                    info.lien=piecelien
                }
                CoreDataManager.save();
            }
        }
        else{
            
            let info=Information(context: CoreDataManager.context);
            info.titre=oldController.titreField.text;
            info.contenu=oldController.contenuField.text;
            info.departement=user?.appartient;
            
            if oldController.photo.image != nil {     //On regarde s'il y a une piece jointe image
                let pieceimage = PieceJointeImage(context: CoreDataManager.context);
                
                
                
                if oldController.photo.image != nil {
                    pieceimage.file = UIImageJPEGRepresentation(oldController.photo.image!,1) as NSData?
                    pieceimage.name = oldController.photoTextField.text
                }
                info.image=pieceimage
                
            }
            
            
            CoreDataManager.save()
        }
        loadInformation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showInfo"){
            let upcomming: InformationPopupViewController = segue.destination as! InformationPopupViewController
            upcomming.information=infoSelected;
            
        }
    }
    

}
