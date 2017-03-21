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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }


    
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
            let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [date, dateTo])
            request.predicate = datePredicate;

            do{
                events = try context.fetch(request)
                print(events[0].detail!)
            }
            catch let error as NSError{
                print(error);
            }
            eventTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.eventTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
            cell.titreLabel.text = self.events[indexPath.section].titre!
            cell.descriptionLabel.text = self.events[indexPath.section].detail!
        
            return cell
        }
    
    /*// Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
