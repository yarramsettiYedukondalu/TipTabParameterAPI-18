//
//  ProfileTableViewCell2.swift
//  TipTap
//
//  Created by sriram on 16/11/23.
//

import UIKit

class ProfileTableViewCell2: UITableViewCell {

   
    

    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.applyLabelStyle(for: .smallheadingBlack)
        imageBackView.layer.cornerRadius = imageBackView.frame.size.height / 2
        imageBackView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
