//
//  LocationManager.swift
//  Orinthology
//
//  Created by Varun on 14/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
class LocationManager: NSObject,CLLocationManagerDelegate {

    static var sharedmanager = LocationManager()
    
    var locmanager = CLLocationManager()
    var geocoder = CLGeocoder()
    var userlocation = CLLocation()
    var userplacemark : CLPlacemark?
    var checkinside = false
    var placeblock : (()->(Void))?
    
    
    func getuserlocation()
    {
        locmanager.delegate = self
        locmanager.startUpdatingLocation()
        locmanager.requestWhenInUseAuthorization()
    }
    
  //  func location
    
    
//   #pragma mark Location
//
//   -(void)getuserlocation
//   {
//       self.locmanager =[[CLLocationManager alloc]init];
//       _locmanager.delegate = self;
//       [self.locmanager startUpdatingLocation];
//       [self.locmanager requestWhenInUseAuthorization];
//       self.geocoder = [[CLGeocoder alloc]init];
//       if (TARGET_OS_SIMULATOR)
//       {
//           _userlocation = [[CLLocation alloc]initWithLatitude:30.7009 longitude:76.6788];
//       }
//
//   }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch (status)
         {
        case .restricted: break
        case .denied: break
        default:
            do{
                locmanager.startUpdatingLocation()
            }
                 break;
         }
     }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userlocation = locations[0]
        
        if !checkinside {
         
            getaddress(location: userlocation) { (placemark) -> (Void) in
                       
                       if placemark != nil
                       {
                           self.checkinside = true
                           self.userplacemark = placemark
                        if self.placeblock != nil
                        {
                            self.placeblock!()
                        }
                         
                       }
                       else
                       {
                           
                       }
                   }
            
        }
       
        
    }
    
    
    func getaddress(location:CLLocation,block: @escaping ((_ placemark : CLPlacemark?)->(Void)))
    {
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
           
            if placemarks != nil
            {
               // let place = placemarks![0] as CLPlacemark
                block(placemarks![0])
            }
            else
            {
             block(nil)
            }
        }
        
        
        
    }
    
//    -(void)getaddress:(CLLocation*)location placemark:(void(^)(CLPlacemark * placemark))block
//    {
//        //CLLocation *location1 = [[CLLocation alloc]initWithLatitude:50.301628 longitude:-89.039611];
//
//
//
//
//        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
//        {
//            if (placemarks.count>0)
//            {
//                self->addresscheck = YES;
//                CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                block(placemark);
//            }
//            else
//            {
//                NSLog(@"bloll...%@",block);
//                block(nil);
//            }
//        }];
//    }
    
}
