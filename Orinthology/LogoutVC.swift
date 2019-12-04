//
//  LogoutVC.swift
//  Orinthology
//
//  Created by Eorchids on 01/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class LogoutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Yes_btn_clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func No_btn_clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CloseView_Clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
