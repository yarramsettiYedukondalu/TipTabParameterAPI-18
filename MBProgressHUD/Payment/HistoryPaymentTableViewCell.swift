//
//  HistoryPaymentTableViewCell.swift
//  Hanumanu
//
//  Created by yarramsetti yedukondalu on 09/07/24.
//

import UIKit

class HistoryPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ttransectionId: UILabel!
    @IBOutlet weak var waiterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
