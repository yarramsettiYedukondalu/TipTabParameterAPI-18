//
//  DiscountCardCVC.swift
//  TipTap
//
//  Created by Toqsoft on 30/10/23.
//

import UIKit

class DiscountCardCVC: UICollectionViewCell {
    
    @IBOutlet weak var restaurantNameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountTypeView: UIView!
    @IBOutlet weak var offerNameView: UIView!
    @IBOutlet weak var offerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
        discountTypeView.layer.cornerRadius = 12.5
        discountTypeView.clipsToBounds = true
       
    }
    func  setCellUI(){
        
        backView.cellBackViewShadow()
    }
}
