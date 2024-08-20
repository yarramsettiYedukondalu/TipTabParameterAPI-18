//
//  RatingsTableViewCellTVC.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/23.
//

import UIKit

class RatingsTableViewCellTVC: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ratingImage: UIImageView!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var ratingDateLabel: UILabel!
    @IBOutlet weak var ratingNameLabel: UILabel!
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.settings.fillMode = .precise
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func conigureShadow(){
        backView.layer.cornerRadius = 5
        backView.layer.shadowColor = UIColor.darkGray.cgColor
        backView.layer.shadowOffset = CGSize(width: 3, height: 3)
        backView.layer.shadowRadius = 4
        backView.layer.shadowOpacity = 0.5
        backView.layer.masksToBounds = false
    }
    
}
