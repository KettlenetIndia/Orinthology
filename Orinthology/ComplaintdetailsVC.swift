//
//  ComplaintdetailsVC.swift
//  Orinthology
//
//  Created by Eorchids on 01/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class ComplaintdetailsVC: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var status_btn: UILabel!
    @IBOutlet weak var images_tableview: UITableView!
    
    @IBOutlet weak var complaint_against: UILabel!
    @IBOutlet weak var complaint_comments: UITextView!
    
    @IBOutlet weak var status_location: UIImageView!
    @IBOutlet weak var admin_response: UITextView!
    @IBOutlet weak var complaint_id: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status_btn.layer.cornerRadius = 10.0
        status_btn.clipsToBounds = true
        complaint_comments.isEditable = false
        admin_response.isEditable = false
    }

    @IBAction func closebtn_clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addnewcomplaint_btn(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
               self.present(next, animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
               let cell = tableView.dequeueReusableCell(withIdentifier: "complaintlistTVC") as! complaintlistTVC
               
              return cell
           }
           
           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           }
           
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return 1
           }
           
           func numberOfSections(in tableView: UITableView) -> Int {
               return 1;
           }
    
    
    @IBAction func sos_clicked(_ sender: UIButton) {
    }
}
