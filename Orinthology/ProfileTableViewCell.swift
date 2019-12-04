//
//  ProfileTableViewCell.swift
//  Orinthology
//
//  Created by Varun on 25/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet  var iconimage: UIImageView?
    @IBOutlet var namelbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
