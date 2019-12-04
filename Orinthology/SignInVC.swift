//
//  SignInVC.swift
//  Orinthology
//
//  Created by Eorchids on 23/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//


import UIKit
import RYFloatingInput
import SkyFloatingLabelTextField
import TKFormTextField

class SignInVC: UIViewController
{

//    @IBOutlet weak var Signin_btn: UIButton!
//    @IBOutlet weak var password_show: UIButton!
//    @IBOutlet weak var email_address: SkyFloatingLabelTextField!
//    @IBOutlet weak var password: SkyFloatingLabelTextField!
//    @IBOutlet weak var pswd_on_off_img: UIImageView!
//    @IBOutlet weak var tick_img: UIImageView!
//    var password_onoff_click:Bool = false
    

    
    @IBOutlet  var childview : UIView!
    @IBOutlet  var headerview : UIView!
    @IBOutlet  var footerview : UIView!
    @IBOutlet  var customtbl : UITableView!
     
    private var customarray = [CustomStruct]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
        
      
        
        var custom =  CustomStruct()
        custom.placeholderlabel  = "E-Mail / Mobile"
        custom.value = ""
        custom.errormessage = "Please Enter E-Mail Address/Mobile No"
        custom.emailvalidation = true
        custom.paramter = "username"
        customarray.append(custom)
        
                 custom =  CustomStruct()
                    custom.placeholderlabel  = "Password"
                    custom.value = ""
                   custom.secure = true
        custom.errormessage = "Please Enter Password"
        custom.paramter = "password"
                  customarray.append(custom)
        
        
        
        customtbl.tableHeaderView = headerview
        
        customtbl.tableFooterView = footerview
        
//        email_address.placeholder = "E-Mail Address"
//        email_address.placeholderFont = UIFont(name:"RobotoSlab-Regular",size: 17)
//        email_address.title = "E-Mail Address"
//
//        password.placeholder = "Password"
//        password.title = "Password"
//
//        email_address.delegate = self
//        email_address.errorColor = UIColor.red
    }
    
    @IBAction func tick_img_click(_ sender: UIButton)
    {
        
        
        
    }
    
    @IBAction func forgot_clicked(_ sender: UIButton)
    {
        let forgot = ForgotPasswordViewController(nibName:"ForgotPasswordViewController",bundle: nil)
        self.navigationController?.pushViewController(forgot, animated: true)
    }
    
    @IBAction func Signup_clicked(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let next = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
//
//        self.navigationController?.pushViewController(next, animated: true)
        
        let signup = SignUpVC(nibName:"SignUpVC",bundle: nil)
        
        self.navigationController?.pushViewController(signup, animated: true)
        
    }
    
    @IBAction func Signin_btnclick(_ sender: UIButton)
    {
      if checkvalidation()
      {
           var parameters = [String:Any]()
        
        for custom in customarray
           {
               let value = custom.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
               parameters[custom.paramter] = value
           }
        
        let baseurl = AppManager.baseurl + "user_login"
        
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
        
    
        
//        getLoginStatus = "true"
//        userDefaults.set("true", forKey: getLoginStatus)
//        userDefaults.synchronize()
//
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func password_showoff(_ sender: UIButton) {
        
    }
   
 
    
    // MARK: Validation
    
    func checkvalidation() -> Bool
    {
        for custom in customarray
        {
            let value = custom.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if value == ""
            {
                AppManager.showalert(custom.errormessage,nil, self)
                return false
            }
            else if (custom.emailvalidation)
            {
            
                if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: value))
                {
                    if value.count != 10
                    {
                         AppManager.showalert("Please Enter Valid Mobile Number",nil, self)
                         return false;
                    }
                    
                    
                }
                else
                {
                    if (!validateEmail(enteredEmail: value))
                                  {
                                       AppManager.showalert("Please Enter Valid Email",nil, self)
                                       return false
                                  }
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

extension SignInVC : UITableViewDataSource,UITableViewDelegate
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

extension SignInVC : UITextFieldDelegate
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
