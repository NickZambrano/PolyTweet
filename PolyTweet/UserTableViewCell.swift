//
//  MessageTableViewCell.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class UserTableViewCell : UITableViewCell{
    

    var user : User? = nil;

    @IBOutlet weak var unsetResponsable: UIButton!
    
    @IBOutlet weak var setResponsable: UIButton!
    @IBOutlet weak var lname: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var fname: UILabel!
    
    @IBAction func unsetResponsable(_ sender: Any) {
        if let enseignant = self.user as? Enseignant{
            enseignant.respoDepartement=false;
            CoreDataManager.save();
        }
    }
    @IBAction func setResponsable(_ sender: Any) {
        if let enseignant = self.user as? Enseignant{
            enseignant.respoDepartement=true;
            CoreDataManager.save();
        }
    }

    override func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
