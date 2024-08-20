//
//  VisitedCVC.swift
//  TipTap
//
//  Created by sriram on 15/11/23.
//

import UIKit

class VisitedCVC: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var promotedLabel: UILabel!
    @IBOutlet weak var ratingsView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var offerDisLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCellUI()
    }
    func setCellUI(){
        nameLabel.applyLabelStyle(for: .headingBlack)
        subNameLabel.applyLabelStyle(for: .subTitleLightGray)
        discriptionLabel.applyLabelStyle(for: .descriptionLightGray)
        offerDisLabel.applyLabelStyle(for: .descriptionLightGray)
        
        ratingLabel.applyLabelStyle(for: .OfferWhite)
        
        ratingsView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        ratingsView.layer.cornerRadius = 5
        ratingsView.layer.masksToBounds = false
        
        offerLabel.applyLabelStyle(for: .OfferWhite)
        offerLabel.clipsToBounds = true
        promotedLabel.applyLabelStyle(for: .promotedLabel)
        backView.cellBackViewShadow()
    }
}

    

