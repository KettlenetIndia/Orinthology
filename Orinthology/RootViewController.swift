//
//  RootViewController.swift
//  Orinthology
//
//  Created by Eorchids on 25/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         
        if (userDefaults.string(forKey: getLoginStatus) != nil)
        {
            if (userDefaults.string(forKey: getLoginStatus) == "true")
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.present(next, animated: true, completion: nil)
            }else{
                let next = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                self.present(next, animated: true, completion: nil)
            }
        }else{
         let next = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
          self.present(next, animated: true, completion: nil)
        }
        
    }

}
