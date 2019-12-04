//
//  HomeViewController.swift
//  Orinthology
//
//  Created by Varun on 11/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import CoreLocation
class HomeViewController: UIViewController {

    @IBOutlet  var childview : UIView!
    var menuview : MenuView!
   @IBOutlet var headerview :  UIView!
   @IBOutlet var customtbl : UITableView!
    @IBOutlet var complainview : UIView!
    @IBOutlet var locationtxt :UITextField!
    @IBOutlet var organizationtxt : UITextField!
    @IBOutlet var sosbtn : UIButton!
    @IBOutlet var locationbtn:UIButton!
    @IBOutlet var namelbl : UILabel!
    var listview : ListOrganizationView!
    var org_id = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)

        menuview = (Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)?.first as! MenuView)
        menuview.frame = CGRect(x: 0, y: 0, width: childview.frame.size.width, height: childview.frame.size.height)
        menuview.menutbl.frame = CGRect(x: -(childview.frame.size.width-70), y: 0, width: childview.frame.size.width-70, height: childview.frame.size.height)
        menuview.isHidden = true
        customtbl.tableHeaderView = headerview
        customtbl.tableFooterView = UIView(frame: .zero)
        childview.addSubview(menuview)
        
        listview = (Bundle.main.loadNibNamed("ListOrganizationView", owner: self, options: nil)?.first as! ListOrganizationView)
        listview.frame = CGRect(x: 0, y: 0, width: childview.frame.size.width, height: childview.frame.size.height)
        listview.headerview.frame = CGRect(x: 0, y: 0, width: childview.frame.size.width, height: childview.frame.size.height)
        listview.parentcontroller = self
        listview.reloadViews()
    
        complainview.layer.masksToBounds = true;
        complainview.layer.cornerRadius = 15.0
        
        
        
        sosbtn.layer.masksToBounds = true;
        sosbtn.layer.cornerRadius = 10.0
        locationbtn.layer.masksToBounds = true;
        locationbtn.layer.cornerRadius = 10.0
        
        let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
        
        namelbl.text = "Hello " + (userInfo["Full_Name"] as! String) + ","
        
        listview.orgblock = { (org) in
            
            
            self.org_id = org.Organisation_id
            self.organizationtxt.text = org.Organisation_name
        }
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        menuview.parentcontroller = self
        menuview.selectedindex = 0
        
        if LocationManager.sharedmanager.userplacemark != nil
        {
            let place = LocationManager.sharedmanager.userplacemark!
            locationtxt.text = place.subLocality! + "," + place.locality!
        }
        LocationManager.sharedmanager.placeblock =
            {
            let place = LocationManager.sharedmanager.userplacemark!
                
               self.locationtxt.text = place.subLocality! + "," + place.locality!

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
    @IBAction func open_map(sender:UITapGestureRecognizer)
    {
        let mapview = MapViewController(nibName: "MapViewController", bundle: nil)
        mapview.modalPresentationStyle = .fullScreen
        self.present(mapview, animated: true, completion: nil)
    }
     
    @IBAction func add_new_complaint(sender:UIButton)
    {
        let loca = (locationtxt.text)!
        
        if loca.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == ""
        {
             AppManager.showalert("Complain Registration Failed", "Please provide location", self)
        }
        
       else if organizationtxt.text == ""
        {
              AppManager.showalert("Complain Registration Failed", "Choose organisation", self)
    
        }
        else
        {
          let addnew = AddNewComplaintViewController(nibName: "AddNewComplaintViewController", bundle: nil)
                  addnew.orgstr = org_id
                  addnew.locationstr = locationtxt.text
                  self.navigationController?.pushViewController(addnew, animated: true)
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
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController : UITextFieldDelegate

{
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == organizationtxt
        {
            
            locationtxt.resignFirstResponder()
            
            listview.loadorgnization { () -> (Void) in
                self.childview.addSubview(self.listview)
            }
            
     
            return false
        }
        return true
    }
}
