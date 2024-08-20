//
//  filterTVC.swift
//  TipTap
//
//  Created by sriram on 17/11/23.
//

import UIKit

class filterTVC: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Circlebutton: UIButton!
    var radioButtonTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func radioButtonAction(_ sender: UIButton) {
        // Iterate through all the buttons in the cell
        sender.setImage(UIImage(named: "circle.red"), for: .normal)
        
        // Invoke the closure to notify the controller
        radioButtonTapped?()
        
    }
}
