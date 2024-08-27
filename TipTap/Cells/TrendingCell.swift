//
//  TrendingCell.swift
//  TIPTABB
//
//  Created by sriram on 31/10/23.
//

import UIKit
import SVProgressHUD
 
class TrendingCell: UICollectionViewCell {
    var isFavorite : Bool = false
    var RestaurantIDArray: [String] = []
    var selectedRestaurant : RestaurantCompleteData?
    var reloadTrendingCVAfterFavActionClosure: (() -> Void)?
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var promoteLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var cellBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
    }
    func  setCellUI(){
        foodNameLabel.applyLabelStyle(for: .headingBlack)
        foodCategoryLabel.applyLabelStyle(for: .subTitleLightGray)
        foodDescriptionLabel.applyLabelStyle(for: .descriptionLightGray)
        
        percentageLabel.applyLabelStyle(for: .subTitleLightGray)
        percentageLabel.textColor = UIColor.lightGray
        
        favoriteButton.layer.cornerRadius = favoriteButton.frame.size.width / 2
        favoriteButton.clipsToBounds = true
        
        RatingLabel.applyLabelStyle(for: .OfferWhite)
        
        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        ratingView.layer.cornerRadius = 5
        ratingView.layer.masksToBounds = false
        
        offerLabel.applyLabelStyle(for: .OfferWhite)
        offerLabel.clipsToBounds = true
        
        promoteLabel.text = "Promoted  "
        promoteLabel.applyLabelStyle(for: .promotedLabel)
        
        cellBackView.cellBackViewShadow()
        
    }
    
    
    
    func configure(with restaurant : RestaurantCompleteData) {
        selectedRestaurant = restaurant
        if let image = restaurant.restaurant.RestaurantImage{
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
        
        foodNameLabel.text = restaurant.restaurant.RestaurantTitle
        foodCategoryLabel.text = restaurant.restaurant.RestaurantCity
        foodDescriptionLabel.text = restaurant.restaurant.RestaurantCategory
        RatingLabel.text = "\(restaurant.restaurantAverageRating ?? 0.0)(\(restaurant.restaurantRatings.count))"
        
        if let restaurantOffer = restaurant.rstaurantOffers, restaurantOffer.offerID != "" {
            DispatchQueue.main.async { [self] in
                percentageLabel.text = "\(restaurantOffer.discount ?? 0) %"
                offerLabel.text = restaurantOffer.offerTitle
                offerLabel.isHidden = false
                percentageLabel.isHidden = false
            }
        } else {
            DispatchQueue.main.async { [self] in
                percentageLabel.isHidden = true
                offerLabel.isHidden = true
            }
        }
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        
            let restaurantID = selectedRestaurant!.restaurant.RestaurantID
            
            //   isFavorite = !isFavorite
            if !isFavorite { //false
                SVProgressHUD.show()
                updateFavoriteStatus(restaurantID: restaurantID ?? "", isFavorite: isFavorite) { [self] success in
                    if success {
                        SVProgressHUD.dismiss()
                        print("Favorite status updated successfully")
//                        DispatchQueue.main.async { [self] in
//                            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                        }
                            reloadTrendingCVAfterFavActionClosure?()
                    } else {
                        SVProgressHUD.dismiss()
                        print("Failed to update favorite status")
                    }
                }
              
            } else {//favourite = true
                SVProgressHUD.show()
                var userFavoriteRestaurantIdToDelete: String?
                fetchUserFavoriteRestaurantIdToDelete(restaurantID: restaurantID ?? "") { (matchingID) in
                    userFavoriteRestaurantIdToDelete = matchingID
                    print("User's favorite restaurant ID To Delete: \(matchingID)")
           
                    deleteFavoriteRecord(userFavoriteRestaurantIdToDelete: userFavoriteRestaurantIdToDelete ?? ""){  [self] success in
                    if success {
                        SVProgressHUD.dismiss()
                        print("Favorite status deleted successfully in Trending cell")
                       
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
            "UserID": loginUserID,  // Replace with the actual loginUserID
            "RestaurantID": restaurantID,
//            "IsFavorite": isFavorite,
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
