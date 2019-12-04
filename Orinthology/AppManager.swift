//
//  AppManager.swift
//  Orinthology
//
//  Created by Varun on 11/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import AVFoundation


 struct CustomStruct
{
    var placeholderlabel  = ""
    var value = ""
    var secure  = false
    var errormessage = ""
    var emailvalidation = false
    var keyboardtype = 0
    var matchpassword = false
    var mobilevalidation = false
    var paramter = ""
    var imagename = ""
}

class AppManager: NSObject {

         static let baseurl = "http://e-orchids.com/phoenix/api/v1/Auth/"
    static let sharedmanager =  AppManager()
    var toppadding : CGFloat = 0.0
    var bottompadding :CGFloat = 0.0
   static var appdelegate =  UIApplication.shared.delegate as! AppDelegate
    
    
    func updatechildview(view:UIView,childview:UIView)
    {
        view.frame = CGRect(x:0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        let window = UIApplication.shared.keyWindow!
        toppadding = window.safeAreaInsets.top
        bottompadding = window.safeAreaInsets.bottom
        childview.frame = CGRect(x: 0, y: toppadding, width:view.frame.size.width, height: view.frame.size.height-toppadding-bottompadding)
    }
    
 //   -(void)showalert:(NSString*)title message:(nullable NSString*)message controller:(id)viscontroller
    
    
  static  func showalert(_ title:String,_ message:String? , _ controller : UIViewController)
    {
        let alertcontroller  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        controller.present(alertcontroller, animated: true, completion: nil)
    }
    
    static  func showalert(_ title:String,_ message:String? , _ controller : UIViewController , block : @escaping ()->(Void))
    {
        let alertcontroller  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            block()
        }))
        controller.present(alertcontroller, animated: true, completion: nil)
    }
    
    func postwebservice(url : String , param : [String:Any]! , block : @escaping ((_ responsedata : Data?,_ error:Error?)->(Void)))
    {
        let passurl = URL(string: url)!
        let jsondata = try! JSONSerialization.data(withJSONObject: param as [String:Any], options: .prettyPrinted)
        var mutablereq = URLRequest(url: passurl)
        mutablereq.httpMethod = "POST"
        mutablereq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutablereq.httpBody = jsondata
        let configuration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: configuration)
      let servicedata =   session.dataTask(with: mutablereq) { (responsedata, response, error) in
            DispatchQueue.main.async
            {
    
                block(responsedata,error)
            }
        }
        
        servicedata.resume()
    }
    
    func getwebservice( url : String , param : [String:Any]! , block : @escaping ((_ responsedata : Data?,_ error:Error?)->(Void)))
    {
        var paramarr = [String]()
        
        var newurl = url
        
        for (key,value) in param
        {
            let str = key  + "=" +  (value as! String)
            paramarr.append(str)
        }
        
        if paramarr.count>0
        {
            let appendurl =  paramarr.joined(separator: "&")
            newurl = url + "?" + appendurl
        }

        let passurl = URL(string: newurl)!
        let configuration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: configuration)
        let servicedata = session.dataTask(with: passurl) { (responsedata, response, error) in
            DispatchQueue.main.async
            {
                block(responsedata,error)
            }
        }
        servicedata.resume()
    }
    static func savetouserdefault(value : Any! , key : String )
    {
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
   static func getvaluefromkey(key: String) -> Any
    {
        let userDefault = UserDefaults.standard
        return userDefault.object(forKey: key) as Any
    }
    static func removeobjectforkey(key : String)
    {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }
    
    func addshadowoncorner (view:UIView,radius : CGFloat , fillcolor : UIColor)
    {
        self.removeshadow(view: view)
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath.init(roundedRect: view.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillcolor.cgColor;
        shadowLayer.shadowOffset = CGSize(width: 0 , height: 0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 2;
        view.layer.cornerRadius = radius;
        view.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func removeshadow(view:UIView)
    {
        
        if view.layer.sublayers != nil
        {
            for layers in view.layer.sublayers! {
                    
                    if layers is CAShapeLayer  {
                        
                        layers.removeFromSuperlayer()
                        break
                    }
                    
                }
        }
    
        
    }

    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async
                  {
                    completion(nil) //11
                }
            }
        }
    }
    
    
    
    


}

extension String
{
func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    return ceil(boundingBox.height)
}

}

extension AppManager
{
    
    
    func registercomplain(paramters:[String:Any],imagearray:[UIImage],videoarray:[URL] ,  block : @escaping ((_ responsedata : Data?,_ error:Error?)->(Void)))
    {
          let baseurl = AppManager.baseurl + "complaints_task"
          let url = URL(string: baseurl)!
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
        
          let contentType = "multipart/form-data; boundary=boundry"
          request.setValue(contentType, forHTTPHeaderField: "Content-Type")
           var body = Data()
        
        
        for (key,value) in paramters
        {
            body.append("--boundry\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
          
        for image in imagearray
        {
            var customimage = image.fixedOrientation()
            customimage = customimage!.resizeimage()
            let filedata = customimage!.jpegData(compressionQuality: 0.5)
            let str = "files[]"
            let filename = String(arc4random())
            body.append("--boundry\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(str)\"; filename=\"\(filename).jpeg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(filedata!)
            body.append("\r\n".data(using: .utf8)!)
          
        }
        
      
        
        for url in videoarray
        {
           let filedata = try! Data(contentsOf: url)
            let str = "files[]"
              let filename = String(arc4random())
            body.append("--boundry\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(str)\"; filename=\"\(filename).mp4\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(filedata)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        
        body.append("--boundry--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
        
        let configuration = URLSessionConfiguration.default
             let session = URLSession.init(configuration: configuration)
           let servicedata =   session.dataTask(with: request) { (responsedata, response, error) in
                 DispatchQueue.main.async
                 {
         
                     block(responsedata,error)
                 }
             }
             
             servicedata.resume()
         
    
    }
    

  
    
}

extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    func resizeimage() -> UIImage?
      {
          let imagewidth = self.size.width
          let imageheight = self.size.height
          let aspectratio = 640.0 as CGFloat
          var x : CGFloat = 0.0
          var y : CGFloat = 0.0
          var bytesperrow : size_t!
          
          if (imagewidth < aspectratio && imageheight < aspectratio)
                  {
                      return self;
                  }
          
          
                  if (imageheight>imagewidth)
                  {
                      x = (imagewidth/imageheight)*aspectratio;
                      y = aspectratio;
                  }
                  else
                  {
                      x = aspectratio;
                      y = (imageheight/imagewidth)*aspectratio;
                  }
          
          let width = Int(x) as size_t
          let height = Int(y) as size_t
          bytesperrow = 4 * width
          
                 let  colorSpace = CGColorSpaceCreateDeviceRGB()
          let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
          let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesperrow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

         
          context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
          
          
         let cgimage = context?.makeImage()
          
        return UIImage.init(cgImage: cgimage!)
          

      }
    
    
    
}

