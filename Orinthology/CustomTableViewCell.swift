//
//  CustomTableViewCell.swift
//  Orinthology
//
//  Created by Varun on 11/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import RYFloatingInput
import SkyFloatingLabelTextField
import TKFormTextField

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var textfield : SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
