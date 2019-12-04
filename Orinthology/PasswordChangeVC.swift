//
//  PasswordChangeVC.swift
//  Orinthology
//
//  Created by Eorchids on 01/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PasswordChangeVC: UIViewController {
    
    
    private var customarray = [CustomStruct]()
    var menuview : MenuView!
    @IBOutlet var childview : UIView!
    @IBOutlet  var customtbl : UITableView!
    @IBOutlet  var headerview : UIView!
    @IBOutlet  var footerview : UIView!
    
    @IBOutlet var sosbtn : UIButton!
    @IBOutlet var locationbtn:UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
        
     var custom =  CustomStruct()
        custom.placeholderlabel  = "Enter Old Password"
        custom.value = ""
        custom.secure = true
        custom.errormessage = "Please Enter Old Password"
        custom.paramter = "old_password"
        customarray.append(custom)
        
        custom =  CustomStruct()
                                custom.placeholderlabel  = "Create New Password"
                                custom.value = ""
                                custom.secure = true
                                custom.errormessage = "Please Enter New Password"
        custom.paramter = "new_password"
                                customarray.append(custom)
              
              custom =  CustomStruct()
              custom.placeholderlabel  = "Confirm New Password"
              custom.value = ""
              custom.secure = true
              custom.errormessage = "Please Enter Confirm New Password"
              custom.matchpassword = true
         custom.paramter = "new_password"
              customarray.append(custom)
        
        
        menuview = (Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)?.first as! MenuView)
              
              menuview.frame = CGRect(x: 0, y: 0, width: childview.frame.size.width, height: childview.frame.size.height)
              menuview.menutbl.frame = CGRect(x: -(childview.frame.size.width-70), y: 0, width: childview.frame.size.width-70, height: childview.frame.size.height)
              
              menuview.isHidden = true
              
              childview.addSubview(menuview)
        customtbl.tableHeaderView = headerview
        
        customtbl.tableFooterView = footerview
        
        sosbtn.layer.masksToBounds = true;
               sosbtn.layer.cornerRadius = 10.0
               locationbtn.layer.masksToBounds = true;
               locationbtn.layer.cornerRadius = 10.0
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        menuview.parentcontroller = self
        menuview.selectedindex = 3
    }
    
    @IBAction func updatepassword_btn(_ sender: UIButton)
    {
        if checkvalidation()
        {
            let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
            
            let User_id = userInfo["User_id"] as! Any

            
            var parameters = [String:Any]()
                  
                  for custom in customarray
                     {
                         let value = custom.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                         parameters[custom.paramter] = value
                     }
               
            parameters["user_id"] = User_id
                  
         
                  
                  let baseurl = AppManager.baseurl + "user_password_change"
                  
                  AppManager.appdelegate.showhud()
                  
                  AppManager.sharedmanager.postwebservice(url: baseurl, param: parameters) { (responsedata, error) -> (Void) in
                      
                      AppManager.appdelegate.hidehud()
                      
                      if error != nil
                      {
                          let code = (error! as NSError).code

                          if code == NSURLErrorNotConnectedToInternet
                          {
                              AppManager.showalert("Please Check Your Internet Connection", nil, self)
                          }
                          else
                          {
                              AppManager.showalert("Server Error!! Please Try Again", nil, self)
                          }
                      }
                      else
                      {
                          
                          let json = try! JSONSerialization.jsonObject(with: responsedata!, options: .allowFragments) as! [String:Any]

                          let status = json["status"] as! Int
                          
                          if status == 1
                          {
                             let dict =   json["data"] as! [String:Any]
                                                       let msg = dict["msg"] as! String
                                                       
                                                       AppManager.showalert(msg , nil, self) {
                                                           self.navigationController?.popViewController(animated: true)
                                                       }
                          }
                          else
                          {
                              AppManager.showalert(json["error"] as! String , nil, self)
                          }
                      }
                      
                      
                  }
            
            
            
        }
        
        
    }
    
    
    @IBAction func open_menu_action(sender:UIButton)
      {
           menuview.reloadviews()
          menuview.isHidden = false
              UIView.animate(withDuration: 0.5)
              {
                  self.menuview.animatelbl.alpha = 0.4;
                  self.menuview.menutbl.frame = CGRect(x: 0, y: 0, width: self.menuview.menutbl.frame.size.width, height: self.menuview.menutbl.frame.size.height)
              }
              

      }
    
    
    @IBAction func location_service_action(sender:UIButton)
      {
          UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
      }
      @IBAction func sos_service_action(sender:UIButton)
      {
          let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
                              
                    
               
                var parameters = [String:Any]()
               parameters["country"] = userInfo["country"] as! String
               
               
                      AppManager.appdelegate.showhud()
                      
                      let baseurl = AppManager.baseurl + "sos_number"
               
               
               
                      AppManager.sharedmanager.postwebservice(url: baseurl, param: parameters ) { (responsedata, error) -> (Void) in
                          
                          AppManager.appdelegate.hidehud()
                          
                          if error != nil
                                  {
                                      let code = (error! as NSError).code
                                      if code == NSURLErrorNotConnectedToInternet
                                      {
                                          AppManager.showalert("Please Check Your Internet Connection", nil, self)
                                      }
                                      else
                                      {
                                          AppManager.showalert("Server Error!! Please Try Again", nil, self)
                                      }
                                  }
                          else
                          {
                              let json = try! JSONSerialization.jsonObject(with: responsedata!, options: .allowFragments) as! [String:Any]
                                           let status = json["status"] as! Int
                                           if status == 1
                                           {
                                              let dict = json["data"] as! [String:Any]
                                             let phonenumber = dict["Phone Number"] as? String ?? ""
                                               
                                               
                                              // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:12125551212"]];
                                               
                                               if phonenumber != ""
                                               {
                                                   UIApplication.shared.open(URL(string: "tel:" + phonenumber)!, options: [UIApplication.OpenExternalURLOptionsKey : Any]())
                                                   { (check) in
                                                                                             
                                                   }
                                               }
                                               else
                                               {
                                                  AppManager.showalert("Invalid Phone Number" , nil, self)
                                               }
                                               
                                           }
                                           else
                                           {
                                               AppManager.showalert(json["error"] as! String , nil, self)
                                           }
                          }
                          
                      }
      }
    
    func checkvalidation() -> Bool
    {
      for (index, custom) in customarray.enumerated()
        {
            let value = custom.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if value == ""
            {
                AppManager.showalert(custom.errormessage,nil, self)
                return false
            }
            else if (custom.matchpassword)
            {
              if (customarray[index-1].value != custom.value)
              {
                  AppManager.showalert("Password does not match",nil, self)
                  return false
              }
            }
         
        
      }
        
        return true
    }
   
}

