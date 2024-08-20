//
//  UserReportTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 19/12/23.
//

import UIKit

class UserReportTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var RestaurantNameLabel: UILabel!
    @IBOutlet weak var ReportTextLabel: UILabel!
    @IBOutlet weak var ReprotDateLabel: UILabel!

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
