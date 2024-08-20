//
//  ViewDetailsTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 12/08/24.
//

import UIKit

class ViewDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var downImage: UIImageView!
    @IBOutlet weak var transctionIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
