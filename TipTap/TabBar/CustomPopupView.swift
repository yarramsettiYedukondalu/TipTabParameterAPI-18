//
//  CustomPopupView.swift
//  TipTap
//
//  Created by ToqSoft on 16/11/23.
//

import Foundation
import UIKit

protocol CustomPopupDelegate: AnyObject {
    func didTapDirectionButton(index: Int)
    func didTapDismissButton()
}
class CustomPopupView: UIView {
    weak var delegate: CustomPopupDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var directionButton: UIButton!
    
    @IBOutlet weak var ratingsView: CosmosView!
    static func loadFromNib() -> CustomPopupView {
            let nib = UINib(nibName: "CustomPopupView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! CustomPopupView
        }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.didTapDismissButton()
       
    }
    @IBAction func directionButtonTapped(_ sender: UIButton) {
           delegate?.didTapDirectionButton(index: sender.tag)
       }

     
    
}
