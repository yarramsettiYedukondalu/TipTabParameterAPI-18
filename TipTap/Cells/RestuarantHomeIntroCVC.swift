//
//  RestuarantHomeIntroCVC.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//

import UIKit
 
class RestuarantHomeIntroCVC: UICollectionViewCell {
    @IBOutlet weak var foodImage: UIImageView!
 
    override func layoutSubviews() {
          super.layoutSubviews()
        
        
          // Set up the shadow properties
          layer.backgroundColor = UIColor.white.cgColor
          layer.cornerRadius = 5 // You can adjust this value as needed
          layer.borderWidth = 2
          layer.borderColor = UIColor.clear.cgColor
          layer.shadowColor = UIColor.darkGray.cgColor
          layer.shadowOffset = CGSize(width: 2, height: 2)
          layer.shadowRadius = 3
          layer.shadowOpacity = 0.5
          layer.masksToBounds = false
          layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
      }
}
