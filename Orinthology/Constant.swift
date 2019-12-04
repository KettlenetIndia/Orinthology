//
//  Constant.swift
//  Orinthology
//
//  Created by Eorchids on 25/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import Foundation
import UIKit

var userDefaults:UserDefaults = UserDefaults.standard
var getLoginStatus:String = "false"
var cornerRadius:CGFloat = 10.0


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}
func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
    let lineView = UIView()
    lineView.backgroundColor = color
    lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
    view.addSubview(lineView)
    
    let metrics = ["width" : NSNumber(value: width)]
    let views = ["lineView" : lineView]
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
    
    switch position {
    case .LINE_POSITION_TOP:
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        break
    case .LINE_POSITION_BOTTOM:
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        break
        
    }
}
func setTextFieldLeftImage(txtField:UITextField, imgName:String)  {
    
    let imgView = UIImageView(image: UIImage(named: imgName))
    imgView.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40);
    imgView.contentMode = .scaleAspectFit;
    txtField.leftView = imgView
    txtField.leftViewMode = UITextField.ViewMode.always
}
func ApplyRoundCornerToButton(_ object:AnyObject){
    if #available(iOS 12.0, *) {
        if #available(iOS 13.0, *) {
            object.layer.cornerRadius = object.frame.size.width / 2
        } else {
            // Fallback on earlier versions
        }
    } else {
        // Fallback on earlier versions
    }
    if #available(iOS 13.0, *) {
        object.layer.masksToBounds = true
    } else {
        // Fallback on earlier versions
    }
}
func setTextFieldRightImage(txtField:UITextField, imgName:String)  {
    
    let imgView = UIImageView(image: UIImage(named: imgName))
    imgView.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 20);
    imgView.contentMode = .scaleAspectFit;
    txtField.rightView = imgView
    txtField.rightViewMode = UITextField.ViewMode.always
}
func setTextFieldRightImage2(txtField:UITextField, imgName:String)  {
    
    let imgView = UIImageView(image: UIImage(named: imgName))
    imgView.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 15);
    imgView.contentMode = .scaleAspectFit;
    txtField.rightView = imgView
    txtField.rightViewMode = UITextField.ViewMode.always
    
}
func setViewOutlineStyle(views:[UIView], clearColor:Bool){
    
    for view in views {
        
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        if clearColor{
            view.backgroundColor = UIColor.clear
        }
    }
}
func setViewOutlineStyleButton(button:[UIButton], clearColor:Bool){
    
    for btn in button {
        
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        
        if clearColor{
            btn.backgroundColor = UIColor.clear
        }
    }
}
func setViewOutlineStyleButtongray(button:[UIButton], clearColor:Bool){
    
    for btn in button {
        
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        
        if clearColor{
            btn.backgroundColor = UIColor.clear
        }
    }
    }
    func setButtonFilledStyle(buttons:[UIButton]){
        
        for btn in buttons {
            
            btn.layer.borderColor = UIColor.clear.cgColor
            btn.layer.borderWidth = 0
           // btn.backgroundColor = UIColor.lightGray
            btn.layer.cornerRadius = cornerRadius
            btn.clipsToBounds = true
            btn.setTitleColor(UIColor.darkGray, for: .normal)
           // btn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: (btn.titleLabel?.font?.pointSize)!)
        }
    }
func setButtonFilledStyleBlack(buttons:[UIButton]){
       
       for btn in buttons {
           
           btn.layer.borderColor = UIColor.clear.cgColor
           btn.layer.borderWidth = 0
           btn.backgroundColor = UIColor.black
           btn.layer.cornerRadius = cornerRadius
           btn.clipsToBounds = true
           btn.setTitleColor(UIColor.white, for: .normal)
         //  btn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: (btn.titleLabel?.font?.pointSize)!)
       }
   }
