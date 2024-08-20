//
//  GoogleSignInProfileVC.swift
//  TipTap
//
//  Created by Toqsoft on 24/11/23.
//

import UIKit
import GoogleSignIn

class GoogleSignInProfileVC: UIViewController {
    
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUserData()
    }
    
    func setUI(){
        titleLabel.applyLabelStyle(for: .headingSmall)
        profilePicImage.layer.cornerRadius = profilePicImage.bounds.width / 2
        profilePicImage.layer.borderWidth = 4
        profilePicImage.layer.borderColor = UIColor.white.cgColor
        userNamelabel.applyLabelStyle(for: .description)
        userEmailLabel.applyLabelStyle(for: .descriptionSmall)
        cancelButton.titleLabel?.applyLabelStyle(for: .buttonTitle)
        continueBtn.titleLabel?.applyLabelStyle(for: .buttonTitle)
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.white.cgColor
        continueBtn.layer.cornerRadius = 5
        continueBtn.layer.borderWidth = 2
        continueBtn.layer.borderColor = UIColor.white.cgColor
        
    }
    
    @IBAction func cancelbuttonAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signOut()
        self.dismiss(animated: true)
    }
    @IBAction func continueBtnaction(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "splashScreens") as? splashScreens
        controller!.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .fullScreen
       self.present(controller!, animated: true)
    }
    func setUserData(){
        let userDefaults = UserDefaults.standard
        let userEmail = userDefaults.string(forKey: "userEmail")
        let userFullName = userDefaults.string(forKey: "userFullName")
        let userFamilyName = userDefaults.string(forKey: "userFamilyName")
        let userProfilePicUrlString = userDefaults.string(forKey: "userProfilePicUrl")
        userNamelabel.text = userFullName
        userEmailLabel.text = userEmail
        if let userProfilePicUrlString = userProfilePicUrlString,
           let userProfilePicUrl = URL(string: userProfilePicUrlString) {
            
            // Download and display the profile image
            URLSession.shared.dataTask(with: userProfilePicUrl) { (data, _, error) in
                if let error = error {
                    print("Error downloading profile image: \(error.localizedDescription)")
                    // Handle the error if necessary
                } else if let data = data {
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        self.profilePicImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
