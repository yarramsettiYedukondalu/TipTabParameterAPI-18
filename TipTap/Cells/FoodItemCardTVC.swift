//
//  FoodItemCardTVC.swift
//  TipTap
//
//  Created by Toqsoft on 27/10/23.
//

import UIKit

class FoodItemCardTVC: UITableViewCell {

    @IBOutlet weak var foodItemCardCollectionview: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FoodItemCardTVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = foodItemCardCollectionview.dequeueReusableCell(withReuseIdentifier: "FoodItemCardCVC", for: indexPath) as! FoodItemCardCVC
        return itemCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width

    
        // Return the desired size for the cell at the specified indexPath
        return CGSize(width: screenWidth, height: 150)
    }
    
}
