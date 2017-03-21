//
//  ImagePopUpViewController.swift
//  PolyTweet
//
//  Created by QC on 15/03/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import Foundation
import UIKit

class InformationPopupViewController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var information : Information?=nil;
    
    @IBOutlet weak var titre: UILabel!
    
    @IBOutlet weak var contenu: UITextView!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var legende: UILabel!
    
    @IBOutlet weak var pieceJointeLabel: UILabel!
    @IBOutlet weak var lien: UIButton!
    override func viewDidLoad() {
        self.titre.text=information?.titre
        self.contenu.text=information?.contenu
        if let photoInfo=information?.image {
            photo.image=UIImage(data: photoInfo.file as! Data)
            if  photoInfo.name != nil {
                legende.text=photoInfo.name;
            }else{
                legende.isHidden=true;
            }
        }else{
            photo.isHidden=true;
            legende.isHidden=true;
        }
        if let lienInfo=information?.lien{
            if(lienInfo.name != ""){
                lien.setTitle(lienInfo.name,for: .normal)
                lien.addTarget(self, action: #selector(openLien(sender:)), for: .touchUpInside)
            }else{
                pieceJointeLabel.isHidden=true;
                lien.isHidden=true;
            }
            
        }else {
            pieceJointeLabel.isHidden=true;
            lien.isHidden=true;
        }
    }
    
    @IBAction func openLien(sender: UIButton){
        
        let url = NSURL(string: String(data: information?.lien?.file as! Data, encoding: .utf8)!)!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImage"){
            let upcomming: ImagePopUpViewController = segue.destination as! ImagePopUpViewController
            
            let pieceimage = information?.image
            
            upcomming.image = UIImage(data: pieceimage!.file as! Data)
            upcomming.desc = pieceimage!.name
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

