//
//  SectionTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/23.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    @IBOutlet weak var sectrionImage: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
     setCellUI()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellUI(){
        nameLabel.applyLabelStyle(for: .smallheadingBlack)
        dateLabel.applyLabelStyle(for: .descriptionSmallBlack)
        amountLabel.applyLabelStyle(for: .descriptionSmallBlack)
        
    
    }
}
