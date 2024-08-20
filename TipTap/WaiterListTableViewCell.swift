//
//  WaiterListTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 01/08/24.
//

import UIKit

class WaiterListTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var waiterImage: UIImageView!
    @IBOutlet weak var waiterNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
