//
//  CalendarViewController.swift
//  PolyTweet
//
//  Created by QC on 09/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class CalendarViewController: CommonViewController {
    
    @IBOutlet weak var calendarView: CalendarView!

    
    let monthFormatter = DateFormatter()
    var testCalendar = Calendar.current
    let white = UIColor.white
    let darkPurple = UIColor.black
    let dimPurple = UIColor.brown
    var selectedDate:CellView? = nil
    var seldate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.layer.cornerRadius = 10
        calendarView.registerHeaderView(xibFileNames: ["SectionHeaderView"])
        
        monthFormatter.dateFormat = "MMMM yyyy"

        
        let date = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let myDate = formatter.date(from: String(year)+" "+String(month)+" "+String(day))!
        calendarView.scrollToDate(myDate)
        calendarView.selectDates([myDate])
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = darkPurple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = white
            } else {
                myCustomCell.dayLabel.textColor = dimPurple
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  25
            myCustomCell.selectedView.isHidden = false
            selectedDate = myCustomCell
        } else {
            myCustomCell.selectedView.isHidden = true
        }
        if haveEvents(cellState: cellState){
            myCustomCell.eventView.layer.cornerRadius =  8
            myCustomCell.eventView.isHidden=false
        }
        else{
            myCustomCell.eventView.isHidden=true
        }
    }

    
    //Fonction pour savoir si il y a un évènement sur la cellule
    func haveEvents(cellState: CellState)->BooleanLiteralType{
        var result = false
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let cellStateString = formatter.string(from: cellState.date)
        
        var events : [Evenement] = []
        
        let context = CoreDataManager.context
        let request : NSFetchRequest<Evenement> = Evenement.fetchRequest();
        do{
            events = try context.fetch(request)
        }
        catch let error as NSError{
            print(error);
        }
        
        for event in events {
            let delta = event.date?.timeIntervalSinceNow
            
            if let delta = delta {
                let date = Date(timeIntervalSinceNow: delta)
                let dateEventString = formatter.string(from: date)
                if cellState.dateBelongsTo == .thisMonth && dateEventString == cellStateString{
                    result = true
                }
            }
            
        }
        return result
    }
    
    
    @IBAction func showEvents(_ sender: Any) {
        performSegue(withIdentifier: "showeventspopup", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showeventspopup" {
            let upcomming: EvenementPopUpController = segue.destination as! EvenementPopUpController
            upcomming.date = seldate
            
        }
    }
    
    
    @IBAction override func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
    
    
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        let headerCell = (header as? SectionHeaderView)
        
        headerCell?.title.text = monthFormatter.string(from: range.start)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2017 01 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2100 02 01")!                                // You can also use dates created from this function
        let calendar = Calendar.current                     // Make sure you set this up to your time zone. We'll just use default here
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 5,
                                                 calendar: calendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .monday)
        return parameters
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text

        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        seldate = cellState.date
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    

}

