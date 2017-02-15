//
//  MessageTableViewCell.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class MessageTableViewCell : UITableViewCell{
    
    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
