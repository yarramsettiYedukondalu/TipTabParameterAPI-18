//
//  RewardsTableViewCellTVC.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/23.
//

import UIKit
class RewardsTableViewCellTVC: UITableViewCell {
    @IBOutlet weak var describtionLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var rewardsTipTab: UILabel!
    @IBOutlet weak var chervonImage: UIImageView!
    @IBOutlet weak var rewardsName: UILabel!
    @IBOutlet weak var rewardsDate: UILabel!
    @IBOutlet weak var rewardsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rewardsImage.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
