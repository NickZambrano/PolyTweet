//
//  EventTableViewCell.swift
//  PolyTweet
//
//  Created by QC on 21/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class EventTableViewCell : UITableViewCell{
    
    @IBOutlet weak var titreLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
