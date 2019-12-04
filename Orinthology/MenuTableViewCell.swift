//
//  MenuTableViewCell.swift
//  Orinthology
//
//  Created by Varun on 11/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell
{
    @IBOutlet var namelbl :  UILabel!
    @IBOutlet var dotlbl :  UILabel!
    @IBOutlet var imageview : UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
