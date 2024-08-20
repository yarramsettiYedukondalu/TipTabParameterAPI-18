//
//  OtpScreen.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//

import UIKit


    class OtpScreen: UIViewController {
        @IBOutlet weak var enterOtpLabel: UILabel!
        @IBOutlet weak var phonenumberLabel: UILabel!
        @IBOutlet weak var verifyLabel: UILabel!
        @IBOutlet weak var verifyButton: UIButton!
        override func viewDidLoad() {
            super.viewDidLoad()
            verifyButton.layer.cornerRadius = 5
            setUI()
            
    }
        
        @IBAction func verifyAction(_ sender: UIButton) {
            let controller = self.storyboard?.instantiateViewController(identifier: "splashScreens") as? splashScreens
           controller!.modalTransitionStyle = .coverVertical
           controller?.modalPresentationStyle = .fullScreen
           self.present(controller!, animated: true)
        }
        
        func setUI(){
            verifyLabel.applyLabelStyle(for: .largeHeadingBlack)
            phonenumberLabel.applyLabelStyle(for: .largeHeadingBlack)
            enterOtpLabel.applyLabelStyle(for: .descriptionLightGray)
            verifyButton.titleLabel?.applyLabelStyle(for: .buttonTitle)
        }

    }

