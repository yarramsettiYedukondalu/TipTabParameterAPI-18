////
////  PopularCollectionViewCell.swift
////  mostPolupar
////
////  Created by ToqSoft on 31/10/23.
////
//
//import UIKit
//import SVProgressHUD
//
//class PopularCollectionViewCell: UICollectionViewCell {
//    
//    @IBOutlet weak var starsView: CosmosView!
//    @IBOutlet weak var promoteLabel: UILabel!
//    
//    @IBOutlet weak var ratingView: UIView!
//    @IBOutlet weak var RatingLabel: UILabel!
//    @IBOutlet weak var heartBtn: UIButton!
//    @IBOutlet weak var backView: UIView!
//    @IBOutlet weak var placeFamous: UILabel!
//    @IBOutlet weak var offerName: UILabel!
//    @IBOutlet weak var OfferTitleLbl: UILabel!
//    @IBOutlet weak var foodName: UILabel!
//    @IBOutlet weak var foodImage: UIImageView!
//    
//    var isFavorite :Bool = false
//    var SelectedItem :ItemCompleteData?
//    var reloadCuisineCollectionViewAfterFavActionClosure: (() -> Void)?
//    var support = supportFile()
//
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setCellUI()
////        backView.layer.shadowColor = UIColor.black.cgColor
////        backView.layer.shadowOpacity = 0.5 // Adjust this value as needed
////        backView.layer.shadowOffset = CGSize(width: 3, height: 3)
////        backView.layer.shadowRadius = 5
//        
//        promoteLabel.layer.cornerRadius = 5
//        promoteLabel.layer.masksToBounds = true
//        OfferTitleLbl.layer.cornerRadius = 5
//        OfferTitleLbl.layer.masksToBounds = true
//        
//        RatingLabel.applyLabelStyle(for: .OfferWhite)
//       // RatingLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        
//        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
//        ratingView.layer.cornerRadius = 5
//        ratingView.layer.masksToBounds = false
//        
//        heartBtn.layer.cornerRadius = 15
//        heartBtn.layer.masksToBounds = true
//    }
//    
//    func setCellUI(){
//        starsView.settings.fillMode = .precise
//        backView.cellBackViewShadow()
//        placeFamous.applyLabelStyle(for: .headingBlack)
//        foodName.applyLabelStyle(for: .subTitleLightGray)
//        offerName.applyLabelStyle(for: .subTitleLightGray)
//        offerName.textColor = UIColor.lightGray
//        promoteLabel.applyLabelStyle(for: .promotedLabel)
//        OfferTitleLbl.applyLabelStyle(for: .OfferWhite)
//    }
//    
//    func configure(with cuisine : CuisineModel) {
//        placeFamous.text = cuisine.cuisineName
//        foodName.text = cuisine.description
//        offerName.text = cuisine.offerName
//        if let image = cuisine.cuisineImage{
//            foodImage.image = UIImage(named: image )
//        }else{
//            foodImage.image = emptyImage
//        }
//    }
//
//    
//    func configure2(with item: ItemCompleteData) {
//        // Adjust these properties based on your Item structure
//        SelectedItem = item
//        placeFamous.text = item.Item.CusineTitle
//        foodName.text = item.Item.ItemTitle
//        RatingLabel.text = "\(item.itemAverageRating ?? 0.0)(\(item.ItemRatings.count))"
//        starsView.text = "(\(item.itemAverageRating ?? 0.0))"
//        starsView.rating = item.itemAverageRating ?? 0.0
//        if let itemOffer = item.ItemOffer, itemOffer.itemID != "" {
//            DispatchQueue.main.async { [self] in
//                offerName.text = "\(itemOffer.discount) %"
//                OfferTitleLbl.text = itemOffer.offerTitle
//                offerName.isHidden = false
//                OfferTitleLbl.isHidden = false
//               }
//           } else {
//               DispatchQueue.main.async { [self] in
//                   offerName.isHidden = true
//                   OfferTitleLbl.isHidden = true
//               }
//           }
//        if let image = item.Item.itemImage{
////            loadImage(from: image) { image  in
////                if let img = image {
////                    DispatchQueue.main.async {
////                        self.foodImage.image = img
////                    }
////                }
////            }
//            guard let imageUrl = URL(string: image) else {
//                      print("Invalid URL: \(image)")
//                      return
//                  }
//            ImageLoader.shared.loadImage(from: imageUrl) { image in
//                       DispatchQueue.main.async {
//                           self.foodImage.image = image
//                       }
//                   }
//        }else{
//            DispatchQueue.main.async {
//                self.foodImage.image = emptyImage
//            }
//        }
//        
//        
//    }
//    
//    
//    @IBAction func favoriteBtnAction(_ sender: UIButton) {
//        
//        guard let itemID = SelectedItem?.Item.ItemID , let restaurantId = SelectedItem?.Item.RestaurantID else {return}
//        
//        //   isFavorite = !isFavorite
//        if !isFavorite {
//            SVProgressHUD.show()
//            updateFavoriteStatus(itemId: itemID, restaurantId: restaurantId, isFavorite: isFavorite) { [self] success in
//                if success {
//                    SVProgressHUD.dismiss()
//                    print("Favorite status updated successfully")
//                    reloadCuisineCollectionViewAfterFavActionClosure?()
//                    
//                } else {
//                    SVProgressHUD.dismiss()
//                    print("Failed to update favorite status")
//                    
//                }
//            }
//        }
//        
//        else {
//            
//            SVProgressHUD.show()
//            var userFavoriteItemIdToDelete: String?
//            fetchUserFavouriteItemIdToDelete(restaurantID: restaurantId, itemId: itemID) { (matchingID) in
//                userFavoriteItemIdToDelete = matchingID
//                print("User's favorite restaurant ID To Delete: \(matchingID)")
//                
//                deleteFavoriteItemRecord(userFavoriteItemIdToDelete: userFavoriteItemIdToDelete ?? ""){  [self] success in
//                    if success {
//                        SVProgressHUD.dismiss()
//                        print("Favorite status deleted successfully")
//                        
//                        reloadCuisineCollectionViewAfterFavActionClosure?()
//                    } else {
//                        SVProgressHUD.dismiss()
//                        print("Failed to update favorite status")
//                    }
//                    
//                }
//            }
//            
//            
//        }
//    }
//    
//    func updateFavoriteStatus(itemId: String, restaurantId: String, isFavorite: Bool, completion: @escaping (Bool) -> Void) {
//        let urlString = FavouriteItemURL
//        
//        guard let apiUrl = URL(string: urlString) else {
//            print("Invalid URL: \(urlString)")
//            completion(false)
//            return
//        }
//        guard let loginUserID = loginUserID ,loginUserID != "" else{
//            completion(false)
//            return
//        }
//        var request = URLRequest(url: apiUrl)
//        request.httpMethod = "POST"
//        
//        let requestBody: [String: Any] = [
//        //    "PartitionKey": "UserFavouriteItems",
//            "UserID": loginUserID,
//            "RestaurantID": restaurantId,
//            "ItemID": itemId,
//            "Disabled": false
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
//        } catch {
//            print("Error encoding request body: \(error)")
//            completion(false)
//            return
//        }
//        
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error)")
//                completion(false)
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode == 200 {
//                    print("Favorite status updated successfully")
//                    completion(true)
//                } else {
//                    print("HTTP Status Code: \(httpResponse.statusCode)")
//                    completion(false)
//                }
//            }
//        }.resume()
//    }
//
//}
//
//
//
//  PopularCollectionViewCell.swift
//  mostPolupar
//
//  Created by ToqSoft on 31/10/23.
//

import UIKit
import SVProgressHUD

class PopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var promoteLabel: UILabel!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var placeFamous: UILabel!
    @IBOutlet weak var offerName: UILabel!
    @IBOutlet weak var OfferTitleLbl: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    var isFavorite :Bool = false
    var SelectedItem :ItemCompleteData?
    var reloadCuisineCollectionViewAfterFavActionClosure: (() -> Void)?
    var support = supportFile()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
//        backView.layer.shadowColor = UIColor.black.cgColor
//        backView.layer.shadowOpacity = 0.5 // Adjust this value as needed
//        backView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        backView.layer.shadowRadius = 5
        
        promoteLabel.layer.cornerRadius = 5
        promoteLabel.layer.masksToBounds = true
        OfferTitleLbl.layer.cornerRadius = 5
        OfferTitleLbl.layer.masksToBounds = true
        
        RatingLabel.applyLabelStyle(for: .OfferWhite)
       // RatingLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        ratingView.layer.cornerRadius = 5
        ratingView.layer.masksToBounds = false
        
        heartBtn.layer.cornerRadius = 15
        heartBtn.layer.masksToBounds = true
    }
    
    func setCellUI(){
        starsView.settings.fillMode = .precise
        backView.cellBackViewShadow()
        placeFamous.applyLabelStyle(for: .headingBlack)
        foodName.applyLabelStyle(for: .subTitleLightGray)
        offerName.applyLabelStyle(for: .subTitleLightGray)
        offerName.textColor = UIColor.lightGray
        promoteLabel.applyLabelStyle(for: .promotedLabel)
        OfferTitleLbl.applyLabelStyle(for: .OfferWhite)
    }
    
    func configure(with cuisine : CuisineModel) {
        placeFamous.text = cuisine.cuisineName
        foodName.text = cuisine.description
        offerName.text = cuisine.offerName
        if let image = cuisine.cuisineImage{
            foodImage.image = UIImage(named: image )
        }else{
            foodImage.image = emptyImage
        }
    }

    
    func configure2(with item: ItemCompleteData) {
        // Adjust these properties based on your Item structure
        SelectedItem = item
        placeFamous.text = item.Item.CusineTitle
        foodName.text = item.Item.ItemTitle
        RatingLabel.text = "\(item.itemAverageRating ?? 0.0)(\(item.ItemRatings.count))"
        starsView.text = "(\(item.itemAverageRating ?? 0.0))"
        starsView.rating = item.itemAverageRating ?? 0.0
        if let itemOffer = item.ItemOffer, itemOffer.itemID != "" {
            DispatchQueue.main.async { [self] in
                offerName.text = "\(itemOffer.discount) %"
                OfferTitleLbl.text = itemOffer.offerTitle
                offerName.isHidden = false
                OfferTitleLbl.isHidden = false
               }
           } else {
               DispatchQueue.main.async { [self] in
                   offerName.isHidden = true
                   OfferTitleLbl.isHidden = true
               }
           }
        if let image = item.Item.itemImage{
//            loadImage(from: image) { image  in
//                if let img = image {
//                    DispatchQueue.main.async {
//                        self.foodImage.image = img
//                    }
//                }
//            }
            guard let imageUrl = URL(string: image) else {
                      print("Invalid URL: \(image)")
                      return
                  }
            ImageLoader.shared.loadImage(from: imageUrl) { image in
                       DispatchQueue.main.async {
                           self.foodImage.image = image
                       }
                   }
        }else{
            DispatchQueue.main.async {
                self.foodImage.image = emptyImage
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
                    reloadCuisineCollectionViewAfterFavActionClosure?()
                    
                } else {
                    SVProgressHUD.dismiss()
                    print("Failed to update favorite status")
                    
                }
            }
        }
        
        else {
            
            SVProgressHUD.show()
            var userFavoriteItemIdToDelete: String?
            fetchUserFavouriteItemIdToDelete(restaurantID: restaurantId, itemId: itemID) { (matchingID) in
                userFavoriteItemIdToDelete = matchingID
                print("User's favorite restaurant ID To Delete: \(matchingID)")
                
                deleteFavoriteItemRecord(userFavoriteItemIdToDelete: userFavoriteItemIdToDelete ?? ""){  [self] success in
                    if success {
                        SVProgressHUD.dismiss()
                        print("Favorite status deleted successfully")
                        
                        reloadCuisineCollectionViewAfterFavActionClosure?()
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

}


