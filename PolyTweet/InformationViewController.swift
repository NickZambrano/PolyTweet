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
class InformationViewController: CommonViewController, UITableViewDataSource,UITableViewDelegate{

    var user:User?=nil;

    @IBOutlet weak var tableInformations: UITableView!
    var informations:[Information] = [];
        override func viewDidLoad() {
            super.viewDidLoad()
            
            user=SingleUser.getUser();
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
            return self.informations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = self.tableInformations.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InformationTableViewCell
            cell.titreLabel.text=self.informations[indexPath.section].titre

            cell.layer.cornerRadius=10
            
            if let pieceImage = self.informations[indexPath.section].image {
                cell.imageInformation.image = UIImage(data: pieceImage.file as! Data)!
                cell.imageInformation.contentMode = .scaleAspectFill
                cell.imageInformation.clipsToBounds = true
                cell.imageLien.tag = indexPath.section
                
            }
            if let pieceLien = self.informations[indexPath.section].lien {
                cell.lien.setTitle(pieceLien.name,for: .normal)
                cell.lien.tag = indexPath.section
            }else {
                cell.lien.isHidden = true
            }
            
            return cell
    
        
    }

}
