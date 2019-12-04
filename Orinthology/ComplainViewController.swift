//
//  ComplainViewController.swift
//  Orinthology
//
//  Created by Varun on 15/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

fileprivate struct ResponseModel : Codable
{
    let status : Bool
    let data : [ComplainModel]?
    let error : String?
}

struct ComplainModel : Codable
{
    var Comments  = ""
    var Complaint_Location = ""
    var Complaints_Number = ""
    var Date_Time = ""
    var Device = ""
    var Email_ID = ""
    var Images = ""
    var Ip_Address = ""
    var Organisation_Name = ""
    var Organisation_id = ""
    var Os_Type = ""
    var Phone_Number = ""
    var Status = ""
    var User_Id = ""
    var User_Location = ""
    var User_Name = ""
    var Video = ""
    var id = ""
}

import UIKit

class ComplainViewController: UIViewController {

    
    @IBOutlet  var childview : UIView!
       var menuview : MenuView!
       @IBOutlet var sosbtn : UIButton!
       @IBOutlet var locationbtn:UIButton!
    @IBOutlet var allbtn:UIButton!
    @IBOutlet var pendingbtn:UIButton!
    @IBOutlet var resolvedbtn:UIButton!
    @IBOutlet var complaintbl:UITableView!
    
    var mycomlainarr = [ComplainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
           menuview = (Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)?.first as! MenuView)
           
           menuview.frame = CGRect(x: 0, y: 0, width: childview.frame.size.width, height: childview.frame.size.height)
           menuview.menutbl.frame = CGRect(x: -(childview.frame.size.width-70), y: 0, width: childview.frame.size.width-70, height: childview.frame.size.height)
           
           menuview.isHidden = true
                      
           childview.addSubview(menuview)
           

           sosbtn.layer.masksToBounds = true;
           sosbtn.layer.cornerRadius = 10.0
           locationbtn.layer.masksToBounds = true;
           locationbtn.layer.cornerRadius = 10.0
        
        allbtn.layer.masksToBounds = true;
        allbtn.layer.cornerRadius = 10.0
        pendingbtn.layer.masksToBounds = true
        pendingbtn.layer.cornerRadius = 10.0
        resolvedbtn.layer.masksToBounds = true
        resolvedbtn.layer.cornerRadius = 10.0
        
        fetchcomplains("0")

