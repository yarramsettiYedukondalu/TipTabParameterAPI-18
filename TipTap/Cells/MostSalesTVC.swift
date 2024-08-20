//
//  MostSalesTVC.swift
//  TipTap
//
//  Created by Toqsoft on 30/10/23.
//

import UIKit
import SVProgressHUD

class MostSalesTVC: UITableViewCell {
    
    var isFavorite :Bool = false
    var SelectedItem :ItemCompleteData?
    var reloadMostSalesTVAfterFavActionClosure: (() -> Void)?
   // var reloadMostSalesTVAfterFavActionClosure: ((String, String ,Int) -> Void)?
    
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var imageViewWidhtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var promotedLAbel: UILabel!
    @IBOutlet weak var OfferNameLabel: UILabel!
    @IBOutlet weak var OfferTitlelabel: UILabel!
    @IBOutlet weak var subdescriptionLabel: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var ItemImgView: UIImageView!
    @IBOutlet weak var RestuarantNameLabel: UILabel!
    @IBOutlet weak var resturantDescriptnLabl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        starsView.settings.fillMode = .precise
    }
    override func layoutSubviews() {
        super.layoutSubviews()
      
        favoriteBtn.layer.cornerRadius = favoriteBtn.frame.size.height / 2
        
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5))

        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 2
        self.contentView.layer.masksToBounds = true
        
//        let bezierPath = UIBezierPath.init(roundedRect: self.contentView.bounds, cornerRadius: 12.69)
//        self.contentView.layer.shadowPath = bezierPath.cgPath
        
       
        
