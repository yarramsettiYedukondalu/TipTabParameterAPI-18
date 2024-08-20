//
//  EmptyRewardCell.swift
//  TipTap
//
//  Created by ToqSoft on 28/02/24.
//

import UIKit

class EmptyRewardCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
  //  @IBOutlet weak var Uiimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        Uiimage.layer.cornerRadius = 5
//        Uiimage.layer.cornerRadius = 5
//        Uiimage.layer.borderWidth = 0.5
//        Uiimage.layer.borderColor = UIColor.lightGray.cgColor
//        Uiimage.clipsToBounds = true
        
        
        shadow()
    }
    func shadow(){
        mainView.cellBackViewShadow()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
