//
//  AddNewComplaintViewController.swift
//  Orinthology
//
//  Created by Varun on 20/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import BFRImageViewer
import AVKit
import AVFoundation



class AddNewComplaintViewController: UIViewController {

    @IBOutlet  var childview : UIView!
     
    @IBOutlet var sosbtn : UIButton!
    @IBOutlet var locationbtn:UIButton!
    
    @IBOutlet var footerview:UIView!
    
    
    @IBOutlet var imagecomplaintcoll : UICollectionView!
    @IBOutlet var videocomplaintcoll : UICollectionView!
    var locationstr : String!
    var orgstr : String!
    
    var imagearray = [UIImage]()
    var videoarray = [URL]()
    
    override func viewDidLoad()
    {
           super.viewDidLoad()
           AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
           sosbtn.layer.masksToBounds = true;
           sosbtn.layer.cornerRadius = 10.0
           locationbtn.layer.masksToBounds = true;
           locationbtn.layer.cornerRadius = 10.0
        
        imagecomplaintcoll.register(UINib.init(nibName: "AddNewComplainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        videocomplaintcoll.register(UINib.init(nibName: "AddNewComplainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        
        
        let status = PHPhotoLibrary.authorizationStatus()

        if status == .notDetermined  {
            PHPhotoLibrary.requestAuthorization({status in

            })
            
        }
        
    }
    
    func showimagepicker()
    {
        let imagepciker = UIImagePickerController()
        imagepciker.mediaTypes = [kUTTypeImage as String]
        imagepciker.allowsEditing = true
          imagepciker.delegate = self
        let controller = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction.init(title: "Take a Photo", style: .default, handler: { (action) in
            imagepciker.sourceType = .camera
            self.present(imagepciker, animated: true, completion: nil)
        }))
        controller.addAction(UIAlertAction.init(title: "From Camera Roll", style: .default, handler: { (action) in
              imagepciker.sourceType = .photoLibrary
               self.present(imagepciker, animated: true, completion: nil)
              }))
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                         
                     }))
        let popover = controller.popoverPresentationController
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x:self.view.center.x, y:self.view.center.y, width : 0, height :0)
        popover?.permittedArrowDirections = .up;
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func showvideopicker()
    {
        let imagepciker = UIImagePickerController()
              imagepciker.mediaTypes = [kUTTypeMovie as String]
              imagepciker.allowsEditing = true
        imagepciker.videoMaximumDuration = 120
        imagepciker.delegate = self
        
        let controller = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction.init(title: "Take a Video", style: .default, handler: { (action) in
            
            imagepciker.sourceType = .camera
             self.present(imagepciker, animated: true, completion: nil)
            
        }))
        controller.addAction(UIAlertAction.init(title: "From Camera Roll", style: .default, handler: { (action) in
                  imagepciker.sourceType = .photoLibrary
             self.present(imagepciker, animated: true, completion: nil)
              }))
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                         
                     }))
        let popover = controller.popoverPresentationController
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x:self.view.center.x, y:self.view.center.y, width : 0, height :0)
        popover?.permittedArrowDirections = .up;
        self.present(controller, animated: true, completion: nil)
    }
    

    @IBAction func back_clicked(_ sender: UIButton)
    {
      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func next_action(sender:UIButton)
    {
        if imagearray.count==0 && videoarray.count==0
        {
            AppManager.showalert("Please choose at least one video or image", nil, self)
            
            return
        }
        else
        {
            let describe = DescribeComplainViewController(nibName: "DescribeComplainViewController", bundle: nil)
           
            describe.imagearray = imagearray
            describe.videoarray = videoarray
            describe.orgstr = orgstr
            describe.locationstr = locationstr
            
            self.navigationController?.pushViewController(describe, animated: true)
            
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
    
    func compressVideo(_ inputURL : URL ,_ outputURL : URL , completion : @escaping ((_ session: AVAssetExportSession , _ videourl : URL ) -> (Void)) )
    
    {
let urlAsset = AVURLAsset(url: inputURL)
let exportsession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)
        exportsession?.outputURL = outputURL
        exportsession?.outputFileType = .mp4
        exportsession?.shouldOptimizeForNetworkUse = true
        exportsession?.exportAsynchronously {
            completion(exportsession!,outputURL)
        }
        
        let alertcontroller = UIAlertController.init(title: "Compressing Video", message: nil, preferredStyle: .alert)
        
        let heightconn = NSLayoutConstraint.init(item: alertcontroller.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100) as NSLayoutConstraint
        
        alertcontroller.view.addConstraint(heightconn)
        
        self.present(alertcontroller, animated: true) {
            
            let progress = UIProgressView(frame: CGRect(x: 8, y: 72, width: alertcontroller.view.frame.size.width-16, height: 2.0))
            alertcontroller.view.addSubview(progress)
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
                
                progress.progress = exportsession!.progress;
                               if (exportsession!.progress>=0.99)
                           {
                               alertcontroller.dismiss(animated: true, completion: nil)
                               timer.invalidate()
                           }
                
            }
            
              
        }
        
    }
  
    func deletefile(appendstr:String)
    {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var docsDir = dirPaths.first!
        docsDir =  docsDir + "/"  + appendstr
        let tmpFileUrl = URL(fileURLWithPath: docsDir)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: tmpFileUrl.path)
        {
          try! fileManager.removeItem(atPath: tmpFileUrl.path)
        }
    }
    
}

