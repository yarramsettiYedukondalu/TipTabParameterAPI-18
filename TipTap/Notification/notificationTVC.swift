//
//  notificationTVC.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//

import UIKit

class notificationTVC: UITableViewCell {
    
    @IBOutlet weak var chevronImage: UIImageView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var notificationImageView: UIImageView!
    
    @IBOutlet weak var notificationTitleName: UILabel!
    
    @IBOutlet weak var descriptionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MainView.cellBackViewShadow()
        notificationImageView.layer.cornerRadius = notificationImageView.frame.size.width / 2
        notificationImageView.clipsToBounds = true
        self.MainView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
