//
//  LeftMenuTableViewCell.swift
//  TipTap
//
//  Created by sriram on 04/11/23.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var img: UIImageView!
    
   // @IBOutlet var lbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
