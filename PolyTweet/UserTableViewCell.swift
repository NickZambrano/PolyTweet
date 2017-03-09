//
//  MessageTableViewCell.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import SwipeCellKit

class UserTableViewCell : SwipeTableViewCell{
    

    var user : User? = nil;

    @IBOutlet weak var setResponsable: UIButton!
    @IBOutlet weak var lname: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var fname: UILabel!
    @IBOutlet weak var photo: UIImageView!


    override func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
