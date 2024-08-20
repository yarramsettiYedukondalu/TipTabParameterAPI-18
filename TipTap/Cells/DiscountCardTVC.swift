//
//  DiscountCardTVC.swift
//  TipTap
//
//  Created by Toqsoft on 30/10/23.
//

import UIKit

class DiscountCardTVC: UITableViewCell {

   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
}
//extension DiscountCardTVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let discountCardCell = discountCardCV.dequeueReusableCell(withReuseIdentifier: "DiscountCardCVC", for: indexPath)as! DiscountCardCVC
//        return discountCardCell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      
//        return CGSize(width: 100, height: 120)
//    }
//}
