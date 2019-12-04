//
//  ImageUploadVC.swift
//  Orinthology
//
//  Created by Eorchids on 31/10/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class ImageUploadVC: UIViewController {
    
    @IBOutlet weak var location_img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sos_clicked(_ sender: UIButton) {
    }
    @IBAction func nextbtn_pressed(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "SubmitComplaintVC") as! SubmitComplaintVC
        self.present(next, animated: true, completion: nil)
    }
    @IBAction func closebtn_clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func imag1_clicked(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CamerapickVC") as! CamerapickVC
        self.present(next, animated: true, completion: nil)
    }
    @IBAction func image2_clicked(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CamerapickVC") as! CamerapickVC
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func image3_clicked(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CamerapickVC") as! CamerapickVC
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func video1_clicked(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CamerapickVC") as! CamerapickVC
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func video2_clicked(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CamerapickVC") as! CamerapickVC
        self.present(next, animated: true, completion: nil)
    }
    @IBAction func video3_clicked(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CamerapickVC") as! CamerapickVC
        self.present(next, animated: true, completion: nil)
    }
    
}
