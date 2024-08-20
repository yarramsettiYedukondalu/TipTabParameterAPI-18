//
//  ResponsePageViewController.swift
//  TipTap
//
//  Created by ToqSoft on 02/02/24.
//

import UIKit
class ResponsePageViewController: UIViewController {
    @IBOutlet weak var thankyouLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var message = ""
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        dismissButton.layer.cornerRadius = 5
        dismissButton.clipsToBounds = true
    }
    @IBAction func dissmiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func setUI(){
        thankyouLabel.applyLabelStyle(for: .headingBlack)
        messageLabel.applyLabelStyle(for: .smallheadingBlack)
        dismissButton.titleLabel?.applyLabelStyle(for: .OfferWhite)
    }
}
