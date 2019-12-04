//
//  MainViewController.swift
//  Orinthology
//
//  Created by Eorchids on 25/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MainViewController: BaseViewController {

    @IBOutlet weak var next_btn: UIButton!
    @IBOutlet weak var complainttype_txt: UITextField!
    @IBOutlet weak var location_txt: UITextField!
    @IBOutlet weak var add_complaint_view: UIView!
    @IBOutlet weak var update_btn: UIButton!
    @IBOutlet weak var confirmpassword: SkyFloatingLabelTextField!
    @IBOutlet weak var newpassword: SkyFloatingLabelTextField!
    @IBOutlet weak var oldpassword: SkyFloatingLabelTextField!
    @IBOutlet weak var changepassword_view: UIView!
    let calledfrom:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location_txt.attributedPlaceholder = NSAttributedString(string: "  Enter your Address", attributes: [NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: "#d3d3d3")])
        addLineToView(view: location_txt, position:.LINE_POSITION_BOTTOM, color: hexStringToUIColor(hex: "#D63A39"), width: 0.7)
        setTextFieldLeftImage(txtField: location_txt, imgName: "ic_globe_loc")
        
        complainttype_txt.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: "#d3d3d3")])
        addLineToView(view: complainttype_txt, position:.LINE_POSITION_BOTTOM, color: hexStringToUIColor(hex: "#D63A39"), width: 0.7)
        setTextFieldLeftImage(txtField: complainttype_txt, imgName: "ic_building")
        
    }
    @IBAction func Menu_click(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender)
    }
    
    @IBAction func updatebtn_onclick(_ sender: UIButton) {
    }
    
    @IBAction func nextbtn_clicked(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ImageUploadVC") as! ImageUploadVC
               self.present(next, animated: true, completion: nil)
               
    }
}
