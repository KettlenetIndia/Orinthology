//
//  SignUpVC.swift
//  Orinthology
//
//  Created by Eorchids on 24/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField

class SignUpVC: UIViewController {
    
//    @IBOutlet weak var scrollview: UIScrollView!
//    @IBOutlet weak var fullname_txt: SkyFloatingLabelTextField!
//    @IBOutlet weak var email_txt: SkyFloatingLabelTextField!
//    @IBOutlet weak var mobile_txt: SkyFloatingLabelTextField!
//    @IBOutlet weak var password_txt: SkyFloatingLabelTextField!
//    @IBOutlet weak var confirmpswd_txt: SkyFloatingLabelTextField!
    
    
       @IBOutlet  var childview : UIView!
       @IBOutlet  var headerview : UIView!
       @IBOutlet  var footerview : UIView!
       @IBOutlet  var customtbl : UITableView!
        
       private var customarray = [CustomStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
//        view.addSubview(scrollview)
//        fullname_txt.delegate = self
//        fullname_txt.becomeFirstResponder()
//        fullname_txt.placeholder = "Full Name"
//        fullname_txt.title = "Full Name"
//
//        email_txt.placeholder = "E-Mail Address"
//        email_txt.title = "E-Mail Address"
//
//        mobile_txt.placeholder = "Mobile No"
//        mobile_txt.title = "Mobile No"
//
//        password_txt.placeholder = "Create Password"
//        password_txt.title = "Create Password"
//
//        confirmpswd_txt.placeholder = "Confirm Password"
//        confirmpswd_txt.title = "Confirm Password"
        
        var custom =  CustomStruct()
        custom.placeholderlabel  = "Full Name"
        custom.value = ""
        custom.errormessage = "Please Enter Full Name"
        custom.paramter = "full_name"
        customarray.append(custom)
        
        
         custom =  CustomStruct()
              custom.placeholderlabel  = "E-Mail Address"
              custom.value = ""
              custom.errormessage = "Please Enter E-Mail Address"
              custom.emailvalidation = true
              custom.paramter = "email"
              customarray.append(custom)
        
                     custom =  CustomStruct()
                     custom.placeholderlabel  = "Mobile No"
                     custom.value = ""
                     custom.errormessage = "Please Enter Mobile No"
                     custom.paramter = "mobile"
                     custom.mobilevalidation = true
                     custom.keyboardtype = UIKeyboardType.phonePad.rawValue
        
                     customarray.append(custom)
              
                          custom =  CustomStruct()
                          custom.placeholderlabel  = "Create Password"
                          custom.value = ""
                          custom.secure = true
                          custom.errormessage = "Please Enter Password"
                          custom.paramter = "password"
                          customarray.append(custom)
                          
        
        custom =  CustomStruct()
        custom.placeholderlabel  = "Confirm Password"
        custom.value = ""
        custom.secure = true
        custom.errormessage = "Please Enter Confirm Password"
        custom.matchpassword = true
        custom.paramter = "password"
        customarray.append(custom)
        
        customtbl.tableHeaderView = headerview
        customtbl.tableFooterView = footerview
    }
    
   
    
    @IBAction func SignIn_clicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Register_clicked(_ sender: UIButton)
    {
        if checkvalidation() {
            
            var parameters = [String:Any]()
                  
                  for custom in customarray
                     {
                         let value = custom.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                         parameters[custom.paramter] = value
                     }
                  
                  let baseurl = AppManager.baseurl + "user_register"
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
                              AppManager.savetouserdefault(value: json["data"], key: "userInfo")
                                let home =  HomeViewController(nibName: "HomeViewController", bundle: nil)
                                self.navigationController?.pushViewController(home, animated: true)
                          }
                          else
                          {
                              AppManager.showalert(json["error"] as! String , nil, self)
                          }
                      }
                      
                      
                  }
                  
        }
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
            else if (custom.mobilevalidation)
            {
                 if value.count != 10
                                  {
                                       AppManager.showalert("Please Enter Valid Mobile Number",nil, self)
                                       return false;
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

extension SignUpVC :UITableViewDelegate,UITableViewDataSource
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


extension SignUpVC : UITextFieldDelegate
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
