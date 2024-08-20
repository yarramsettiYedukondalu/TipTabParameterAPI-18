//
//  ProfileTableViewCell.swift
//  TipTap
//
//  Created by sriram on 15/11/23.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellUI(){
        titleLabel.applyLabelStyle(for: .smallheadingBlack)
        subLabel.applyLabelStyle(for: .descriptionDarkGray)
    
    }
}
