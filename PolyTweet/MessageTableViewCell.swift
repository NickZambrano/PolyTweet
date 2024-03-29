//
//  MessageTableViewCell.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 15/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit

class MessageTableViewCell : UITableViewCell{
    
    @IBOutlet weak var pieceJointeLabel: UILabel!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var dateHeure: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profil: UIImageView!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var lien: UIButton!
    @IBOutlet weak var imagelien: UIButton!
    
    override func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setTimeStamp(time: NSDate?) {
        
        if let time = time {
            let calendar = Calendar.current
            let day = String(calendar.component(.day, from: time as Date))
            //let month = calendar.component(.month, from: time as Date)
            let hour = calendar.component(.hour, from: time as Date)
            let minutes = calendar.component(.minute, from: time as Date)
            
            // Converts 1 digit minute to 2 digits (e.g: 9:9 -> 9:09)
            var minuteString = String(minutes)
            if String(minuteString).characters.count < 2 {
                minuteString = "0"+minuteString
            }
            // Permet d'obtenir le mois en lettres
            var month: String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM"
                return dateFormatter.string(from: time as Date)
            }
            
            self.dateHeure.text = day+" "+month+" \(hour):\(minuteString)"
        }
        
    }
}
