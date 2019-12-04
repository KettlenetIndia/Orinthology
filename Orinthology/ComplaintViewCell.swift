//
//  ComplaintViewCell.swift
//  Orinthology
//
//  Created by Eorchids on 31/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class ComplaintViewCell: UITableViewCell {
    @IBOutlet weak var baseview: UIView!
    @IBOutlet weak var complaint_status: UILabel!
    
    @IBOutlet weak var complaint_date: UILabel!
    @IBOutlet weak var complaint_against: UILabel!
    @IBOutlet weak var complaint_id: UILabel!
    @IBOutlet weak var complaint_txtview: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseview.layer.cornerRadius = 10.0
        baseview.layer.shadowColor = UIColor.lightGray.cgColor
        baseview.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        baseview.layer.shadowRadius = 12.0
        baseview.layer.shadowOpacity = 0.5
        baseview.layer.borderColor = UIColor.clear.cgColor
        
        complaint_status.layer.cornerRadius = 10.0
        complaint_status.clipsToBounds = true
        
        complaint_txtview.isEditable = false
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
