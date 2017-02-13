//
//  InscriptionViewController.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class InscriptionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return departement.count;
    }

    var nom : String = "";
    var departement : [Departement] = [];
    
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context=appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Departement> = Departement.fetchRequest();
        do{
           try departement = context.fetch(request)
        }
        catch let error as NSError{
            print(error);
        }
            let pickerView = UIPickerView()
            
            pickerView.delegate = self
            
        
            // Do any additional setup after loading the view, typically from a nib.

        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departement.count;
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departement[row].name;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
