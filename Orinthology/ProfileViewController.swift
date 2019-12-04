//
//  ProfileViewController.swift
//  Orinthology
//
//  Created by Varun on 20/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

fileprivate struct ResponseModel : Codable
{
    let status : Bool
    let data : CountModel?
    let error : String?
}

struct CountModel : Codable
{
    var Resolved_Complaints : String
    var Total_raise_complaints : String
}

struct ArrayModel
{
    var name : String!
    var imagename : String!
    
    
    init(name : String , imagename : String) {
        self.name = name
        self.imagename = imagename
    }
}

class ProfileViewController: UIViewController
{
    @IBOutlet  var childview : UIView!
    var menuview : MenuView!
    @IBOutlet var sosbtn : UIButton!
    @IBOutlet var locationbtn:UIButton!
    @IBOutlet var headerview : UIView!
    @IBOutlet var profileimage : UIImageView!
    @IBOutlet var profileview : UIView!
    @IBOutlet var profiletbl : UITableView!
    @IBOutlet var totalcomplaintslbl : UILabel! 
    @IBOutlet var resolvedlbl : UILabel!
    @IBOutlet var passwordbtn: UIButton!
    @IBOutlet var footerview : UIView!
     var profilearray = [ArrayModel]()
    
    
    
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
        
        
        profileview.layer.masksToBounds = true;
        profileview.layer.cornerRadius = profileview.frame.size.width/2.0
        profiletbl.tableHeaderView = headerview
        
        passwordbtn.layer.borderColor = UIColor.lightGray.cgColor
        passwordbtn.layer.borderWidth = 1.0
        
        profiletbl.tableFooterView = footerview
        
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool)
         {
             menuview.parentcontroller = self
             menuview.selectedindex = 2
             fetchcomplainscount()
            
             let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
             
         
            
            profilearray.removeAll()
            
            var model  = ArrayModel(name:userInfo["Full_Name"] as! String ,imagename:"ic_user")
            profilearray.append(model)
            
            model  = ArrayModel(name:userInfo["Email"] as! String ,imagename:"ic_email_grey")
            profilearray.append(model)
            
            model  = ArrayModel(name:userInfo["Mobile"] as! String ,imagename:"ic_phone_gray")
            profilearray.append(model)
            
            model  = ArrayModel(name:userInfo["city"] as! String ,imagename:"ic_location_grey")
            profilearray.append(model)
            
            model  = ArrayModel(name:userInfo["state"] as! String ,imagename:"ic_globe_grey")
            profilearray.append(model)
            
            model  = ArrayModel(name:userInfo["country"] as! String ,imagename:"ic_country")
            profilearray.append(model)
            
            profiletbl.reloadData()
            
         }

    func fetchcomplainscount()
    {
        
        
        var parameters = [String:Any]()
        let userInfo = AppManager.getvaluefromkey(key: "userInfo") as! [String:Any]
        parameters["user_id"] = userInfo["User_id"] as! String
       
               let baseurl = AppManager.baseurl + "total_complaints"
               
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
    
                     let responsemodel =   try! JSONDecoder().decode(ResponseModel.self, from: responsedata!)
                       
                    if responsemodel.status == true
                       {
                        self.totalcomplaintslbl.text = responsemodel.data?.Total_raise_complaints
                        self.resolvedlbl.text = responsemodel.data?.Resolved_Complaints
                       }
                       else
                       {
                        AppManager.showalert(responsemodel.error! , nil, self)
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
                    self.menuview.menutbl.frame = CGRect(x: 0, y: 0, width: self.menuview.menutbl.frame.size.width , height: self.menuview.menutbl.frame.size.height)
                }
            
        }
    
    @IBAction func change_password(sender:UIButton)
    {
        let change = PasswordChangeVC(nibName: "PasswordChangeVC", bundle: nil)
        self.navigationController?.pushViewController(change, animated: true)
        
    }
    
    @IBAction func edit_action(sender:UIButton)
    {
        let edit = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(edit, animated: true)
        
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

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profilearray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ProfileTableViewCell
        
        if cell == nil
        {
            cell = (Bundle.main.loadNibNamed("ProfileTableViewCell", owner: self, options: nil)?.first as! ProfileTableViewCell)
        }
        
        let model = profilearray[indexPath.row]
        
        cell?.namelbl.text = model.name
        cell?.iconimage?.image = UIImage(named: model.imagename)
    
        
        cell?.selectionStyle = .none
        
        cell?.namelbl.adjustsFontSizeToFitWidth = true
        return cell!
    }
    
}


