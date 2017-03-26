//
//  CommonViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

//Gère la création de nouveaux groupes de conversations
class GroupPopUpViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var nameGroup: UITextField!
    @IBOutlet weak var addPersonToGroup: UIButton!
    
    @IBOutlet weak var UserGroupTableView: UITableView!
    @IBOutlet weak var autocompleteTableView: UITableView!
    
    var users : [User]=[]
    var autocompleteUrls = [User]()
    var userTemp: User?=nil;
    var usersSelected : [User]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        textField.delegate=self
        autocompleteTableView.isScrollEnabled = true
        autocompleteTableView.isHidden = true
        addPersonToGroup.isHidden=true
        loadUsers()
        usersSelected.append(SingleUser.getUser()!)
    }
    //fonction d'autocompletion sur le textfield qui affiche la table view
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        addPersonToGroup.isHidden=true
        autocompleteTableView.isHidden = false
        let substring = (self.textField.text! as NSString).replacingCharacters(in: range, with: string)
        searchAutocompleteEntriesWithSubstring(substring: substring)
        return true
    }
    func loadUsers(){

        let request : NSFetchRequest<User> = User.fetchRequest();
        do{
            users = try CoreDataManager.context.fetch(request)
            
        }
        catch let error as NSError{
            print(error);
        }
        
    }
    //En fonction de ce que le textfield à récuperer nous affichons les personnes qui on le prénom commençant par ça ou le nom commençant par ça
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepingCapacity: false)
        //Permettant de chercher d'abord sur le prénom
        for curString in users
        {
            let myString:NSString! = curString.fname!+" "+curString.lname! as NSString
            
            let substringRange :NSRange! = myString.range(of: substring)
            
            if (substringRange.location  == 0)
            {
                autocompleteUrls.append(curString)
            }
        }
        //Permet de chercher sur le nom
        for curString in users
        {
            let myString:NSString! = curString.lname!+" "+curString.fname! as NSString
            
            let substringRange :NSRange! = myString.range(of: substring)
            
            if (substringRange.location  == 0)
            {
                autocompleteUrls.append(curString)
            }
        }
        
        autocompleteTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //le if permet de différencier les deux tables view de la vue
        if(tableView == autocompleteTableView){
            return autocompleteUrls.count
        }else{
            return usersSelected.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //le if permet de différencier les deux tables view de la vue
        if(tableView == autocompleteTableView){ //instanciation de la table view AutoComplete
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier:  autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
            let index = indexPath.row as Int
            cell.textLabel?.text = autocompleteUrls[index].fname!+" "+autocompleteUrls[index].lname!
            cell.accessoryType = .none
            return cell
        }else{//Instanciation de la table view User Group
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserGroupRowIdentifier", for: indexPath) as UITableViewCell
            let index = indexPath.row as Int
            cell.textLabel?.text = usersSelected[index].fname!+" "+usersSelected[index].lname!
            cell.accessoryType = .none
            return cell
        }
    }
    //Permet d'afficher le bouton ajouter une personne une fois qu'on a selectionner une personne de l'autocompletion
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == autocompleteTableView){
            let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            textField.text = selectedCell.textLabel!.text
            autocompleteTableView.isHidden = true
            addPersonToGroup.isHidden=false
            userTemp=autocompleteUrls[indexPath.row];
        }
    }
    //Ajoutes la personnes a la liste des personnes du groupes
    @IBAction func addToGroup(_ sender: Any) {
        usersSelected.append(userTemp!);
        textField.text=nil;
        UserGroupTableView.reloadData()
    }
    

    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
}

