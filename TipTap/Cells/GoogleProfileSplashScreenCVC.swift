//
//  GoogleProfileSplashScreenCVC.swift
//  TipTap
//
//  Created by Toqsoft on 24/11/23.
//

import UIKit
class GoogleProfileSplashScreenCVC: UICollectionViewCell {
    @IBOutlet weak var backMainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
    }
    func  setCellUI(){
        let sharedSourceFile = SourceFile.shared
        titleLabel.applyLabelStyle(for: .titleBlack)
        profilePicImage.layer.cornerRadius = profilePicImage.bounds.width / 2
        profilePicImage.layer.borderWidth = 4
        profilePicImage.layer.borderColor = sharedSourceFile.viewBackgroundColor.cgColor
        userNamelabel.applyLabelStyle(for: .smallheadingBlack)
        userEmailLabel.applyLabelStyle(for: .descriptionDarkGray)
        backMainView.layer.cornerRadius = 5
        backMainView.layer.borderWidth = 2
        backMainView.layer.borderColor = sharedSourceFile.viewBackgroundColor.cgColor
        backMainView.layer.shadowColor = sharedSourceFile.viewBackgroundColor.cgColor
        backMainView.layer.shadowOpacity = 0.5
        backMainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        backMainView.layer.shadowRadius = 4
    }
    

    
    
    func setup() {
                loginUserID = UserDefaults.standard.string(forKey: "UserID")
                
                let userDefaults = UserDefaults.standard
                let userEmail = userDefaults.string(forKey: "userEmail") ?? ""
                let userFName = userDefaults.string(forKey: "FirstName") ?? ""
                let userLName = userDefaults.string(forKey: "LastName") ?? ""
                let LastLoginDate = userDefaults.string(forKey: "LastLoginDate") ?? ""
            let userProfilePicBase64String = userDefaults.string(forKey: "userProfilePicUrl")!
                
                self.userNamelabel.text = userFName /*+ " " + userLName*/
                self.userEmailLabel.text = userEmail
            
                
              let url = URL(string: userProfilePicBase64String)
            let task = URLSession.shared.dataTask(with: url!) { data , error,responce  in
                guard let data = data else {
                   print("Url Image is Error")
                    return
                }
                if let error = error {
                    print(error)
                }
                DispatchQueue.main.async {
                    self.profilePicImage.image = UIImage(data: data)
                }
            }
            task.resume()
     
            }
        }
    

