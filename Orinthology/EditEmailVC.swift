//
//  EditEmailVC.swift
//  Orinthology
//
//  Created by Eorchids on 02/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditEmailVC: UIViewController {

    @IBOutlet weak var locationimg: UIImageView!
    
    @IBOutlet weak var otp: SkyFloatingLabelTextField!
    
    @IBOutlet weak var newemailaddress: SkyFloatingLabelTextField!
    @IBOutlet weak var emailaddress: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailaddress.placeholder = "Your Old E-Mail Address"
        emailaddress.title = "Your Old E-Mail Address"
        
        
        otp.placeholder = "Confirm OTP"
        otp.title = "Confirm OTP"
        
        newemailaddress.placeholder = "Enter New E-Mail Address"
        newemailaddress.title = "Enter New E-Mail Address"
    }

    @IBAction func backbtn_clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sosbtn_pressed(_ sender: UIButton) {
    }
    
    @IBAction func sendotp_clicked(_ sender: UIButton) {
    }
    
    @IBAction func updatebtn_clicked(_ sender: UIButton) {
    }
    
    
    
}
