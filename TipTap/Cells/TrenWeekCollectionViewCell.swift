//
//  TrenWeekCollectionViewCell.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//

import UIKit
import SVProgressHUD

class TrenWeekCollectionViewCell: UICollectionViewCell {
    var isFavorite : Bool = false
    var disabled = false
    var RestaurantIDArray: [String] = []
    var selectedRestaurant : RestaurantCompleteData?
    var reloadTrendingCVAfterFavActionClosure: (() -> Void)?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var offerTypeLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var dishVerity: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var promotedLabel: UILabel!
    @IBOutlet weak var trendingImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        supportFile().circle(uibtn: heartBtn)
        supportFile().roundLabel(myLabel: offerLabel)
        promotedLabel.layer.cornerRadius = 5.0
        promotedLabel.layer.masksToBounds = true
        offerLabel.layer.cornerRadius = 5.0
        offerLabel.layer.masksToBounds = true
        ratingView.layer.cornerRadius = 5.0
        ratingView.layer.masksToBounds = true
        setCellUI()
    }
    func setCellUI(){
        hotelName.applyLabelStyle(for: .headingBlack)
        dishVerity.applyLabelStyle(for: .subTitleLightGray)
        extraLabel.applyLabelStyle(for: .descriptionLightGray)
        offerTypeLabel.applyLabelStyle(for: .descriptionLightGray)
        ratingLabel.applyLabelStyle(for: .OfferWhite)
        offerLabel.applyLabelStyle(for: .OfferWhite)
        promotedLabel.applyLabelStyle(for: .promotedLabel)
        backView.cellBackViewShadow()
    }
    func configure(restaurantFiltered : RestaurantCompleteData){
        selectedRestaurant = restaurantFiltered
        
        if let image = restaurantFiltered.restaurant.RestaurantImage{

            guard let imageUrl = URL(string: image) else {
                      print("Invalid URL: \(image)")
                      return
                  }
            ImageLoader.shared.loadImage(from: imageUrl) { image in
                       DispatchQueue.main.async {
                           self.trendingImage.image = image
                       }
                   }

        }else{
            DispatchQueue.main.async {
                self.trendingImage.image = emptyImage
            }
        }
        
        if let offerTitle = restaurantFiltered.rstaurantOffers?.offerTitle, !offerTitle.isEmpty {
            self.offerLabel.isHidden = false
            self.offerTypeLabel.isHidden = false
            self.offerLabel.text = offerTitle
            self.offerTypeLabel.text = "\(restaurantFiltered.rstaurantOffers?.discount ?? 0)"
        } else {
            self.offerLabel.isHidden = true
            self.offerTypeLabel.isHidden = true
        }
        
        self.dishVerity.text = restaurantFiltered.restaurant.RestaurantCategory
        self.hotelName.text = restaurantFiltered.restaurant.RestaurantTitle
        self.extraLabel.text = restaurantFiltered.restaurant.RestaurantAddress
        self.ratingLabel.text = "\(restaurantFiltered.restaurantAverageRating ?? 0.0) (\(restaurantFiltered.restaurantRatings.count))"
        
        
    }
    @IBAction func favButtonAction(_ sender: UIButton) {
        SVProgressHUD.show()
        let restaurantID = selectedRestaurant!.restaurant.RestaurantID
        //   isFavorite = !isFavorite
        if !isFavorite {
            updateFavoriteStatus(restaurantID: restaurantID ?? "", isFavorite: isFavorite) { success in
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

            
            
            SVProgressHUD.show()
            var userFavoriteRestaurantIdToDelete: String?
            fetchUserFavoriteRestaurantIdToDelete(restaurantID: restaurantID ?? "" ) { (matchingID) in
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


    
}
