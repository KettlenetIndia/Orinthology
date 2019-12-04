//
//  MapViewController.swift
//  Orinthology
//
//  Created by Varun on 14/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController,GMSMapViewDelegate {

    
    @IBOutlet  var childview : UIView!
    @IBOutlet  var mapView : GMSMapView!
    @IBOutlet var locationlbl :  UILabel!
    @IBOutlet var markerimage :  UIImageView!
    var camera : GMSCameraPosition!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         AppManager.sharedmanager.updatechildview(view: self.view, childview: childview)
         mapView.isMyLocationEnabled = true
    
    }
    override func viewDidAppear(_ animated: Bool)
    {
        let location = LocationManager.sharedmanager.userlocation
        camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18.0)
        mapView.camera = camera
        mapView.delegate = self
        markerimage.frame = CGRect(x: mapView.frame.size.width/2-markerimage.frame.size.width/2, y:(mapView.frame.origin.y+(mapView.frame.size.height/2)-markerimage.frame.size.height), width: markerimage.frame.size.width, height: markerimage.frame.size.height)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if LocationManager.sharedmanager.userplacemark != nil
              {
                  let place = LocationManager.sharedmanager.userplacemark!
                  locationlbl.text = place.subLocality! + "," + place.locality!
              }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
   
        
        let x = mapView.frame.size.width/2-markerimage.frame.size.width/2;
        let y = (mapView.frame.origin.y+(mapView.frame.size.height/2)-markerimage.frame.size.height)
        let coordinate =    mapView.projection.coordinate(for: CGPoint(x: x, y: y))
        
        let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        LocationManager.sharedmanager.getaddress(location: location) { (placemark) -> (Void) in
            

       LocationManager.sharedmanager.userplacemark = placemark!
       self.locationlbl.text = placemark!.subLocality! + "," + placemark!.locality!
            
           

        }
    
    }
    
    
    @IBAction func  back_action(sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil);
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
