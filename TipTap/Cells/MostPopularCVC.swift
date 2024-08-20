//
//  MostPopularCVC.swift
//  TipTap
//
//  Created by Toqsoft on 30/10/23.
//

import UIKit

class MostPopularCVC: UICollectionViewCell {
    
}
class TwoByTwoFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = self.collectionView {
            let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
            let cellWidth = (availableWidth - minimumInteritemSpacing) / 2
            let cellHeight = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing) / 2
            
            itemSize = CGSize(width: cellWidth, height: cellHeight)
        }
    }
}
