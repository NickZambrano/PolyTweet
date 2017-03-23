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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        addPersonToGroup.isHidden=true
        autocompleteTableView.isHidden = false
        let substring = (self.textField.text! as NSString).replacingCharacters(in: range, with: string)
        searchAutocompleteEntriesWithSubstring(substring: substring)
        return true     // not sure about this - could be false
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
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepingCapacity: false)
        
        for curString in users
        {
            let myString:NSString! = curString.fname!+" "+curString.lname! as NSString
            
            let substringRange :NSRange! = myString.range(of: substring)
            
            if (substringRange.location  == 0)
            {
                autocompleteUrls.append(curString)
            }
        }
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
        if(tableView == autocompleteTableView){
            return autocompleteUrls.count
        }else{
            return usersSelected.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == autocompleteTableView){
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier:  autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
            let index = indexPath.row as Int
            cell.textLabel?.text = autocompleteUrls[index].fname!+" "+autocompleteUrls[index].lname!
            cell.accessoryType = .none
            return cell
        }else{
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserGroupRowIdentifier", for: indexPath) as UITableViewCell
            let index = indexPath.row as Int
            cell.textLabel?.text = usersSelected[index].fname!+" "+usersSelected[index].lname!
            cell.accessoryType = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == autocompleteTableView){
        let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
        textField.text = selectedCell.textLabel!.text
        autocompleteTableView.isHidden = true
        addPersonToGroup.isHidden=false
        userTemp=autocompleteUrls[indexPath.row];
        }
    }

    @IBAction func addToGroup(_ sender: Any) {
        usersSelected.append(userTemp!);
        textField.text=nil;
        UserGroupTableView.reloadData()
    }
    

    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
}

