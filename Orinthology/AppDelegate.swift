//
//  AppDelegate.swift
//  Orinthology
//
//  Created by Eorchids on 23/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
var window: UIWindow?
var navigation : UINavigationController!
    var loaderview : UIView!
    var activity : UIActivityIndicatorView!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        

        
        GMSServices.provideAPIKey("")
        GMSPlacesClient.provideAPIKey("")
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        
           let userInfo = AppManager.getvaluefromkey(key: "userInfo") as? [String:Any]
        
        if userInfo != nil
        {
            let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
            navigation = UINavigationController.init(rootViewController: home)
        }
        else
        {
            let signin = SignInVC(nibName: "SignInVC", bundle: nil)
            navigation = UINavigationController.init(rootViewController: signin)
        }
        
        self.window?.rootViewController = navigation
        navigation.setNavigationBarHidden(true, animated: false)
        self.window?.makeKeyAndVisible()
        LocationManager.sharedmanager.getuserlocation()
        loaderview = UIView(frame:  CGRect(x:(self.window?.frame.size.width)!/2-70/2, y: (self.window?.frame.size.height)!/2-70/2, width: 70, height: 70))
        loaderview.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        loaderview.layer.masksToBounds = true
        loaderview.layer.cornerRadius = 5.0
        
        activity = UIActivityIndicatorView()
        activity.style = .whiteLarge
        activity.frame = CGRect(x: loaderview.frame.size.width/2-activity.frame.size.width/2, y: loaderview.frame.size.height/2-activity.frame.size.height/2, width: activity.frame.size.width, height: activity.frame.size.height)
        loaderview.addSubview(activity)
      
        // Override point for customization after application launch.
        return true
    }

    
    func showhud()
    {
         activity.startAnimating()
         self.window?.addSubview(loaderview)
    }
    func hidehud()
    {
         activity.stopAnimating()
        loaderview.removeFromSuperview()
    }
   

    // MARK: - Core Data stack

    @available(iOS 13.0, *)
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Orinthology")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 13.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