//        self.contentView.layer.cornerRadius = 5
//        self.contentView.layer.shadowColor = UIColor.darkGray.cgColor
//        self.contentView.layer.shadowOpacity = 0.5
//        self.contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        self.contentView.layer.shadowRadius = 4
//        self.contentView.layer.masksToBounds = false
        
        setCellUI()
       
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellUI(){
        RestuarantNameLabel.applyLabelStyle(for: .headingBlack)
        resturantDescriptnLabl.applyLabelStyle(for: .subTitleLightGray)
        subdescriptionLabel.applyLabelStyle(for: .descriptionLightGray)
        RatingLabel.applyLabelStyle(for: .OfferWhite)
        promotedLAbel.applyLabelStyle(for: .OfferWhite)
        OfferTitlelabel.applyLabelStyle(for: .OfferWhite)
        RestuarantNameLabel.applyLabelStyle(for: .headingBlack)
        resturantDescriptnLabl.applyLabelStyle(for: .subTitleLightGray)
        subdescriptionLabel.applyLabelStyle(for: .subTitleLightGray)
     //   RatingLabel.text = "4"
        subdescriptionLabel.textColor = UIColor.lightGray
        
        OfferTitlelabel.applyLabelStyle(for: .OfferWhite)
        OfferTitlelabel.layer.cornerRadius = 5
        OfferTitlelabel.layer.masksToBounds = true
        OfferTitlelabel.backgroundColor = UIColor(red: 102/245, green: 153/245, blue: 0/245, alpha: 1)
        
        OfferNameLabel.applyLabelStyle(for: .subTitleLightGray)
        OfferNameLabel.textColor = UIColor.lightGray
        
        RatingLabel.applyLabelStyle(for: .OfferWhite)
       // RatingLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        ratingView.layer.cornerRadius = 5
        ratingView.layer.masksToBounds = false
        
        backView.cellBackViewShadow()
        
        promotedLAbel.applyLabelStyle(for: .promotedLabel)
        
    }
    
    
    func configureItemComplete(with dishes : ItemCompleteData) {
        SelectedItem = dishes
        RestuarantNameLabel.text = dishes.Item.ItemTitle
        resturantDescriptnLabl.text = dishes.Item.CusineTitle
        subdescriptionLabel.text = dishes.Item.Description
        starsView.text = "(\(dishes.itemAverageRating ?? 0.0))"
        starsView.rating = dishes.itemAverageRating ?? 0.0
        if let dishOffer = dishes.ItemOffer, dishOffer.itemID != "" {
            DispatchQueue.main.async { [self] in
                OfferNameLabel.text = "\(dishOffer.discount) %"
                OfferTitlelabel.text = dishOffer.offerTitle
                OfferNameLabel.isHidden = false
                OfferTitlelabel.isHidden = false
               }
           } else {
               DispatchQueue.main.async { [self] in
                   OfferNameLabel.isHidden = true
                   OfferTitlelabel.isHidden = true
               }
           }
        RatingLabel.text = "\(dishes.itemAverageRating ?? 0.0)(\(dishes.ItemRatings.count))"
        if let image = dishes.Item.itemImage{
//            loadImage(from: image ) { image  in
//                if let img = image {
//                    DispatchQueue.main.async {
//                        self.ItemImgView.image = img
//                    }
//                }
//            }
            guard let imageUrl = URL(string: image) else {
                      print("Invalid URL: \(image)")
                      return
                  }
            ImageLoader.shared.loadImage(from: imageUrl) { image in
                       DispatchQueue.main.async {
                           self.ItemImgView.image = image
                       }
                   }
        }else{
            DispatchQueue.main.async {
                self.ItemImgView.image = emptyImage
            }
        }
    }
    
    @IBAction func favoriteBtnAction(_ sender: UIButton) {
        
        guard let itemID = SelectedItem?.Item.ItemID , let restaurantId = SelectedItem?.Item.RestaurantID else {return}
        
        //   isFavorite = !isFavorite
        if !isFavorite {
            SVProgressHUD.show()
            updateFavoriteStatus(itemId: itemID, restaurantId: restaurantId, isFavorite: isFavorite) { [self] success in
                if success {
                    SVProgressHUD.dismiss()
                    print("Favorite status updated successfully")
                    reloadMostSalesTVAfterFavActionClosure?()
                    
                } else {
                    SVProgressHUD.dismiss()
                    print("Failed to update favorite status")
                    
                }
            }
            
        }
        
        else {
            //             SVProgressHUD.show()
            //             deleteFavoriteRecord(restaurantID: restaurantId, itemId: itemID) {[self] success in
            //                 if success {
            //                     SVProgressHUD.dismiss()
            //                     print("Favorite status deleted successfully")
            //                     reloadMostSalesTVAfterFavActionClosure?()
            //                     
            //                 } else {
            //                     SVProgressHUD.dismiss()
            //                     print("Failed to delete favorite status")
            //                   
            //                 }
            //                 
            //             }
            //        }
            
            
            
            
            SVProgressHUD.show()
            var userFavoriteItemIdToDelete: String?
            fetchUserFavouriteItemIdToDelete(restaurantID: restaurantId, itemId: itemID) { (matchingID) in
                userFavoriteItemIdToDelete = matchingID
                print("User's favorite restaurant ID To Delete: \(matchingID)")
                
                deleteFavoriteItemRecord(userFavoriteItemIdToDelete: userFavoriteItemIdToDelete ?? ""){  [self] success in
                    if success {
                        SVProgressHUD.dismiss()
                        print("Favorite status deleted successfully")
                        
                        reloadMostSalesTVAfterFavActionClosure?()
                    } else {
                        SVProgressHUD.dismiss()
                        print("Failed to update favorite status")
                    }
                    
                }
            }
            
            
        }
    }

func updateFavoriteStatus(itemId: String, restaurantId: String, isFavorite: Bool, completion: @escaping (Bool) -> Void) {
    let urlString = FavouriteItemURL
    
    guard let apiUrl = URL(string: urlString) else {
        print("Invalid URL: \(urlString)")
        completion(false)
        return
    }
    guard let loginUserID = loginUserID ,loginUserID != "" else{
        completion(false)
        return
    }
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    
    let requestBody: [String: Any] = [
    //    "PartitionKey": "UserFavouriteItems",
        "UserID": loginUserID,
        "RestaurantID": restaurantId,
        "ItemID": itemId,
        "Disabled": false
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    } catch {
        print("Error encoding request body: \(error)")
        completion(false)
        return
    }
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(false)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                print("Favorite status updated successfully")
                completion(true)
            } else {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                completion(false)
            }
        }
    }.resume()
}




func updateFavoriteUI(_ isFavorite: Bool) {
    let imageName = isFavorite ? "heart.fill" : "heart"
    favoriteBtn.setImage(UIImage(systemName: imageName), for: .normal)
}

    
}
