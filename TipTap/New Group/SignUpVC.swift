//
//  SignUpVC.swift
//  TipTap
//
//  Created by sriram on 16/11/23.
//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var mobileNumberLAbel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var signupForContinueLabel: UILabel!
    @IBOutlet weak var helloThereLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        signUpBtn.layer.cornerRadius = 5
        
    }
    
    @IBAction func forgotBtnAct(_ sender: Any) {
    }
    @IBAction func signUpBtnAct(_ sender: Any) {
    }
    
    @IBAction func signInBtnAct(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "TipTapViewController") as? TipTapViewController
        controller!.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .fullScreen
       self.present(controller!, animated: true)
    }
    
    func setUI(){
        helloThereLabel.applyLabelStyle(for: .titleBlack)
        signupForContinueLabel.applyLabelStyle(for: .subTitleBlack)
        namelabel.applyLabelStyle(for: .headingBlack)
        mobileNumberLAbel.applyLabelStyle(for: .headingBlack)
        PasswordLabel.applyLabelStyle(for: .headingBlack)
        signUpBtn.titleLabel?.applyLabelStyle(for: .buttonTitle)
        signInBtn.titleLabel?.applyLabelStyle(for: .descriptionLightGray)
        nameTF.applyCustomPlaceholderStyle(size: "small")
        mobileTF.applyCustomPlaceholderStyle(size: "small")
        passwordTF.applyCustomPlaceholderStyle(size: "small")
    }

}
