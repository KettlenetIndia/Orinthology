//
//  MyComplainTableViewCell.swift
//  Orinthology
//
//  Created by Varun on 21/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class MyComplainTableViewCell: UITableViewCell {

    @IBOutlet var topview : UIView!
    @IBOutlet var idlbl : UILabel!
    @IBOutlet var againstlbl : UILabel!
    @IBOutlet var datelbl : UILabel!
    @IBOutlet var statuslbl : UILabel!
    @IBOutlet var commentview : UIView!
    @IBOutlet var commentlbl : UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        

    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected (selected, animated: animated)


        
        
    }
    
}
