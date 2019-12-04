//
//  SubmitComplaintVC.swift
//  Orinthology
//
//  Created by Eorchids on 31/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SubmitComplaintVC: UIViewController {

    @IBOutlet weak var checkbox_img: UIImageView!
    @IBOutlet weak var location_img: UIImageView!
    @IBOutlet weak var sendEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var sendWhatsapp: SkyFloatingLabelTextField!
    @IBOutlet weak var complaint: SkyFloatingLabelTextField!
    var selected:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        complaint.placeholder = "Enter Comment"
        complaint.title = "Enter Comment"
        
        sendWhatsapp.placeholder = "Send in Whatsapp"
        sendWhatsapp.title = "Send in Whatsapp"
        
        sendEmail.placeholder = "Send in Email"
        sendEmail.title = "Send in Email"
    }
    @IBAction func backbtn_pressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sos_clicked(_ sender: UIButton) {
        
    }
    
    @IBAction func ananomous_btn_clicked(_ sender: UIButton) {
        
        if selected == false{
            checkbox_img.image = UIImage(named: "checked")
            selected = true
        }else{
            checkbox_img.image = UIImage(named: "unckecked")
            selected = false
        }
    }
    
    @IBAction func submit_clicked(_ sender: UIButton) {
    }
    
}