extension AddNewComplaintViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == imagecomplaintcoll
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! AddNewComplainCollectionViewCell
            cell.typelbl.text = "Image"
            cell.maximage.image = UIImage(named: "ic_plus")
            cell.crossbtn.layer.masksToBounds = true
            cell.crossbtn.layer.cornerRadius = cell.crossbtn.frame.size.width/2.0
        
            cell.mediaview.isHidden = true
            if imagearray.count>indexPath.row
            {
                cell.topimage.image = imagearray[indexPath.row]
                cell.mediaview.isHidden = false
            }
            
            cell.crossbtn.addTarget(self, action:#selector(image_cross(sender:)), for: .touchUpInside)
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! AddNewComplainCollectionViewCell
            cell.typelbl.text = "Video"
            cell.crossbtn.layer.masksToBounds = true
            cell.crossbtn.layer.cornerRadius = cell.crossbtn.frame.size.width/2.0
            
            cell.mediaview.isHidden = true
                       if videoarray.count>indexPath.row
                       {
                        
                        AppManager.sharedmanager.getThumbnailImageFromVideoUrl(url: videoarray[indexPath.row]) { (image) in
                                                     
                                                     
                                                        cell.topimage.image = image
                                                     
                                                 }
                        
                        
                        cell.mediaview.isHidden = false
                       }
            
            cell.crossbtn.addTarget(self, action: #selector(video_cross(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == imagecomplaintcoll
        {
            if imagearray.count>indexPath.row
            {
                
                let image = imagearray[indexPath.row]
                
                let bfr = BFRImageViewController(imageSource: [image])!
                                   
                                   bfr.modalPresentationStyle = .fullScreen
                                   
                                   self.present(bfr, animated: true, completion: nil)
                
            }
            else
            {
                   self.showimagepicker()
            }
        }
        else
        {
            if videoarray.count>indexPath.row
            {
                  let videoURL = videoarray[indexPath.row]
                  let player = AVPlayer(url: videoURL)
                  let playerViewController = AVPlayerViewController()
                  playerViewController.player = player
                  self.present(playerViewController, animated: true)
                  {
                      playerViewController.player!.play()
                  }
            }
            else
            {
                 self.showvideopicker()
            }
            
           
        }
    }
    
    @objc func video_cross(sender:UIButton)
    {
        let url = videoarray[sender.tag]
        let strpath = url.lastPathComponent
        deletefile(appendstr: strpath)
        videoarray.remove(at: sender.tag)
        videocomplaintcoll.reloadData()
    }
    
    @objc func image_cross(sender:UIButton)
       {
        imagearray.remove(at: sender.tag)
        imagecomplaintcoll.reloadData()
       }
    
    
}




extension AddNewComplaintViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
     //   NSString *mediatype = [info valueForKey:UIImagePickerControllerMediaType];

        let mediatype = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        if mediatype  == kUTTypeImage as String
        {
          let editedImage = info[UIImagePickerController.InfoKey.editedImage]
            
            imagearray.append(editedImage as! UIImage)
            
             imagecomplaintcoll.reloadData()
            
              picker.dismiss(animated: true, completion: nil)
            
        }
        else
        {
//                    if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
//                    {
//                        let assetResources = PHAssetResource.assetResources(for: asset)
//
//
//
//                        print(assetResources.first!.originalFilename)
//                    }
//            else if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL]
//                       {
//
//
//
//                       }
            
            
            picker.dismiss(animated: true, completion:  {
                
                let mediaURL = info[UIImagePickerController.InfoKey.mediaURL]
                         
                         var  appendstr  = String(arc4random())
                         appendstr = appendstr + ".mp4"
                self.deletefile(appendstr: appendstr)
                         let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                         var docsDir = dirPaths.first!
                         docsDir =  docsDir + "/"  + appendstr
                         
                self.compressVideo(mediaURL as! URL, URL(fileURLWithPath: docsDir)) { (session, output) -> (Void) in
                             
                             
                             if Thread.isMainThread
                             {
                                 self.videoarray.append(output)
                                 
                                 self.videocomplaintcoll.reloadData()
                             }
                             else
                             {
                                 DispatchQueue.main.sync {
                                     
                                     self.videoarray.append(output)
                                                       
                                                       self.videocomplaintcoll.reloadData()
                                     
                                 }
                             }

                             
                             
                         }
                
                
            })
            
            
            
            
         
            
                      
        }
  
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}
