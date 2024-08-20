//
//  MostPopularTVC.swift
//  TipTap
//
//  Created by Toqsoft on 30/10/23.
//

import UIKit

class MostPopularTVC: UITableViewCell {

    @IBOutlet weak var popularCV: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Create and set the custom layout
               let layout = TwoByTwoFlowLayout()
        popularCV.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MostPopularTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let popularCVC  = popularCV.dequeueReusableCell(withReuseIdentifier: "MostPopularCVC", for: indexPath) as! MostPopularCVC
      
        return popularCVC
    }
   
    
}

