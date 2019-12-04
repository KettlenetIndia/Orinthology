//
//  EditProfileTableViewCell.swift
//  Orinthology
//
//  Created by Varun on 25/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import RYFloatingInput
import SkyFloatingLabelTextField
import TKFormTextField


class EditProfileTableViewCell: UITableViewCell {

    
    @IBOutlet var textfield : SkyFloatingLabelTextField!
    @IBOutlet  var iconimage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

extension SkyFloatingLabelTextField
{
//    open override func textRect(forBounds bounds: CGRect) -> CGRect
 //   {
//        return bounds.inset(by: UIEdgeInsets(top: 0, left:30, bottom: 0, right:5))
//    }
//
//    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect
//    {
//        return bounds.inset(by: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 5))
//    }
//    open override func editingRect(forBounds bounds: CGRect) -> CGRect
//    {
//        return bounds.inset(by: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 5))
//    }
    
}




