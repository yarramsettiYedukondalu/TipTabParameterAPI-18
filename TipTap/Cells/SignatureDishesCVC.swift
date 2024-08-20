//
//  SignatureDishesCVC.swift
//  TipTap
//
//  Created by sriram on 27/11/23.
//

import UIKit
import SVProgressHUD

class SignatureDishesCVC: UICollectionViewCell {
    var SelectedItem : ItemCompleteData?
    var isFavorite : Bool  = false
    
    var reloadDishesCVAfterFavActionClosure: (() -> Void)?
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var imageViewWidhtConstraint: NSLayoutConstraint!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var promotedLAbel: UILabel!
    @IBOutlet weak var OfferNameLabel: UILabel!
    @IBOutlet weak var OfferTitlelabel: UILabel!
    @IBOutlet weak var subdescriptionLabel: UILabel!
    
    @IBOutlet weak var ItemImgView: UIImageView!
    @IBOutlet weak var RestuarantNameLabel: UILabel!
    //@IBOutlet weak var resturantDescriptnLabl: UILabel!
    
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        favoriteBtn.layer.cornerRadius = favoriteBtn.frame.size.height / 2

        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 2
        self.contentView.layer.masksToBounds = false
        
        setCellUI()
        
    }
    
    func setCellUI(){
        starsView.settings.fillMode = .precise
        RestuarantNameLabel.applyLabelStyle(for: .headingBlack)
        //  resturantDescriptnLabl.applyLabelStyle(for: .subTitleLightGray)
        subdescriptionLabel.applyLabelStyle(for: .subTitleLightGray)
        RatingLabel.applyLabelStyle(for: .OfferWhite)
        promotedLAbel.applyLabelStyle(for: .promotedLabel)
        OfferTitlelabel.applyLabelStyle(for: .OfferWhite)
        RestuarantNameLabel.applyLabelStyle(for: .headingBlack)
        //  resturantDescriptnLabl.applyLabelStyle(for: .subTitleLightGray)
        //  subdescriptionLabel.applyLabelStyle(for: .subTitleLightGray)
        //   subdescriptionLabel.textColor = UIColor.lightGray
        
        OfferTitlelabel.applyLabelStyle(for: .OfferWhite)

        OfferTitlelabel.layer.cornerRadius = 5
        OfferTitlelabel.layer.masksToBounds = true
        OfferTitlelabel.backgroundColor = UIColor(red: 102/245, green: 153/245, blue: 0/245, alpha: 1)
        
        OfferNameLabel.applyLabelStyle(for: .descriptionLightGray)
        
        RatingLabel.applyLabelStyle(for: .OfferWhite)
        
        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        ratingView.layer.cornerRadius = 5
        ratingView.layer.masksToBounds = false
        
        promotedLAbel.applyLabelStyle(for: .promotedLabel)
        
        backView.cellBackViewShadow()
        
    }
    
    func configure(with dishes : ItemCompleteData) {
        SelectedItem = dishes
       // ItemImgView.image = UIImage(named: dishes.dishImage)
        RestuarantNameLabel.text = dishes.Item.ItemTitle
    //resturantDescriptnLabl.text = dishes.Description
        subdescriptionLabel.text = dishes.Item.CusineTitle
        starsView.text = "(\(dishes.itemAverageRating ?? 0.0))"
        starsView.rating = dishes.itemAverageRating ?? 0.0
        if let itemOffer = dishes.ItemOffer, itemOffer.itemID != "" {
            DispatchQueue.main.async { [self] in
                   OfferNameLabel.text = "\(itemOffer.discount) %"
                   OfferTitlelabel.text = itemOffer.offerTitle
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
    
    @IBAction func favouriteBtnAction(_ sender: UIButton) {
        
        guard let itemID = SelectedItem?.Item.ItemID , let restaurantId = SelectedItem?.Item.RestaurantID else {return}
        
        //   isFavorite = !isFavorite
        if !isFavorite {
            updateFavoriteStatus(itemId: itemID, restaurantId: restaurantId, isFavorite: isFavorite) { [self] success in
                if success {
                    print("Favorite status updated successfully")
                    DispatchQueue.main.async { [self] in
                        favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                    reloadDishesCVAfterFavActionClosure?()
                } else {
                    print("Failed to update favorite status")
                }
            }
        }
            
         else {
//             deleteFavoriteRecord(restaurantID: restaurantId, itemId: itemID) {[self] success in
//                 if success {
//                     print("Favorite status deleted successfully")
//                     DispatchQueue.main.async { [self] in
//                         favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//                     }
//
//                     reloadDishesCVAfterFavActionClosure?()
//                 } else {
//                     print("Failed to delete favorite status")
//                    
//                     // Handle failure case, if needed
//                 }
//
//             }
             
             SVProgressHUD.show()
             var userFavoriteItemIdToDelete: String?
             fetchUserFavouriteItemIdToDelete(restaurantID: restaurantId, itemId: itemID) { (matchingID) in
                 userFavoriteItemIdToDelete = matchingID
                 print("User's favorite restaurant ID To Delete: \(matchingID)")
                 
                 deleteFavoriteItemRecord(userFavoriteItemIdToDelete: userFavoriteItemIdToDelete ?? ""){  [self] success in
                     if success {
                         SVProgressHUD.dismiss()
                         print("Favorite status deleted successfully")
                         
                         reloadDishesCVAfterFavActionClosure?()
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


//        func deleteFavoriteRecord(restaurantID: String, itemId: String, completion: @escaping (Bool) -> Void) {
//            
//            let matchingIDs = JsonDataArrays.userFavouriteItemsArray
//                .filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID && $0.ItemID == itemId }
//                .map { $0.UserFavouriteItemID }
//            
//            guard !matchingIDs.isEmpty else {
//                completion(false)
//                return
//            }
//            let deleteUrlString = FavouriteItemURL
//            guard let deleteApiUrl = URL(string: deleteUrlString) else {
//                print("Invalid URL: \(deleteUrlString)")
//                return
//            }
//            
//            
//            var request = URLRequest(url: deleteApiUrl)
//            request.httpMethod = "DELETE"
//            
//            let requestBody: [String: Any] = [
//                "rowKey": matchingIDs[0] ?? "",
//                      "partitionKey": "UserFavouriteItems"
//            ]
//            
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
//            } catch {
//                print("Error encoding request body: \(error)")
//                completion(false)
//                return
//            }
//            
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    print("Error: \(error)")
//                    completion(false)
//                    return
//                }
//                
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("HTTP Status Code: \(httpResponse.statusCode)")
//                    
//                    if httpResponse.statusCode == 200 {
//                        print("Favorite status updated successfully")
//                        completion(true)
//                    } else {
//                        print("HTTP Status Code: \(httpResponse.statusCode)")
//                        completion(false)
//                    }
//                }
//            }.resume()
//            
//            
//            
//            
//            
//        }

}

