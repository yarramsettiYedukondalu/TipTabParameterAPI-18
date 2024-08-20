//
//  NotificationVC.swift
//  TipTap
//
//  Created by sriram on 06/11/23.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        backView.layer.cornerRadius = 10
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
