//
//  ComplainDetailViewController.swift
//  Orinthology
//
//  Created by Varun on 28/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit
import BFRImageViewer

class ComplainDetailViewController: UIViewController
{
    @IBOutlet  var childview : UIView!
    @IBOutlet  var detailscomplaintbl : UITableView!
    @IBOutlet var sosbtn : UIButton!
    @IBOutlet var locationbtn:UIButton!
    var detailcomplainmodel : ComplainModel!
    @IBOutlet var idlbl : UILabel!
    @IBOutlet var againstlbl: UILabel!
    @IBOutlet  var datelbl : UILabel!
    @IBOutlet  var statuslbl : UILabel!
    @IBOutlet var headerview: UIView!
    @IBOutlet var footerview: UIView!
    @IBOutlet var commentview: UIView!
    @IBOutlet var commentlbl: UILabel!
    @IBOutlet var linelbl: UILabel!
    @IBOutlet var imagecomplaintcoll : UICollectionView!
    @IBOutlet var videocomplaintcoll : UICollectionView!
    var imagearray : [String]!
    var videoarray : [String]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
            sosbtn.layer.masksToBounds = true;
            sosbtn.layer.cornerRadius = 10.0
            locationbtn.layer.masksToBounds = true;
            locationbtn.layer.cornerRadius = 10.0
        
        imagecomplaintcoll.register(UINib.init(nibName: "ComplainDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
              
        videocomplaintcoll.register(UINib.init(nibName: "ComplainDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        
        if detailcomplainmodel.Status == "Completed"
              {
                  statuslbl.text = "Resolved"
                  statuslbl.textColor = UIColor(red: 0, green: 200.0/255.0, blue: 0, alpha: 1.0)
                  statuslbl.backgroundColor = UIColor.init(red: 0, green: 200.0/255.0, blue: 0, alpha: 0.3)
              }
              else
              {
                statuslbl.text = "Pending"
                statuslbl.textColor = UIColor.red
                statuslbl.backgroundColor = UIColor.init(red: 200.0/255.0, green: 0, blue: 0, alpha: 0.3)
              }
        
        idlbl.text = "ID: " + detailcomplainmodel.Complaints_Number
        againstlbl.text = "Against: " + detailcomplainmodel.Organisation_Name
        datelbl.text = detailcomplainmodel.Date_Time
        statuslbl.layer.masksToBounds = true
        statuslbl.layer.cornerRadius = 10
        
      
        
        let width = childview.frame.size.width - 20
        
        var height = detailcomplainmodel.Comments.height(withConstrainedWidth: width, font: UIFont(name: "RobotoSlab-Regular", size: 15.0)!)
        
        if height<30
        {
            height = 30
        }
      
        commentview.frame = CGRect(x:10, y:420, width:width, height:25+height+5)
        commentlbl.frame = CGRect(x: 0, y: 25, width: width, height: height)
        linelbl.frame = CGRect(x: 0, y: 25+height+1, width: width, height: 1)
        
        commentlbl.numberOfLines = 0
        commentlbl.text = detailcomplainmodel.Comments
        
        
        headerview.frame = CGRect(x:0, y: 0, width:childview.frame.size.width, height: commentview.frame.origin.y+commentview.frame.size.height+20)
        
        
        imagearray = detailcomplainmodel.Images.components(separatedBy: ",")
        videoarray = detailcomplainmodel.Video.components(separatedBy: ",")
        
        detailscomplaintbl.tableHeaderView = headerview
        detailscomplaintbl.tableFooterView = footerview
        
    }

    @IBAction func back_action(sender : UIButton)
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
    

        
      
        
        
        
        
        
    

    
 

}

extension ComplainDetailViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == imagecomplaintcoll
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ComplainDetailCollectionViewCell
            
            cell.maximage.image = UIImage(named: "ic_plus")
            
            cell.topview.isHidden = true
            
            if imagearray.count>indexPath.row
            {
                let str = imagearray[indexPath.row]
                                       
                                       if str != ""
                {
                                           cell.topimage.sd_setImage(with: URL(string:imagearray[indexPath.row])!, completed: nil)
                                           cell.topview.isHidden = false
                }
                
            }
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! ComplainDetailCollectionViewCell
            
            cell.topview.isHidden = true
                      
                      if videoarray.count>indexPath.row
                      {
                        let str = videoarray[indexPath.row]
                        
                        if str != ""
                        {
                            
                            AppManager.sharedmanager.getThumbnailImageFromVideoUrl(url: URL(string:videoarray[indexPath.row])!) { (image) in
                                
                                
                                   cell.topimage.image = image
                                
                            }
                 
                                                  
                                                 
                                                  
                            cell.topview.isHidden = false
                            
                        }
                        
                        
                      
                      }
                      
     
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
     
        if collectionView == imagecomplaintcoll
        {
            
            if imagearray.count>indexPath.row
            {
                         let str = imagearray[indexPath.row]
                
            let image =     SDImageCache.shared.imageFromDiskCache(forKey: str)
                
               
                
                if image != nil
                {
                    let bfr = BFRImageViewController(imageSource: [image!])!
                    
                    bfr.modalPresentationStyle = .fullScreen
                    
                    self.present(bfr, animated: true, completion: nil)
                }
                else
                {
                    let bfr = BFRImageViewController(imageSource: [str])!
                                    
                    bfr.modalPresentationStyle = .fullScreen
                                    
                    self.present(bfr, animated: true, completion: nil)
                    
                }
                

            }
            
           
            
            
        }
        else
        {
            if videoarray.count>indexPath.row
            {
              let str = videoarray[indexPath.row]
              
              if str != ""
              {
                let videoURL = URL(string: str)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true)
                {
                    playerViewController.player!.play()
                }
                
                
            }
            }
            
        }
        
    }
    
    
}

