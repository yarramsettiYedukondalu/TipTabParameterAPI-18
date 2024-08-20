
//  UserLogsTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 19/12/23.
//

import UIKit

class UserLogsTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var LogTypeLabel: UILabel!
    @IBOutlet weak var LogDateLabel: UILabel!
    @IBOutlet weak var LogDetailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        backView.cellBackViewShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
