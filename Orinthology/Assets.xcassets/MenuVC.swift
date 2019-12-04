//
//  MenuVC.swift
//  Orinthology
//
//  Created by Eorchids on 25/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var tblMenuOptions : UITableView!
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet weak var btnCloseOver: UIButton!
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
       *  Array containing menu options
       */
     var arrayMenuOptions = [Dictionary<String,String>]()
       
       /**
       *  Menu button which was tapped to display the menu
       */
     var btnMenu : UIButton!
       
       /**
       *  Delegate of the MenuVC
       */
      var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        tblMenuOptions.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           updateArrayMenuOptions()
       }
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"My Profile", "icon":"ic_user-1"])
        arrayMenuOptions.append(["title":"Change Password", "icon":"ic_password"])
        arrayMenuOptions.append(["title":"My Complaints", "icon":"ic_complaints"])
        arrayMenuOptions.append(["title":"Sign Out", "icon":"ic_signout"])
        
        tblMenuOptions.reloadData()
        
        
    }
    @IBAction func onCloseMenuClick(_ sender: UIButton) {
        btnMenu.tag = 0
                      
                      if (self.delegate != nil) {
                          var index = Int32(sender.tag)
                          
                          if(sender == self.btnCloseOver){
                              index = -1
                          }
                          delegate?.slideMenuItemSelectedAtIndex(index)
                      }
                      
                      UIView.animate(withDuration: 0.3, animations: { () -> Void in
                          self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                          self.view.layoutIfNeeded()
                          self.view.backgroundColor = UIColor.clear
                          }, completion: { (finished) -> Void in
                              self.view.removeFromSuperview()
                              self.removeFromParent()
                      })
    }
    
    @IBAction func Close_btn(_ sender: UIButton) {
      //dismiss(animated: true, completion: nil)
        sender.tag = -1
        self.onCloseMenuClick(sender)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
         
         cell.selectionStyle = UITableViewCell.SelectionStyle.none
         cell.layoutMargins = UIEdgeInsets.zero
         cell.preservesSuperviewLayoutMargins = false
         cell.backgroundColor = UIColor.clear
         
        cell.icon_menu.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        
        cell.menu_label.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let btn = UIButton(type: UIButton.ButtonType.custom)
         btn.tag = indexPath.row
         print("Index from tag",btn.tag)
        
         self.onCloseMenuClick(btn)
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrayMenuOptions.count
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1;
     }
}
