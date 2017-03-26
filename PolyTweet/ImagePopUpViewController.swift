//
//  ImagePopUpViewController.swift
//  PolyTweet
//
//  Ce controller permet d'afficher en grand l'image d'une piece jointe ou d'une information
//
//  Created by QC on 15/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit

class ImagePopUpViewController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var legende: UILabel!
    var image: UIImage? = nil;
    var desc: String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = image
        photo.contentMode = .scaleAspectFill
        if desc == ""{
            self.legende.isHidden = true
        }
        else {
            legende.text = desc
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

