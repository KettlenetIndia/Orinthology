//
//  MenuView.swift
//  Orinthology
//
//  Created by Varun on 11/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

fileprivate struct menucellstruct
   {
       var name = ""
       var image = ""
    
    init(name:String,image:String)
    {
        self.name = name
        self.image = image
    
    }
    
}

class MenuView: UIView {

    @IBOutlet  var namelbl : UILabel!
    @IBOutlet  var animatelbl : UILabel!
    @IBOutlet var menutbl : UITableView!
    @IBOutlet var headerview : UIView!
    
    var selectedindex = 0
    
    var parentcontroller : UIViewController?
    fileprivate var menuarray = [menucellstruct]()
    
    var completeblock : (()->(Void))?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        menutbl.tableHeaderView = headerview
        
        
        var menustruct = menucellstruct(name: "Add New Complaints", image: "ic_user")
        menuarray.append(menustruct)
        
        menustruct = menucellstruct(name: "My Complaints", image: "ic_complaints")
        menuarray.append(menustruct)
        
        menustruct = menucellstruct(name: "My Profile", image: "ic_user")
        menuarray.append(menustruct)
        
        menustruct = menucellstruct(name: "Change Password", image: "ic_password")
        menuarray.append(menustruct)
    
        menustruct = menucellstruct(name: "Sign Out", image: "ic_signout")
        menuarray.append(menustruct)
               
        
    }
    
    func reloadviews()
    {
        let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
               
        namelbl.text = "Hello " + (userInfo["Full_Name"] as! String)
        
        
    }
    
    @IBAction func closemenuview(tap : UITapGestureRecognizer?)
    {
        UIView.animate(withDuration: 0.5, animations:
            {
            self.animatelbl.alpha = 0.0;
            self.menutbl.frame = CGRect(x: -self.menutbl.frame.size.width, y: 0, width: self.menutbl.frame.size.width, height: self.menutbl.frame.size.height)
            
        }) { (_) in
             self.isHidden = true
            if self.completeblock != nil
            {
                self.completeblock!()
                
                self.completeblock = nil
            }
   
        }
        
        
    }
    
    // MARK: TableView
        
    
    
    
    

}

extension MenuView : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return menuarray.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MenuTableViewCell
            
            if cell == nil
            {
                cell = (Bundle.main.loadNibNamed("MenuTableViewCell", owner: self, options: nil)?.first as! MenuTableViewCell)
            }
            cell?.namelbl.text = menuarray[indexPath.row].name
            cell?.imageview?.image = UIImage(named: menuarray[indexPath.row].image)
            
            cell?.selectionStyle = .none
            cell!.dotlbl.isHidden = true
            if indexPath.row == selectedindex
            {
                cell!.dotlbl.isHidden = false
            }
       
            
            
            cell!.dotlbl.layer.cornerRadius = 4
            cell!.dotlbl.layer.masksToBounds = true
            
            return cell!
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            if parentcontroller is HomeViewController
            {
                closemenuview(tap: nil)
                return
            }
            closemenuview(tap: nil)
            self.completeblock  = {
               
                for controller in (self.parentcontroller?.navigationController!.viewControllers)!
                {
                    if controller is HomeViewController
                    {
                        self.parentcontroller?.navigationController?.popToViewController(controller, animated: false)
                        return
                    }
                }
               
            }
            
        }
            
            else if indexPath.row == 1
                      {
                          if parentcontroller is ComplainViewController
                                     {
                                         closemenuview(tap: nil)
                                         return
                                     }
                          
                          closemenuview(tap: nil)
                          
                          self.completeblock =
                           {
                               
                               for controller in (self.parentcontroller?.navigationController!.viewControllers)!
                                                            {
                                                                if controller is ComplainViewController
                                                                {
                                                                    self.parentcontroller?.navigationController?.popToViewController(controller, animated: false)
                                                                    return
                                                                }
                                                            }
                               
                               
                            let complain = ComplainViewController(nibName: "ComplainViewController", bundle: nil)
                            self.parentcontroller?.navigationController?.pushViewController(complain, animated: false)
                          }
                          
                          
                      }
            
            else if indexPath.row == 2
        {
            if parentcontroller is ProfileViewController
                                  {
                                      closemenuview(tap: nil)
                                      return
                                  }
                                    
                                    closemenuview(tap: nil)
                                     self.completeblock =
                                        {
                                            
                                            
                                            for controller in (self.parentcontroller?.navigationController!.viewControllers)!
                                                                         {
                                                                             if controller is ProfileViewController
                                                                             {
                                                                                 self.parentcontroller?.navigationController?.popToViewController(controller, animated: false)
                                                                                 return
                                                                             }
                                                                         }
                                                          
                                                          
                                                        let change = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
                                                        self.parentcontroller?.navigationController?.pushViewController(change, animated: false)
                                    }
        
        }
            
            
        
        else if indexPath.row == 3
        {
            if parentcontroller is PasswordChangeVC
                       {
                           closemenuview(tap: nil)
                           return
                       }
            
            closemenuview(tap: nil)
            
            self.completeblock = {
                
                
                for controller in (self.parentcontroller?.navigationController!.viewControllers)!
                               {
                                   if controller is PasswordChangeVC
                                   {
                                       self.parentcontroller?.navigationController?.popToViewController(controller, animated: false)
                                       return
                                   }
                               }
                
                
              let change = PasswordChangeVC(nibName: "PasswordChangeVC", bundle: nil)
              self.parentcontroller?.navigationController?.pushViewController(change, animated: false)
                
            }
            
            
        }
        
       
         else if indexPath.row == 4
        {
            AppManager.removeobjectforkey(key : "userInfo")
            
            for controller in (self.parentcontroller?.navigationController!.viewControllers)!
                                                        {
                                                            if controller is SignInVC
                                                            {
                                                                self.parentcontroller?.navigationController?.popToViewController(controller, animated: true)
                                                                return
                                                            }
                                                        }
            
            let signin = SignInVC(nibName: "SignInVC", bundle: nil)
            self.parentcontroller?.navigationController?.pushViewController(signin, animated: true)
            
        }
        
        
    }
}

extension MenuView : UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: self.menutbl))!
        {
            return false
        }
        return true
    }
    
}
