//
//  TipHistoryTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 08/08/24.
//

import UIKit

class TipHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var waiterImage: UIImageView!
    
    @IBOutlet weak var sarAmountLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var waiterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

