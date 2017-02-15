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
    
    @IBOutlet weak var dateHeure: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profil: UIImageView!
    override func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setTimeStamp(time: NSDate?) {
        
        if let time = time {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: time as Date)
            let minutes = calendar.component(.minute, from: time as Date)
            
            // Converts 1 digit minute to 2 digits (e.g: 9:9 -> 9:09)
            var minuteString = String(minutes)
            if String(minuteString).characters.count < 2 {
                minuteString = "0"+minuteString
            }
            self.dateHeure.text = "\(hour):\(minuteString)"
        }
        
    }
}