extension PasswordChangeVC : UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return customarray.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell
            
            if cell == nil
            {
                cell = (Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell)
            }
            
            let custom =  customarray[indexPath.row]
            
            cell!.textfield.isSecureTextEntry = custom.secure
            cell!.textfield.placeholder = custom.placeholderlabel
            cell!.textfield.text = custom.value
            
            cell?.textfield.delegate = self
            
            cell?.selectionStyle = .none
            
            cell?.textfield.tag = indexPath.row
            
            return cell!
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell
            cell?.textfield.becomeFirstResponder()
        }
    
}

extension PasswordChangeVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {
           textField.resignFirstResponder()
           return true
       }
       
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
       {
           let row = textField.tag
           var globalstring = ""
           if range.length == 0
           {
               var appendstring = textField.text!
               if appendstring.count > range.location
               {
                   let index = appendstring.index(appendstring.startIndex, offsetBy: range.location)
                   appendstring.insert(Character(string), at: index)
               }
               else
               {
                   appendstring += string
               }
               globalstring = appendstring
               customarray[row].value = globalstring
           }
           else
           {
               var appendstring = textField.text!
               let swiftrange = Range(range, in: appendstring)!
               appendstring =  appendstring.replacingCharacters(in: swiftrange, with: "")
               globalstring = appendstring
               customarray[row].value = globalstring
           }
           
         
          
           return true
       }
    
}

