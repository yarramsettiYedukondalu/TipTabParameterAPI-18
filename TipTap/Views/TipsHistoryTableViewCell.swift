//
//  TipsHistoryTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 08/08/24.
//

import UIKit

class TipsHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var vdesignView: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
      //  self.vdesignView.cellBackViewShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
