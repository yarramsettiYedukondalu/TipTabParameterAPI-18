//
//  FoodGroupTVC.swift
//  TipTap
//
//  Created by Toqsoft on 27/10/23.
//

import UIKit

class FoodGroupTVC: UITableViewCell {

    @IBOutlet weak var FoodGroupCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FoodGroupTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let foodgrpCVC = FoodGroupCollectionView.dequeueReusableCell(withReuseIdentifier: "FoodGroupCVC", for: indexPath) as! FoodGroupCVC
        // Customize the cell's appearance
        foodgrpCVC.foodGrupView.layer.cornerRadius = 8
        foodgrpCVC.foodGrupView.layer.shadowColor = UIColor.black.cgColor
        foodgrpCVC.foodGrupView.layer.shadowOffset = CGSize(width: 2, height: 3)
        foodgrpCVC.foodGrupView.layer.shadowRadius = 5
        foodgrpCVC.foodGrupView.layer.shadowOpacity = 0.8
        foodgrpCVC.foodGrupView.layer.masksToBounds = false
        return foodgrpCVC
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the desired size for the cell at the specified indexPath
        return CGSize(width: 100, height: 120)
    }

    
}
