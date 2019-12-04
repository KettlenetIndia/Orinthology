//
//  ListOrganizationView.swift
//  Orinthology
//
//  Created by Varun on 20/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

struct OrganizationStruct : Codable
{
    var Company_Type  = ""
    var Email = ""
    var Location  = ""
    var Organisation_id = ""
    var Organisation_name = ""
    var Phone_Number = ""
}

import UIKit

class ListOrganizationView: UIView {

    @IBOutlet var topview : UIView!
    @IBOutlet var headerview : UIView!
    @IBOutlet var listtblview : UITableView!
    @IBOutlet var orgtextfield : UITextField!
    var  parentcontroller : UIViewController!
    var organizationarray = [OrganizationStruct]()
    var temparray = [OrganizationStruct]()
    var orgblock : ((OrganizationStruct)->(Void))!
    
    override func awakeFromNib()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func reloadViews()
    {
        topview.frame = CGRect(x: self.frame.size.width/2-topview.frame.size.width/2, y:self.frame.size.height/2-topview.frame.size.height/2 , width: topview.frame.size.width, height: topview.frame.size.height)
    }

    func loadorgnization( block : @escaping (()->(Void)))
    {
        organizationarray.removeAll()
        
        
        AppManager.appdelegate.showhud()
        
        let baseurl = AppManager.baseurl + "list_organisation"
        AppManager.sharedmanager.getwebservice(url: baseurl, param: [String:Any]()) { (responsedata, error) -> (Void) in
            
            AppManager.appdelegate.hidehud()
            
            if error != nil
                    {
                        let code = (error! as NSError).code
                        if code == NSURLErrorNotConnectedToInternet
                        {
                            AppManager.showalert("Please Check Your Internet Connection", nil, self.parentcontroller)
                        }
                        else
                        {
                            AppManager.showalert("Server Error!! Please Try Again", nil, self.parentcontroller)
                        }
                    }
            else
            {
                let json = try! JSONSerialization.jsonObject(with: responsedata!, options: .allowFragments) as! [String:Any]
                             let status = json["status"] as! Int
                             if status == 1
                             {
                                for checkvalue in json["data"] as! Array<[String:Any]>
                                {
                                     let jsondata = try! JSONSerialization.data(withJSONObject: checkvalue as [String:Any], options: .prettyPrinted)
                                     let org = try! JSONDecoder().decode(OrganizationStruct.self, from: jsondata)
                                     self.organizationarray.append(org)
                                     self.temparray.append(org)
                                    
                                }
                              
                                self.listtblview.reloadData()
                                
                               block()
                             }
                             else
                             {
                                 AppManager.showalert(json["error"] as! String , nil, self.parentcontroller)
                             }
            }
            
        }
        
        
    }
    
    @IBAction func removeview()
    {
        self.removeFromSuperview()
    }
    
    //Show keyboard
    @objc func keyboardShow(aNotification : NSNotification)
    {
       // NSDictionary *info = [aNotification userInfo];
       // CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
        
        let keyboardSize = (aNotification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        print(keyboardSize?.height as Any)
        
        let y = UIScreen.main.bounds.size.height-keyboardSize!.height
        
        let minus = (topview.frame.origin.y+topview.frame.size.height+AppManager.sharedmanager.toppadding)-y;
        
        
        if minus>0
        {
            let topy = self.frame.size.height/2-topview.frame.size.height/2
            UIView.animate(withDuration: 0.2, animations:
                {
                self.topview.frame = CGRect(x:self.topview.frame.origin.x, y: topy-minus, width: self.topview.frame.size.width, height: self.topview.frame.size.height)
            }) { (check) in
                
            }
           
        
        }
        
       
        
        
    }
    
 
      @objc func keyboardHide(aNotification : NSNotification)
      {
          
        let topy = self.frame.size.height/2-topview.frame.size.height/2
                   UIView.animate(withDuration: 0.2, animations: {
                    self.topview.frame = CGRect(x:self.topview.frame.origin.x, y: topy, width:self.topview.frame.size.width, height: self.topview.frame.size.height)
                   }) { (check) in
                       
                   }
        
      }
    
    
}

extension ListOrganizationView : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        

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
                 
                  }
                  else
                  {
                      var appendstring = textField.text!
                      let swiftrange = Range(range, in: appendstring)!
                      appendstring =  appendstring.replacingCharacters(in: swiftrange, with: "")
                      globalstring = appendstring
                  }
        
        
    temparray =   organizationarray.filter { (orgstruct) -> Bool in
            
        return orgstruct.Organisation_name.localizedCaseInsensitiveContains(globalstring)
    
        }
        
        
        if globalstring == "" {
            
           temparray = organizationarray
            
        }
        
        
        listtblview.reloadData()
        
        return true
        
    }
    
}

extension ListOrganizationView : UITableViewDelegate,UITableViewDataSource
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return temparray.count
           
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
           
           if cell == nil
           {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
           }
           
           let orgStruct =  temparray[indexPath.row]
        
           cell?.textLabel?.text = orgStruct.Organisation_name
           cell?.selectionStyle = .none
           
           return cell!
       }
       
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
       {
         let orgStruct =  temparray[indexPath.row]
           orgblock(orgStruct)
        
        
        orgtextfield.text = ""
        self.removeFromSuperview()
        

       }
    
}


