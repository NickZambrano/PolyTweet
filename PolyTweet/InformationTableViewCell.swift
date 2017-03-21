//
//  InformationTableViewCell.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 20/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//


import UIKit

class InformationTableViewCell : UITableViewCell{
    
    @IBOutlet weak var titreLabel: UILabel!
    
    @IBOutlet weak var imageInformation: UIImageView!
    
    @IBOutlet weak var contenu: UITextView!
    @IBOutlet weak var lien: UIButton!
    
    override func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
