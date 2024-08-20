//
//  FoodGroupPopupViewController.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//

import UIKit

class FoodGroupPopupViewController: UIViewController {
    var LabelText = ""
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 10
        TitleLabel.text = LabelText
        setUI()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setUI(){
        TitleLabel.applyLabelStyle(for: .headingBlack)
    }
    
}
