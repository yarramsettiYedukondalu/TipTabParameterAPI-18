//
//  TitleCell.swift
//  TipTap
//
//  Created by Toqsoft on 27/10/23.
//

import UIKit

class TitleCell: UITableViewCell {
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let superview = superview {
                   contentView.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
               }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
