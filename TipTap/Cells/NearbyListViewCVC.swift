//
//  NearbyListViewCVC.swift
//  TipTap
//
//  Created by Toqsoft on 09/11/23.
//
//
//  ListViewCollectionViewCell.swift
//  TipTap
//
//  Created by sriram on 08/11/23.
//

import UIKit

class NearbyListViewCVC: UICollectionViewCell {
    
    @IBOutlet weak var CellView: UIView!
    @IBOutlet weak var listViewImage: UIImageView!
    
    @IBOutlet weak var hotelNameLabel: UILabel!
    
   @IBOutlet weak var ratingLabelAG: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var descrictionLabel: UILabel!
    @IBOutlet weak var veraityLabel: UILabel!
    
//    @IBOutlet weak var ratingsLAbel2: UIView!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var promatedLabel: UILabel!
    @IBOutlet weak var offerTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
//        supportFile().labelSizes(mylabel: promatedLabel, mysize: 15, fontWeight: .bold, textColor: .white)
//        supportFile().labelSizes(mylabel: hotelNameLabel, mysize: 20, fontWeight: .bold, textColor: .black)
//        supportFile().labelSizes(mylabel: veraityLabel, mysize: 13, fontWeight: .regular, textColor: .darkGray)
//        supportFile().labelSizes(mylabel: offerLabel, mysize: 12, fontWeight: .bold, textColor: .white)
//        supportFile().labelSizes(mylabel: offerTypeLabel, mysize: 12, fontWeight: .regular, textColor: .darkGray)
//        supportFile().labelSizes(mylabel: descrictionLabel, mysize: 13, fontWeight: .regular, textColor: .darkGray)
        supportFile().circle(uibtn: heartBtn)
//        supportFile().labelSizes(mylabel: ratingLabelAG, mysize: 15, fontWeight: .bold, textColor: .white)
        supportFile().roundLabel(myLabel: offerLabel)
        promatedLabel.layer.cornerRadius = 5.0
        promatedLabel.layer.masksToBounds = true
        offerLabel.layer.cornerRadius = 5.0
        offerLabel.layer.masksToBounds = true
//        ratingsLAbel2.layer.cornerRadius = 5.0
//        ratingsLAbel2.layer.masksToBounds = true
        // Set up the shadow properties
        
    }
    func setCellUI(){
        hotelNameLabel.applyLabelStyle(for: .headingBlack)
        veraityLabel.applyLabelStyle(for: .subTitleLightGray)
        descrictionLabel.applyLabelStyle(for: .descriptionLightGray)
        offerTypeLabel.applyLabelStyle(for: .subTitleLightGray)
        //ratingLabelAG.applyLabelStyle(for: .OfferWhite)
        offerLabel.applyLabelStyle(for: .OfferWhite)
        promatedLabel.applyLabelStyle(for: .promotedLabel)
        CellView.cellBackViewShadow()
    }
}
