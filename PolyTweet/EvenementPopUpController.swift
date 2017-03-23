//
//  EvenementPopUpController.swift
//  PolyTweet
//
//  Created by QC on 21/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar
import CoreData

class EvenementPopUpController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
   
    
    @IBOutlet weak var dateLabel: UILabel!
    var date: Date? = nil
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var eventTable: UITableView!
    
    var events : [Evenement]=[]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        dateLabel.text = dateFormatter.string(from: date!)
        
        loadEvents()
        eventTable.dataSource = self
        eventTable.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.events.count
    }



    /**
     Fonction qui permet de charger tous les éléments présents dans les CoreData qui correspondent à la date 
     */
    func loadEvents(){
            
            let context=CoreDataManager.context
            let request : NSFetchRequest<Evenement> = Evenement.fetchRequest();
        
            // Get the current calendar with local time zone
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local

            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: date!)
            components.day! += 1
            let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
        
            // Set predicate as date being today's date
            let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [date!, dateTo])
            request.predicate = datePredicate;

            do{
                events = try context.fetch(request)
            }
            catch let error as NSError{
                print(error);
            }
            eventTable.reloadData()
    }
    
    /**
     Remplissage du tableau avec les évènements chargés
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.eventTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
            cell.titreLabel.text = self.events[indexPath.section].titre!
            cell.descriptionLabel.text = self.events[indexPath.section].detail!
        
            return cell
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