        // Do any additional setup after loading the view.
    }
    
    func fetchcomplains(_ filter:String)
       {
        let baseurl = AppManager.baseurl + "list_user_complaints"
        
        var dict = [String:Any]()
        
         let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
        
        dict["user_id"] = userInfo["User_id"] as! String
        dict["filter"] = filter
        
        
        self.mycomlainarr.removeAll()
        self.complaintbl.reloadData()
        
        AppManager.appdelegate.showhud()
        
        AppManager.sharedmanager.getwebservice(url: baseurl, param: dict) { (responsedata, error) -> (Void) in
            
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
                      
                     let responsemodel =   try! JSONDecoder().decode(ResponseModel.self, from: responsedata!)

                    if responsemodel.status
                      {
                        for compmodel in responsemodel.data!
                        {
                            self.mycomlainarr.append(compmodel)
                        }
                        self.complaintbl.reloadData()
                      }
                      else
                      {
                        AppManager.showalert(responsemodel.error!  , nil, self)
                      }
                  }
       }
    
    }
    override func viewWillAppear(_ animated: Bool)
       {
           menuview.parentcontroller = self
        menuview.selectedindex = 1
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
    
    @IBAction func all_action(sender:UIButton)
    {
        if sender.tag == 0
        {
            allbtn.backgroundColor = UIColor.black
            allbtn.setTitleColor( .white, for: .normal)
            
            pendingbtn.backgroundColor = UIColor.groupTableViewBackground
            pendingbtn.setTitleColor( .lightGray, for: .normal)
            
            resolvedbtn.backgroundColor = UIColor.groupTableViewBackground
            resolvedbtn.setTitleColor( .lightGray, for: .normal)
            
            
          
        }
        else if sender.tag == 1
        {
            
            pendingbtn.backgroundColor = UIColor.black
                       pendingbtn.setTitleColor( .white, for: .normal)
                       
                       allbtn.backgroundColor = UIColor.groupTableViewBackground
                       allbtn.setTitleColor( .lightGray, for: .normal)
                       
                       resolvedbtn.backgroundColor = UIColor.groupTableViewBackground
                       resolvedbtn.setTitleColor( .lightGray, for: .normal)
            
            
        }
        else if sender.tag == 2
               {
                
                resolvedbtn.backgroundColor = UIColor.black
                           resolvedbtn.setTitleColor( .white, for: .normal)
                           
                           pendingbtn.backgroundColor = UIColor.groupTableViewBackground
                           pendingbtn.setTitleColor( .lightGray, for: .normal)
                           
                           allbtn.backgroundColor = UIColor.groupTableViewBackground
                           allbtn.setTitleColor( .lightGray, for: .normal)
                   
               }
          fetchcomplains(String(sender.tag))
    }
    @IBAction func add_new_complaint(sender:UIButton)
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

extension ComplainViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
          return mycomlainarr.count
          
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MyComplainTableViewCell
          
          if cell == nil
          {
              cell = (Bundle.main.loadNibNamed("MyComplainTableViewCell", owner: self, options: nil)?.first as! MyComplainTableViewCell)
          }
           let complain = mycomlainarr[indexPath.row]
        
             let width = tableView.frame.size.width - 45
             var height = complain.Comments.height(withConstrainedWidth: width, font: UIFont(name: "RobotoSlab-Regular", size: 15.0)!)
             if height<25
             {
                 height = 25
             }
           

        cell?.topview.frame = CGRect(x: 5, y: 5, width:childview.frame.size.width-10, height: 75 + height + 15)
        
    
        cell?.idlbl.text = complain.Complaints_Number
        cell?.againstlbl.text = complain.Organisation_Name
        cell?.datelbl.text = complain.Date_Time
        
        if complain.Status == "Completed"
        {
            cell?.statuslbl.text = "Resolved"
            cell?.statuslbl.textColor = UIColor(red: 0, green: 200.0/255.0, blue: 0, alpha: 1.0)
            cell?.statuslbl.backgroundColor = UIColor.init(red: 0, green: 200.0/255.0, blue: 0, alpha: 0.3)
        }
        else
        {
          cell?.statuslbl.text = "Pending"
          cell?.statuslbl.textColor = UIColor.red
          cell?.statuslbl.backgroundColor = UIColor.init(red: 200.0/255.0, green: 0, blue: 0, alpha: 0.3)
        }
        cell?.selectionStyle = .none
        cell?.commentview.frame = CGRect(x:10, y: 70 , width:(cell?.topview.frame.size.width)!-20, height:height+10)
        cell?.commentlbl.frame = CGRect(x:5, y: 5 , width:(cell?.commentview.frame.size.width)!-10, height:height)
        cell?.commentlbl.numberOfLines = 0
        cell?.commentlbl.text = complain.Comments
        cell?.statuslbl.layer.masksToBounds = true
        cell?.statuslbl.layer.cornerRadius = 10
        AppManager.sharedmanager.addshadowoncorner(view: cell!.topview, radius: 5.0, fillcolor: UIColor.white)
          return cell!
      }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let complain = mycomlainarr[indexPath.row]
        let width = tableView.frame.size.width - 45
        var height = complain.Comments.height(withConstrainedWidth: width, font: UIFont(name: "RobotoSlab-Regular", size: 15.0)!)
        if height<25
        {
            height = 25
        }
        height = 5 + 70 + 5 + height + 5 + 10 + 5
        
        return height;
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
      {
          let details = ComplainDetailViewController(nibName: "ComplainDetailViewController", bundle: nil)
          details.detailcomplainmodel = mycomlainarr[indexPath.row]
          self.navigationController?.pushViewController(details, animated: true)
      }
    
}

