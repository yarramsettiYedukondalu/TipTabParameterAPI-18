//
//  FeedBackTableViewCellTVC.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/23.
//

import UIKit

class FeedBackTableViewCellTVC: UITableViewCell {
    
    @IBOutlet weak var HeadingLabel: UILabel!
    @IBOutlet var ansStackViews: [UIStackView]!
    
    @IBOutlet var qNaViews: [UIView]!
    
    @IBOutlet var FeedBackQns: [UILabel]!
    
    @IBOutlet var QnStackViews: [UIStackView]!
    @IBOutlet weak var howoftenUseLabel: UILabel!
    @IBOutlet weak var MotivationLabel: UILabel!
    @IBOutlet weak var mostUsedFeatureLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var featureNeedToImprove: UILabel!
    
    @IBOutlet var Qlabels: [UILabel]!
    
    @IBOutlet var Alabels: [UILabel]!
    override func awakeFromNib() {
        super.awakeFromNib()
        HeadingLabel.applyLabelStyle(for: .OfferWhite)
        HeadingLabel.textAlignment = .left
        HeadingLabel.cornerRadius = 5
        HeadingLabel.layer.masksToBounds = true
        for qnstck in QnStackViews{
            qnstck.backgroundColor = UIColor(red: 229/245, green: 241/245, blue: 226/245, alpha: 1)
        }
        for ansstck in ansStackViews{
            ansstck.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            
        }
        for qn in FeedBackQns{
            qn.applyLabelStyle(for: .subTitleLightGray)
        }
        for qlabel in Qlabels{
            qlabel.applyLabelStyle(for: .subTitleBlack)
            
        }
        
        for alabel in Alabels{
            alabel.applyLabelStyle(for: .headinglightGray)
        }
        for qa in qNaViews{
            qa.layer.cornerRadius = 5
            qa.layer.masksToBounds = true
            qa.layer.borderColor = UIColor.white.cgColor
            qa.layer.borderWidth = 0.1
        }
        howoftenUseLabel.applyLabelStyle(for: .descriptionSmallBlack)
        MotivationLabel.applyLabelStyle(for: .descriptionSmallBlack)
        featureNeedToImprove.applyLabelStyle(for: .descriptionSmallBlack)
        mostUsedFeatureLabel.applyLabelStyle(for: .descriptionSmallBlack)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setUserImage(urlString: String) {
        
        if !urlString.isEmpty{
            let userProfilePicUrl = URL(string: urlString)!
            
            // Download and display the profile image
            URLSession.shared.dataTask(with: userProfilePicUrl) { (data, _, error) in
                if let error = error {
                    print("Error downloading profile image: \(error.localizedDescription)")
                    // Handle the error if necessary
                } else if let data = data {
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        //  self.userImage.image = UIImage(data: data)
                    }
                }
            }.resume()
            
        }
    }
    
    
    
}
