//
//  complaintlistTVC.swift
//  Orinthology
//
//  Created by Eorchids on 01/11/19.
//  Copyright © 2019 HexagonItSolutions. All rights reserved.
//

import UIKit

class complaintlistTVC: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
   var imageArray = [String] ()
    @IBOutlet weak var collectionview: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        imageArray = ["image_temp2","image_temp1copy","image_temp2","image_temp1copy"]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "complaintslistCVC", for: indexPath) as! complaintslistCVC
    
    let randomNumber = Int(arc4random_uniform(UInt32(imageArray.count)))
    cellA.imageview.image = UIImage(named: imageArray[randomNumber])
    return cellA
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    let size = CGSize(width: 120, height: 120)
    return size
    }
}
