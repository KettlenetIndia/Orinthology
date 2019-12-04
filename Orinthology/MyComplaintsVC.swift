//
//  MyComplaintsVC.swift
//  Orinthology
//
//  Created by Eorchids on 31/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class MyComplaintsVC: BaseViewController,UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var location_image: UIImageView!
    @IBOutlet weak var complaints_tableview: UITableView!
    @IBOutlet weak var pending_btn: UIButton!
    @IBOutlet weak var resolved_btn: UIButton!
    @IBOutlet weak var all_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonFilledStyleBlack(buttons: [all_btn])
        setButtonFilledStyle(buttons: [pending_btn])
        setButtonFilledStyle(buttons: [resolved_btn])
    }
    
    @IBAction func All_Clicked(_ sender: UIButton) {
    }
    @IBAction func Pending_Clicked(_ sender: UIButton) {
    }
    
    @IBAction func Resolved_Clicked(_ sender: UIButton) {
    }
    @IBAction func newcomplaint_clicked(_ sender: UIButton) {
       let next = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(next, animated: false, completion: nil)
    }
    
    @IBAction func sos_clicked(_ sender: UIButton) {
    }
    @IBAction func sidemenu_clicked(_ sender: UIButton) {
        
        onSlideMenuButtonPressed(sender)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintViewCell") as! ComplaintViewCell
            
           return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ComplaintdetailsVC") as! ComplaintdetailsVC
            self.present(next, animated: false, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1;
        }
}
