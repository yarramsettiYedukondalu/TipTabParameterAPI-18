
import UIKit
import SVProgressHUD

class SignatureDishesListViewCVC: UICollectionViewCell {
    var SelectedItem : ItemCompleteData?
    var isFavorite : Bool  = false
    
    var reloadDishesCVAfterFavActionClosure: (() -> Void)?
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var promotedLabel: UILabel!
    @IBOutlet weak var offerName: UILabel!
    @IBOutlet weak var itemSubdescription: UILabel!
    @IBOutlet weak var offerTitile: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        ItemName.applyLabelStyle(for: .headingBlack)
        itemDescription.applyLabelStyle(for: .subTitleLightGray)
        itemSubdescription.applyLabelStyle(for: .subTitleLightGray)
        //subdescriptionLabel.applyLabelStyle(for: .descriptionLightGray)
        ratingLabel.applyLabelStyle(for: .OfferWhite)
        promotedLabel.applyLabelStyle(for: .promotedLabel)
        offerTitile.applyLabelStyle(for: .OfferWhite)
  
        offerTitile.layer.cornerRadius = 5
        offerTitile.layer.masksToBounds = true
        offerTitile.backgroundColor = UIColor(red: 102/245, green: 153/245, blue: 0/245, alpha: 1)
        offerName.applyLabelStyle(for: .descriptionLightGray)
        setCellUI()
    }
    func setCellUI(){
        starsView.settings.fillMode = .precise
        backView.cellBackViewShadow()
        
    }
    func configure(cuisines :ItemCompleteData){
        SelectedItem = cuisines
        if let cuisineOffer = cuisines.ItemOffer, cuisineOffer.itemID != "" {
            DispatchQueue.main.async { [self] in
                offerName.text = "\(cuisineOffer.discount) %"
                offerTitile.text = cuisineOffer.offerTitle
                offerName.isHidden = false
                offerTitile.isHidden = false
               }
           } else {
               DispatchQueue.main.async { [self] in
                   offerName.isHidden = true
                   offerTitile.isHidden = true
               }
           }

        ItemName.text = cuisines.Item.CusineTitle
        itemDescription.text = cuisines.Item.Description
        ratingLabel.text = "\(cuisines.itemAverageRating ?? 0.0)(\(cuisines.ItemRatings.count))"
        starsView.text = "(\(cuisines.itemAverageRating ?? 0.0))"
        starsView.rating = cuisines.itemAverageRating ?? 0.0
        if let cuisineImage = cuisines.Item.itemImage {
            loadImage(from: cuisineImage) { image  in
                if let img = image {
                    DispatchQueue.main.async { [self] in
                        itemImage.image = img
                    }
                }
            }
        }else{
            DispatchQueue.main.async { [self] in
                itemImage.image = emptyImage
            }
        }
    }
    func configureItem(dishes :ItemCompleteData){
        SelectedItem = dishes
        if let cuisineOffer = dishes.ItemOffer, cuisineOffer.itemID != "" {
            DispatchQueue.main.async { [self] in
                offerName.text = "\(cuisineOffer.discount) %"
                offerTitile.text = cuisineOffer.offerTitle
                offerName.isHidden = false
                offerTitile.isHidden = false
               }
           } else {
               DispatchQueue.main.async { [self] in
                   offerName.isHidden = true
                   offerTitile.isHidden = true
               }
           }

        ItemName.text = dishes.Item.ItemTitle
        itemDescription.text = dishes.Item.Description
        itemSubdescription.text = "Cuisine: \(String(describing: dishes.Item.CusineTitle))"
        ratingLabel.text = "\(dishes.itemAverageRating ?? 0.0)(\(dishes.ItemRatings.count))"
        starsView.text = "(\(dishes.itemAverageRating ?? 0.0))"
        starsView.rating = dishes.itemAverageRating ?? 0.0
        if  let cuisineImage = dishes.Item.itemImage{
//            loadImage(from: cuisineImage) { image  in
//                if let img = image {
//                    DispatchQueue.main.async { [self] in
//                        itemImage.image = img
//                    }
//                }
//            }
            guard let imageUrl = URL(string: cuisineImage) else {
                      print("Invalid URL: \(cuisineImage)")
                      return
                  }
            ImageLoader.shared.loadImage(from: imageUrl) { image in
                       DispatchQueue.main.async {
                           self.itemImage.image = image
                       }
                   }
        }else{
            DispatchQueue.main.async { [self] in
                itemImage.image = emptyImage
            }
        }
    }
    @IBAction func favouriteBtnAction(_ sender: UIButton) {
        SVProgressHUD.show()
        guard let itemID = SelectedItem?.Item.ItemID , let restaurantId = SelectedItem?.Item.RestaurantID else {return}
        
        //   isFavorite = !isFavorite
        if !isFavorite {
            updateFavoriteStatus(itemId: itemID, restaurantId: restaurantId, isFavorite: isFavorite) { [self] success in
                if success {
                    print("Favorite status updated successfully")
                    DispatchQueue.main.async { [self] in
                        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                    reloadDishesCVAfterFavActionClosure?()
                } else {
                    print("Failed to update favorite status")
                }
            }
            SVProgressHUD.dismiss()
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



}
