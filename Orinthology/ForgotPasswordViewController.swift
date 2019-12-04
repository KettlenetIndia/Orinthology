//
//  ForgotPasswordViewController.swift
//  Orinthology
//
//  Created by Varun on 15/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

         @IBOutlet  var childview : UIView!
         @IBOutlet  var headerview : UIView!
         @IBOutlet  var footerview : UIView!
         @IBOutlet  var customtbl : UITableView!
      private var customarray = [CustomStruct]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
        
                    var custom = CustomStruct()
                    custom.placeholderlabel  = "E-Mail Address"
                    custom.value = ""
                    custom.errormessage = "Please Enter E-Mail Address"
                    custom.emailvalidation = true
                    custom.paramter = "email"
                    customarray.append(custom)
        
        customtbl.tableHeaderView = headerview
        customtbl.tableFooterView = footerview

    }
    
    @IBAction func send_clicked(_ sender: UIButton)
       {
            if checkvalidation()
               {
                    var parameters = [String:Any]()
                 
                 for custom in customarray
                    {
                        let value = custom.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        parameters[custom.paramter] = value
                    }
                 
                 let baseurl = AppManager.baseurl + "forgot_password"
                 
                
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
    
    @IBAction func back_clicked(_ sender: UIButton)
          {
            self.navigationController?.popViewController(animated: true)
          }

    
    // MARK: Validation
      
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
              else if (!validateEmail(enteredEmail: value) && custom.emailvalidation)
              {
                  AppManager.showalert("Please Enter Valid Email",nil, self)
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
      
      func validateEmail(enteredEmail:String) -> Bool {

          let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
          return emailPredicate.evaluate(with: enteredEmail)

      }
    
    
}


   extension ForgotPasswordViewController :UITableViewDelegate,UITableViewDataSource
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
              
              cell?.textfield.keyboardType = UIKeyboardType(rawValue: custom.keyboardtype)!
            
              return cell!
            
            
          }
          
          
          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
          {
              let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell
              cell?.textfield.becomeFirstResponder()
          }
   }
extension ForgotPasswordViewController : UITextFieldDelegate
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

   
