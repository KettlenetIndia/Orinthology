//
//  DescribeComplainViewController.swift
//  Orinthology
//
//  Created by Varun on 28/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit



import RYFloatingInput
import SkyFloatingLabelTextField
import TKFormTextField


enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
   
}

class DescribeComplainViewController: UIViewController {

     @IBOutlet  var childview : UIView!
    @IBOutlet var sosbtn : UIButton!
     @IBOutlet var locationbtn:UIButton!
    @IBOutlet var complaintbl:UITableView!
    @IBOutlet var headerview : UIView!
    @IBOutlet var commentxt : UITextView!
    @IBOutlet var whatsapptxt : SkyFloatingLabelTextField!
    @IBOutlet var emailtxt : SkyFloatingLabelTextField!
    @IBOutlet var checkbtn : UIButton!
    @IBOutlet var complainidlbl : UILabel!
    @IBOutlet var successview : UIView!
    
    var imagearray : [UIImage]!
    var videoarray : [URL]!
    
    var userlocation = ""
    var locationstr : String!
    var orgstr : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
        sosbtn.layer.masksToBounds = true;
        sosbtn.layer.cornerRadius = 10.0
        locationbtn.layer.masksToBounds = true;
        locationbtn.layer.cornerRadius = 10.0
        
        complaintbl.tableHeaderView = headerview
        
        complaintbl.tableFooterView = UIView(frame: .zero)
        
        
        LocationManager.sharedmanager.getaddress(location: LocationManager.sharedmanager.userlocation) { (placemark) -> (Void) in
            
            if placemark != nil
            {
                self.userlocation = placemark!.subLocality! + "," + placemark!.locality!
            }
            
        }
        
        successview.frame = CGRect(x: 0, y: 0, width: childview.frame.size.width, height: childview.frame.size.height)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_clicked(_ sender: UIButton)
       {
         self.navigationController?.popViewController(animated: true)
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
    
     
    @IBAction func anonymous_action(_:UIButton)
    {
        if checkbtn.tag == 1
        {
            checkbtn.setImage(UIImage(named: "checked"), for: .normal)
            checkbtn.tag = 2
        }
        else
        {
             checkbtn.setImage(UIImage(named: "unckecked"), for: .normal)
            checkbtn.tag = 1
        }
        
    }
    @IBAction func add_new_action(_:UIButton)
    {
        for controller in (self.navigationController!.viewControllers)
                       {
                           if controller is HomeViewController
                           {
                               self.navigationController?.popToViewController(controller, animated: false)
                               return
                           }
                       }
        
        
    }
    @IBAction func my_action(_:UIButton)
    {
        
    for controller in (self.navigationController!.viewControllers)
                                                                   {
                                                                       if controller is ComplainViewController
                                                                       {
                    self.navigationController?.popToViewController(controller, animated: false)
                                                                           return
                                                                       }
                                                                   }
                                      
                                      
                                   let complain = ComplainViewController(nibName: "ComplainViewController", bundle: nil)
                                   self.navigationController?.pushViewController(complain, animated: false)
        
        
    }
    
    
    @IBAction func submit_action(_ sender: UIButton)
          {
            
             let wifiIp = getAddress(for: .wifi)

             let cellularIp = getAddress(for: .cellular)


            var ip_address = ""
            
            if wifiIp != nil
            {
                ip_address = wifiIp ?? ""
            }
            else if cellularIp != nil
            {
                ip_address = cellularIp ?? ""
            }
            
            let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
            var param = [String:Any]()
            param["user_id"] = userInfo["User_id"] as! String
            param["complaint_location"] = locationstr
            param["user_location"] = userlocation
            param["organisation_id"] = orgstr
            param["whatsapp_number"] = whatsapptxt.text
            param["email"] = emailtxt.text
            param["anonymous"] = checkbtn.tag == 2 ? "1" : "2"
            param["comments"] = commentxt.text
            param["ip_address"] = ip_address
            param["device"] = "iphone"
            param["os_type"] = "2"
            
             AppManager.appdelegate.showhud()
            
            AppManager.sharedmanager.registercomplain(paramters: param, imagearray: imagearray, videoarray : videoarray , block : { responsedata,error in
                
                
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
                    let data = json["data"] as! [String:Any]
                    self.complainidlbl.text = (data["Complaint_Number"] as! String)
                    self.childview.addSubview(self.successview)
                }
                else
                {
                      AppManager.showalert(json["error"] as! String , nil, self)
                }
                }
                })
          }
    
    func getAddress(for network: Network) -> String? {
        var address: String?

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
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
