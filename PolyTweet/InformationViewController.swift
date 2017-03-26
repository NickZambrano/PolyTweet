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
//Gère l'affichage de la liste des informations
class InformationViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{

    var user:User?=nil;
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    @IBOutlet weak var addInfoButton: UIButton!
    @IBOutlet weak var tableInformations: UITableView!
    var filtredInfo: [Information] = [];
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
        searchBar.delegate=self;

        loadInformation()
    }
    
    // loadInformation() charge toutes les informations disponibles dans le coreData pour le département de l'utilisateur connecté.
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
        //si la recherche est active on affiche le nombre de section égal au nombre d'information filtrée sinon on le nombre de section est égal au nombre d'information
        if searchActive {
            return self.filtredInfo.count
        } else {
            return self.informations.count
        }

    }
    //construction de la table avec des InformationTableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var info:[Information]=[];
        //si la recherche est active alors on met les informations filtrées sinon les informations classique
        if searchActive {
            info = filtredInfo
        }else{
            info = informations
        }
        let cell = self.tableInformations.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InformationTableViewCell
        //Indice Info.count-1-indexPath.section afin de classer les informations à l'envers (de la plus recente à la plus ancienne)
        cell.titreLabel.text=info[info.count-1-indexPath.section].titre
        cell.layer.cornerRadius=10
    
        cell.contenu.text=info[info.count-1-indexPath.section].contenu
        //S'il y a une image, l'afficher
        if let pieceImage = info[info.count-1-indexPath.section].image {
            cell.imageInformation.image = UIImage(data: pieceImage.file as! Data)!
            cell.imageInformation.contentMode = .scaleAspectFill
            cell.imageInformation.clipsToBounds = true
            
        }
        cell.imageInformation.layer.cornerRadius=5
        //S'il y'a un lien l'afficher
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

    //Permet la selection d'un row et de selectionner la bonne information pour la mettre dans infoSelected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var info:[Information]=[];
        if searchActive{
            info = filtredInfo
        }else{
            info = informations
        }
            infoSelected=info[info.count-1-indexPath.section]
            performSegue(withIdentifier: "showInfo", sender : self)
        
        }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    // searchBar() permet de rechercher en fonction des titres les informations dans le coredata en fonction de ce que l'utilisateur tape dans la barre de recherche
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Supprimer tous les éléments du filtredInfo
        self.filtredInfo.removeAll(keepingCapacity: false)
        //Si chaine vide alors on prend toutes les informations
        if (searchText==""){
            self.filtredInfo=informations;
        }else{
        // Créer le Predicate et on effectue la requête
        let searchPredicate = NSPredicate(format: "titre CONTAINS[c] %@ AND departement == %@",searchText,(user?.appartient)!)
        let request : NSFetchRequest<Information> = Information.fetchRequest();
        request.predicate=searchPredicate;
        do{
            self.filtredInfo = try CoreDataManager.context.fetch(request)
            
        }
        catch let error as NSError{
            print(error);
        }
        }
        
        // Actualisation du tableView
        self.tableInformations.reloadData()
        
    }
    // unwind afin d'enregistrer la nouvelle information et de l'afficher
    @IBAction func unwindtoHomeFomAddInfoView(segue: UIStoryboardSegue) {
        let oldController = segue.source as! AddInfoViewController
        //controle s'il y a un lien
        if oldController.lienTextField.text != nil && oldController.lienTextField.text != "" {
            // Si lien invalide afficher erreur
            if !oldController.canOpenURL(string: oldController.lienTextField.text){

                let alert = UIAlertController(title: "Erreur", message: "Mauvaise URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                // lien valide création d'une info
                
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
            //création de l'information
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
        //recharge de la table
        loadInformation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue pour afficher l'information en détail
        if (segue.identifier == "showInfo"){
            let upcomming: InformationPopupViewController = segue.destination as! InformationPopupViewController
            upcomming.information=infoSelected;
            
        }
    }
    

}
