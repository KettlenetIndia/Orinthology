//
//  EditProfileViewController.swift
//  Orinthology
//
//  Created by Varun on 25/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class EditProfileViewController: UIViewController {
   @IBOutlet  var childview : UIView!
    
     var profilearray = [CustomStruct]()
    
    @IBOutlet var profiletbl : UITableView!
    @IBOutlet var headerview : UIView!
    @IBOutlet var footerview : UIView!
    @IBOutlet var arrowimage : UIImageView!
     @IBOutlet var currenttbn : UIButton!
    var state = ""
    var city = ""
    var location = ""
    var country = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
        
        arrowimage.layer.masksToBounds = true
        arrowimage.layer.cornerRadius = 1.0
        arrowimage.layer.borderColor = UIColor.red.cgColor
        arrowimage.layer.borderWidth = 0.5
        
        currenttbn.frame = CGRect(x: (childview.frame.size.width)/2.0-currenttbn.frame.size.width/2.0, y: currenttbn.frame.origin.y, width: currenttbn.frame.size.width, height: currenttbn.frame.size.height)
        
        arrowimage.frame = CGRect(x: currenttbn.frame.origin.x-12, y: arrowimage.frame.origin.y, width: arrowimage.frame.size.width, height: arrowimage.frame.size.height)
        
        
        profiletbl.tableHeaderView = headerview
        profiletbl.tableFooterView = footerview
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
                
                profilearray.removeAll()
        
        city = userInfo["city"] as! String
        state = userInfo["state"] as! String
        location = userInfo["Location"] as! String
        country = userInfo["country"] as! String
        
    
        var custom =  CustomStruct()
              custom.placeholderlabel  = "Full Name"
              custom.value = userInfo["Full_Name"] as! String
              custom.errormessage = "Please Enter Full Name"
              custom.paramter = "full_name"
              custom.imagename = "ic_profile_img"
              profilearray.append(custom)
        
        
        
                   custom =  CustomStruct()
                    custom.placeholderlabel  = "E-Mail Address"
                    custom.value = userInfo["Email"] as! String
                    custom.errormessage = "Please Enter E-Mail Address"
                    custom.emailvalidation = true
                    custom.paramter = "email"
                    custom.imagename = "ic_email"
                    profilearray.append(custom)
        
        custom =  CustomStruct()
                           custom.placeholderlabel  = "Mobile No"
                           custom.value = userInfo["Mobile"] as! String
                           custom.errormessage = "Please Enter Mobile No"
                           custom.paramter = "mobile"
                           custom.mobilevalidation = true
                           custom.keyboardtype = UIKeyboardType.phonePad.rawValue
                            custom.imagename = "ic_phone"
                           profilearray.append(custom)
        
        
                                  custom =  CustomStruct()
                                  custom.placeholderlabel  = "Location"
                                  custom.value = userInfo["Location"] as! String
                                  custom.errormessage = "Please Enter Location"
                                  custom.paramter = "location"
                              
                                  custom.keyboardtype = UIKeyboardType.phonePad.rawValue
                                   custom.imagename = "ic_globe"
                                  profilearray.append(custom)



              
                   profiletbl.reloadData()
        
        
    }
    
    @IBAction func back_action(sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func save_action(sender:UIButton)
       {
        if checkvalidation() {
            
            var parameters = [String:Any]()
                             
                             for custom in profilearray
                                {
                                    let value = custom.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                    parameters[custom.paramter] = value
                                }
            
            let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
            
            parameters["user_id"] = userInfo["User_id"]
            parameters["city"] = city
            parameters["state"] = state
            parameters["country"] = country
            parameters["location"] = location
            
           
                             
                             let baseurl = AppManager.baseurl + "edit_profile"
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
                                        self.makeuserDict(update: json["data"] as! [String : Any])
                                        
                                       //  AppManager.savetouserdefault(value: json["data"], key: "userInfo")
                                        self.navigationController?.popViewController(animated: true)
                                     }
                                     else
                                     {
                                         AppManager.showalert(json["error"] as! String , nil, self)
                                     }
                                 }
                                 
                                 
                             }
            
            
        }
        
       }
    
    func makeuserDict(update : [String:Any])
    {
        var updateduserinfo = [String:Any]()
        let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
         updateduserinfo = userInfo
        
        updateduserinfo["state"] = state
        updateduserinfo["city"] = city
        updateduserinfo["country"] = country
        updateduserinfo["Location"] = location
        updateduserinfo["Full_Name"] = update["full_name"]
        updateduserinfo["Email"] = update["email"]
        updateduserinfo["Mobile"] = update["Phone_Number"]
        
        AppManager.savetouserdefault(value:updateduserinfo, key: "userInfo")
        
    }

    @IBAction func current_location_action(sender:UIButton)
    {
        
        self.getaddress(block: { (placemark) -> (Void) in
            
            self.location = placemark.subLocality! + "," + placemark.locality!
            
            self.updatecell(placemark: placemark)
        }, LocationManager.sharedmanager.userlocation)
    
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
    
    func updatecell(placemark : CLPlacemark)
    {
          let editcell = profiletbl.cellForRow(at: IndexPath.init(row: 3, section: 0)) as? EditProfileTableViewCell
        
        if (editcell != nil)
                               {
                                editcell?.textfield.placeholder = ""
                                editcell?.textfield.text = placemark.subLocality! + "," + placemark.locality!
                               }
        self.country = placemark.country ?? ""
                        self.state = placemark.administrativeArea ?? ""
                        self.city = placemark.locality ?? ""
                        self.profilearray[3].value = placemark.subLocality! + "," + placemark.locality!
        
    }
    
    func getaddress(block: @escaping ((_ placemark : CLPlacemark)->(Void)), _ location:CLLocation)
 {
  
    LocationManager.sharedmanager.getaddress(location: location) { (placemark) -> (Void) in
        block(placemark!)
    }
    
    
    
 }
    
    func checkvalidation() -> Bool
    {
      for (_, custom) in profilearray.enumerated()
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
    
    func opengooglepicker()
    {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) )!.rawValue)!
        acController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        acController.autocompleteFilter = filter
        acController.modalPresentationStyle = .fullScreen
        self.present(acController, animated: true, completion: nil)
    }
    


}

