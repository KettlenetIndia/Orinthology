//
//  ProfileVC.swift
//  Orinthology
//
//  Created by Eorchids on 29/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func dismissbtn(_ sender: UIButton) {
         // dismiss(animated: true, completion: nil)
        onSlideMenuButtonPressed(sender)
    }

    @IBAction func edit_profile_clicked(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "EditEmailVC") as! EditEmailVC
        self.present(next, animated: false, completion: nil)
    }
}
