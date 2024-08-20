//
//  WailterListTVC.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//

import UIKit
 
class WailterListTVC: UITableViewCell {
 
  //  @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var CellView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var waiterRating: UILabel!
    @IBOutlet weak var waiterPhone: UILabel!
    @IBOutlet weak var waiterEmail: UILabel!
    @IBOutlet weak var waiterName: UILabel!
    @IBOutlet weak var waiterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCellUI()
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
    func setCellUI(){
        waiterName.applyLabelStyle(for: .headingBlack)
        waiterEmail.applyLabelStyle(for: .subTitleLightGray)
        waiterPhone.applyLabelStyle(for: .descriptionLightGray)
        waiterRating.applyLabelStyle(for: .OfferWhite)
        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        ratingView.layer.cornerRadius = 5
        ratingView.layer.masksToBounds = false
        
    }
    func configure(with waiterData : WaiterCompleteData) {
     
        
        waiterName.text = (waiterData.waiter.firstName ?? "") + " " + (waiterData.waiter.lastName ?? "")
        waiterEmail.text = waiterData.waiter.email
        waiterPhone.text = "Mob: \(waiterData.waiter.contactNumber ?? 0)"
        waiterRating.text = "\(waiterData.waiterAverageRating ?? 0.0) (\(waiterData.waiterRating.count))"
        
        if let image = waiterData.waiter.waiterImage{
//            loadImage(from: image) { image  in
//                if let img = image {
//                    DispatchQueue.main.async {
//                        self.waiterImage.image = img
//                    }
//                }
//            }
            guard let imageUrl = URL(string: image) else {
                      print("Invalid URL: \(image)")
                      return
                  }
            ImageLoader.shared.loadImage(from: imageUrl) { image in
                       DispatchQueue.main.async {
                           self.waiterImage.image = image
                       }
                   }
        }else{
            self.waiterImage.image = UIImage(systemName: "person")
        }
     //   waiterRating.text = "3.1 (300+)"
      //  waiterRating.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
       // ratingView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.6862745098, blue: 0.4156862745, alpha: 1)
       // ratingView.layer.cornerRadius = 5
       // ratingView.layer.masksToBounds = false
        
        
        // Set up the shadow properties
        CellView.layer.backgroundColor = UIColor.white.cgColor
        CellView.layer.cornerRadius = 5 // You can adjust this value as needed
        CellView.layer.borderWidth = 1
        CellView.layer.borderColor = UIColor.clear.cgColor
        CellView.layer.shadowColor = UIColor.lightGray.cgColor
        CellView.layer.shadowOffset = CGSize(width: 5, height: 5)
        CellView.layer.shadowRadius = 4
        CellView.layer.shadowOpacity = 3
        CellView.layer.masksToBounds = false
    
        //CellView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
   
}
