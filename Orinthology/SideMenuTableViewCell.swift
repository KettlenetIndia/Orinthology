//
//  SideMenuTableViewCell.swift
//  Orinthology
//
//  Created by Eorchids on 29/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selector_img: UIImageView!
    @IBOutlet weak var icon_menu: UIImageView!
    @IBOutlet weak var menu_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selector_img.image = nil
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