extension EditProfileViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return profilearray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? EditProfileTableViewCell
        
        if cell == nil
        {
            cell = (Bundle.main.loadNibNamed("EditProfileTableViewCell", owner: self, options: nil)?.first as! EditProfileTableViewCell)
        }
     
        let custom =  profilearray[indexPath.row]
                
                cell!.textfield.isSecureTextEntry = custom.secure
        
        
        cell!.textfield.placeholder = ""
        if custom.value == ""
        {
            cell!.textfield.placeholder = custom.placeholderlabel
        }
        
        cell?.textfield.leftpadding = 30.0
        cell?.textfield.rightpadding = -1.0
        cell?.textfield.titleFadeInDuration = 0.0
        cell?.textfield.titleFadeOutDuration = 0.0
                cell!.textfield.text = custom.value
                
                cell?.textfield.delegate = self
                
                cell?.selectionStyle = .none
                
                cell?.textfield.tag = indexPath.row
                
                cell?.textfield.keyboardType = UIKeyboardType(rawValue: custom.keyboardtype)!
   
        
        cell?.iconimage?.image = UIImage(named: custom.imagename)
        cell?.selectionStyle = .none
        return cell!
    }
    
}

extension EditProfileViewController : UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField.tag == 3 {
            
            self.opengooglepicker()
            
            return false
        }

        return true
    }
    
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
                profilearray[row].value = globalstring
            }
            else
            {
                var appendstring = textField.text!
                let swiftrange = Range(range, in: appendstring)!
                appendstring =  appendstring.replacingCharacters(in: swiftrange, with: "")
                globalstring = appendstring
                profilearray[row].value = globalstring
            }
            
             let editcell = profiletbl.cellForRow(at: IndexPath.init(row: row, section: 0)) as! EditProfileTableViewCell
            editcell.textfield.placeholder = ""
            if globalstring == ""
            {
                editcell.textfield.placeholder = profilearray[row].placeholderlabel
            }
            
            
            return true
        }
}

extension EditProfileViewController : GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print(place.coordinate)
        
        let coll = CLLocation.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
     
        location = place.formattedAddress ?? ""
        
        self.getaddress(block: { (placemark) -> (Void) in
            self.updatecell(placemark: placemark)
        }, coll)
        
        print(place.name as Any)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    

    
}


