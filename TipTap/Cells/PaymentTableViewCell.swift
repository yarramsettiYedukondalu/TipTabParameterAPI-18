//
//  PaymentTableViewCell.swift
//  TipTap
//
//  Created by ToqSoft on 17/12/23.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
  @IBOutlet weak var backView: UIView!
    @IBOutlet weak var RestaurantNameLabel: UILabel!
    @IBOutlet weak var PaymentDateLabel: UILabel!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var PaymentMethodLabel: UILabel!
    @IBOutlet weak var PaymentStatusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  backView.cellBackViewShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


