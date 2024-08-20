//
//  ListViewCollectionViewCell.swift
//  TipTap
//
//  Created by sriram on 08/11/23.
//

import UIKit
import SVProgressHUD

class ListViewCollectionViewCell: UICollectionViewCell {
    var isFavorite : Bool = false
    var disabled = false
    var RestaurantIDArray: [String] = []
    var selectedRestaurant : RestaurantCompleteData?
    var reloadTrendingCVAfterFavActionClosure: (() -> Void)?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var listViewImage: UIImageView!
    
    @IBOutlet weak var hotelNameLabel: UILabel!
    
    @IBOutlet weak var ratingLabelAG: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var descrictionLabel: UILabel!
    @IBOutlet weak var veraityLabel: UILabel!
    
    @IBOutlet weak var ratingsLAbel2: UIView!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var promatedLabel: UILabel!
    @IBOutlet weak var offerTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        supportFile().roundLabel(myLabel: offerLabel)
        promatedLabel.layer.cornerRadius = 5.0
        promatedLabel.layer.masksToBounds = true
        offerLabel.layer.cornerRadius = 5.0
        offerLabel.layer.masksToBounds = true
        ratingsLAbel2.layer.cornerRadius = 5.0
        ratingsLAbel2.layer.masksToBounds = true
        setCellUI()
    }
    func setCellUI(){
        hotelNameLabel.applyLabelStyle(for: .headingBlack)
        veraityLabel.applyLabelStyle(for: .subTitleLightGray)
        descrictionLabel.applyLabelStyle(for: .descriptionLightGray)
        offerTypeLabel.applyLabelStyle(for: .descriptionLightGray)
        ratingLabelAG.applyLabelStyle(for: .OfferWhite)
        offerLabel.applyLabelStyle(for: .OfferWhite)
        promatedLabel.applyLabelStyle(for: .promotedLabel)
        backView.cellBackViewShadow()
        
    }
    func configure(restaurant: RestaurantCompleteData){
        selectedRestaurant = restaurant
        if let image = restaurant.restaurant.RestaurantImage{
//            loadImage(from: image) { image in
//                if let img = image {
//                    DispatchQueue.main.async {
//                        self.listViewImage.image = img
//                    }
//                }
//            }
            guard let imageUrl = URL(string: image) else {
                      print("Invalid URL: \(image)")
                      return
                  }
            ImageLoader.shared.loadImage(from: imageUrl) { image in
                       DispatchQueue.main.async {
                           self.listViewImage.image = image
                       }
                   }
        }else{
            DispatchQueue.main.async {
                self.listViewImage.image = emptyImage
            }
        }
        
        
        if let offerTitle = restaurant.rstaurantOffers?.offerTitle, !offerTitle.isEmpty {
           offerLabel.isHidden = false
            offerTypeLabel.isHidden = false
            offerLabel.text = offerTitle
            offerTypeLabel.text = "\(restaurant.rstaurantOffers?.discount ?? 0)"
        } else {
            offerLabel.isHidden = true
            offerTypeLabel.isHidden = true
        }
        
        veraityLabel.text = restaurant.restaurant.RestaurantCategory
        hotelNameLabel.text = restaurant.restaurant.RestaurantTitle
        descrictionLabel.text = restaurant.restaurant.RestaurantAddress
        ratingLabelAG.text = "\(restaurant.restaurantAverageRating ?? 0.0) (\(restaurant.restaurantRatings.count))"
    }
    
    @IBAction func favouriteBtnAction(_ sender: UIButton) {
        SVProgressHUD.show()

        guard  let restaurantID = selectedRestaurant!.restaurant.RestaurantID else {
            return
        }
        //   isFavorite = !isFavorite
        if !isFavorite {
            updateFavoriteStatus(restaurantID: restaurantID, isFavorite: isFavorite) { success in
                if success {
                    print("Favorite status updated successfully")
                    DispatchQueue.main.async { [self] in
                        heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                    self.reloadTrendingCVAfterFavActionClosure?()
                } else {
                    print("Failed to update favorite status")
                }
            }
            SVProgressHUD.dismiss()
        } else {
            //            deleteFavoriteRecord(restaurantID: restaurantID){ success in
            //                if success {
            //                    print("Favorite status deleted successfully")
            //                    DispatchQueue.main.async { [self] in
            //                        heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            //                    }
            //
            //                    self.reloadTrendingCVAfterFavActionClosure?()
            //                } else {
            //                    print("Failed to delete favorite status")
            //                   
            //                    // Handle failure case, if needed
            //                }
            //            }
            //            SVProgressHUD.dismiss()
            //        }
            //        
            //        
            
            SVProgressHUD.show()
            var userFavoriteRestaurantIdToDelete: String?
            fetchUserFavoriteRestaurantIdToDelete(restaurantID: restaurantID ) { (matchingID) in
                userFavoriteRestaurantIdToDelete = matchingID
                print("User's favorite restaurant ID To Delete: \(matchingID)")
                
                deleteFavoriteRecord(userFavoriteRestaurantIdToDelete: userFavoriteRestaurantIdToDelete ?? ""){  [self] success in
                    if success {
                        SVProgressHUD.dismiss()
                        print("Favorite status deleted successfully")
                        
                        reloadTrendingCVAfterFavActionClosure?()
                    } else {
                        SVProgressHUD.dismiss()
                        print("Failed to update favorite status")
                    }
                    
                }
            }
            
            
        }
    }
    func updateFavoriteStatus(restaurantID: String, isFavorite: Bool, completion: @escaping (Bool) -> Void) {
        let urlString = FavRestaurantURL
        
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
            "RestaurantID": restaurantID,
            "IsFavorite": isFavorite,
            "disabled": false
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
                    
                    if isFavorite {
                        self.RestaurantIDArray.append(restaurantID)
                    } else {
                        self.RestaurantIDArray.removeAll { $0 == restaurantID }
                    }
                    
                    completion(true)
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    completion(false)
                }
            }
        }.resume()
    }

//    func deleteFavoriteRecord(restaurantID: String, completion: @escaping (Bool) -> Void) {
//        let matchingIDs = JsonDataArrays.UserFavoriteRestauranArray
//            .filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID }
//            .map { $0.UserFavoriteRestaurantID }
//        guard matchingIDs.count > 0 else {
//            return
//        }
//        let deleteUrlString = FavRestaurantURL
//                
//        guard let deleteApiUrl = URL(string: deleteUrlString) else {
//            print("Invalid URL: \(deleteUrlString)")
//            completion(false)
//            return
//        }
//        
//        
//        
//        var request = URLRequest(url: deleteApiUrl)
//        request.httpMethod = "DELETE"
//        
//        let requestBody: [String: Any] = [
//            "rowKey": matchingIDs[0] ?? "",
//            "partitionKey": "UserFavRes"
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
//        
//        
//        
//    }

    
}
