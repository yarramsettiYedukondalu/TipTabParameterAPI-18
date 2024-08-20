//
//  FoodGroupCVC.swift
//  TipTap
//
//  Created by Toqsoft on 27/10/23.
//

import UIKit

class FoodGroupCVC: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var badgeLabel: UILabel!
   
    @IBOutlet weak var foodGroupName: UILabel!
    @IBOutlet weak var foodgroupImg: UIImageView!
    override func awakeFromNib() {
          super.awakeFromNib()
          
          // Initialization code
          customizeCell()
        
        
        
      }
      
    
    
      func customizeCell() {
          
          backView.cellBackViewShadow()
          
          foodGroupName.applyLabelStyle(for: .descriptionSmallBlack)
      }
}
