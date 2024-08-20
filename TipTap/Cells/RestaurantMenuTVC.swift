////
////  RestaurantMenuTVC.swift
////  TipTap
////
////  Created by sriram on 09/11/23.
////
//
// 
//import UIKit
// 
//protocol putFavorite:AnyObject{
//    func favoriteBtnState(cell:RestaurantMenuTVC)
//}
// 
// 
//class RestaurantMenuTVC: UITableViewCell {
//    var delegate : putFavorite?
//    @IBOutlet weak var cellview: UIView!
//    @IBOutlet weak var ratingView: UIView!
//    var isFavorite :Bool = false
//    @IBOutlet weak var RatingLabel: UILabel!
//    @IBOutlet weak var favoriteBtn: UIButton!
//    @IBOutlet weak var promotedLAbel: UILabel!
//    @IBOutlet weak var OfferNameLabel: UILabel!
//    @IBOutlet weak var OfferTitlelabel: UILabel!
//    @IBOutlet weak var estimatedTimeLabel: UILabel!
//    @IBOutlet weak var ItemImgView: UIImageView!
//    @IBOutlet weak var RestuarantNameLabel: UILabel!
//    @IBOutlet weak var resturantDescriptnLabl: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
// 
//    }
// 
// 
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
//    
//    @IBAction func favButtonAct(_ sender: Any) {
//        self.delegate?.favoriteBtnState(cell: self)
//    }
//    func configure(with item :ItemCompleteData) {
//        if let image = item.Item.itemImage{
//
//            guard let imageUrl = URL(string: image) else {
//                      print("Invalid URL: \(image)")
//                      return
//                  }
//            ImageLoader.shared.loadImage(from: imageUrl) { image in
//                       DispatchQueue.main.async {
//                           self.ItemImgView.image = image
//                       }
//                   }
//        }else{
//            DispatchQueue.main.async {
//                self.ItemImgView.image = emptyImage
//            }
//        }
//        
//        RestuarantNameLabel.applyLabelStyle(for: .headingBlack)
//        RestuarantNameLabel.text = item.Item.ItemTitle
//        resturantDescriptnLabl.text = item.Item.Description
//        estimatedTimeLabel.text = item.Item.CusineTitle
//        if let offerItem = item.ItemOffer {
//            OfferNameLabel.text = "\(offerItem.discount )"
//            OfferTitlelabel.text = offerItem.offerTitle
//        } else {
//            OfferNameLabel.isHidden = true
//            OfferTitlelabel.isHidden = true
//        }
//        
//        RatingLabel.text = "\(item.itemAverageRating ?? 0.0)(\(item.ItemRatings.count))"
////        if !loginuserFavouriteItemArray.isEmpty{
////            if let ItemID = dishcomplete.Item.ItemID {
////                if loginuserFavouriteItemArray.contains(where: { $0.Item.ItemID == ItemID }){
////                    salesCell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
////                    salesCell.isFavorite = true
////                }else{
////                    salesCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
////                    salesCell.isFavorite = false
////                }
////            }
////        } 
//      setcellUI()
//        //cellview.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
//        
//    }
//    func configureRestaurant(with restuarant :RestaurantCompleteData) {
//        if let image = restuarant.restaurant.RestaurantImage{
//            loadImage(from: image) { image  in
//                if let img = image {
//                    DispatchQueue.main.async {
//                        self.ItemImgView.image = img
//                    }
//                }
//            }
//        }else{
//            DispatchQueue.main.async {
//                self.ItemImgView.image = emptyImage
//            }
//        }
//        RestuarantNameLabel.text = restuarant.restaurant.RestaurantTitle
//        OfferTitlelabel.text = restuarant.rstaurantOffers?.offerTitle
//        resturantDescriptnLabl.text = restuarant.restaurant.RestaurantCategory
//        estimatedTimeLabel.text = restuarant.restaurant.RestaurantAddress
//        RatingLabel.text = "\(restuarant.restaurantAverageRating ?? 0.0) (\(restuarant.restaurantRatings.count))"
//        OfferNameLabel.text = "\(restuarant.rstaurantOffers?.discount ?? 0)"
//        
//      setcellUI()
//        //cellview.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
//        
//    }
//    func setcellUI(){
//        estimatedTimeLabel.applyLabelStyle(for: .subTitleLightGray)
//        estimatedTimeLabel.applyLabelStyle(for: .subTitleLightGray)
//        resturantDescriptnLabl.applyLabelStyle(for: .subTitleLightGray)
//        OfferTitlelabel.applyLabelStyle(for: .OfferWhite)
//     
//        OfferTitlelabel.layer.cornerRadius = 5
//        OfferTitlelabel.layer.masksToBounds = true
//        OfferTitlelabel.backgroundColor = #colorLiteral(red: 0.4, green: 0.6, blue: 0, alpha: 1)
//  
//        OfferNameLabel.applyLabelStyle(for: .subTitleLightGray)
//     
//        OfferNameLabel.textColor = UIColor.lightGray
//        
//        favoriteBtn.layer.cornerRadius = 15
//        
//        RatingLabel.applyLabelStyle(for: .OfferWhite)
//        
////        RatingLabel.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
//        
//        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
//        ratingView.layer.cornerRadius = 5
//        ratingView.layer.masksToBounds = false
//        
//        promotedLAbel.applyLabelStyle(for: .promotedLabel)
//        
//        // Set up the shadow properties
//        cellview.layer.backgroundColor = UIColor.white.cgColor
//        cellview.layer.cornerRadius = 5 // You can adjust this value as needed
//        cellview.layer.borderWidth = 1
//        cellview.layer.borderColor = UIColor.clear.cgColor
//        cellview.layer.shadowColor = UIColor.lightGray.cgColor
//        cellview.layer.shadowOffset = CGSize(width: 5, height: 5)
//        cellview.layer.shadowRadius = 4
//        cellview.layer.shadowOpacity = 3
//        cellview.layer.masksToBounds = false
//    }
//}
// 
//
//  RestaurantMenuTVC.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//

 
import UIKit
 import SVProgressHUD
 
 
 
class RestaurantMenuTVC: UITableViewCell {
    
    var isFavorite : Bool = false
    var forRestaurant : Bool = true
    var restaurantData : RestaurantCompleteData?
    var itemData : ItemCompleteData?
    var reloadDataAfterFavActionClosure: (() -> Void)?
    @IBOutlet weak var cellview: UIView!
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var promotedLAbel: UILabel!
    @IBOutlet weak var OfferNameLabel: UILabel!
    @IBOutlet weak var OfferTitlelabel: UILabel!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var ItemImgView: UIImageView!
    @IBOutlet weak var RestuarantNameLabel: UILabel!
    @IBOutlet weak var resturantDescriptnLabl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with item :ItemCompleteData) {
        self.itemData = item
        if let image = item.Item.itemImage{
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
        
        RestuarantNameLabel.applyLabelStyle(for: .headingBlack)
        RestuarantNameLabel.text = item.Item.ItemTitle
        resturantDescriptnLabl.text = item.Item.Description
        estimatedTimeLabel.text = item.Item.CusineTitle
        if let offerItem = item.ItemOffer {
            OfferNameLabel.text = "\(offerItem.discount )"
            OfferTitlelabel.text = offerItem.offerTitle
        } else {
            OfferNameLabel.isHidden = true
            OfferTitlelabel.isHidden = true
        }
        
        RatingLabel.text = "\(item.itemAverageRating ?? 0.0)(\(item.ItemRatings.count))"

      setcellUI()
        //cellview.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
    }
    
    func configureRestaurant(with restuarant :RestaurantCompleteData) {
        self.restaurantData = restuarant
        if let image = restuarant.restaurant.RestaurantImage{
            loadImage(from: image) { image  in
                if let img = image {
                    DispatchQueue.main.async {
                        self.ItemImgView.image = img
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                self.ItemImgView.image = emptyImage
            }
        }
        RestuarantNameLabel.text = restuarant.restaurant.RestaurantTitle
        OfferTitlelabel.text = restuarant.rstaurantOffers?.offerTitle
        resturantDescriptnLabl.text = restuarant.restaurant.RestaurantCategory
        estimatedTimeLabel.text = restuarant.restaurant.RestaurantAddress
        RatingLabel.text = "\(restuarant.restaurantAverageRating ?? 0.0) (\(restuarant.restaurantRatings.count))"
        OfferNameLabel.text = "\(restuarant.rstaurantOffers?.discount ?? 0)"
        
      setcellUI()
        //cellview.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func setcellUI(){
        estimatedTimeLabel.applyLabelStyle(for: .subTitleLightGray)
        estimatedTimeLabel.applyLabelStyle(for: .subTitleLightGray)
        resturantDescriptnLabl.applyLabelStyle(for: .subTitleLightGray)
        OfferTitlelabel.applyLabelStyle(for: .OfferWhite)
     
        OfferTitlelabel.layer.cornerRadius = 5
        OfferTitlelabel.layer.masksToBounds = true
        OfferTitlelabel.backgroundColor = #colorLiteral(red: 0.4, green: 0.6, blue: 0, alpha: 1)
  
        OfferNameLabel.applyLabelStyle(for: .subTitleLightGray)
     
        OfferNameLabel.textColor = UIColor.lightGray
        
        favoriteBtn.layer.cornerRadius = 15
        
        RatingLabel.applyLabelStyle(for: .OfferWhite)
        
//        RatingLabel.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        
        ratingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        ratingView.layer.cornerRadius = 5
        ratingView.layer.masksToBounds = false
        
        promotedLAbel.applyLabelStyle(for: .promotedLabel)
        
        // Set up the shadow properties
        cellview.layer.backgroundColor = UIColor.white.cgColor
        cellview.layer.cornerRadius = 5 // You can adjust this value as needed
        cellview.layer.borderWidth = 1
        cellview.layer.borderColor = UIColor.clear.cgColor
        cellview.layer.shadowColor = UIColor.lightGray.cgColor
        cellview.layer.shadowOffset = CGSize(width: 5, height: 5)
        cellview.layer.shadowRadius = 4
        cellview.layer.shadowOpacity = 3
        cellview.layer.masksToBounds = false
    }
    @IBAction func favButtonAct(_ sender: Any) {
        if forRestaurant {
            AddRemoveFavouriteRestaurant()
        }else{
            AddRemoveFavouriteItems()
        }
       }
  
    func AddRemoveFavouriteRestaurant(){
        
        if let restaurantData = restaurantData{
            let restaurantID = restaurantData.restaurant.RestaurantID
            
            //   isFavorite = !isFavorite
            if !isFavorite { //false
                SVProgressHUD.show()
                updateFavoriteStatus(restaurantID: restaurantID ?? "", isFavorite: isFavorite) { [self] success in
                    if success {
                        SVProgressHUD.dismiss()
                        print("Favorite status updated successfully")
                       
                        self.reloadDataAfterFavActionClosure?()
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
                            
                            reloadDataAfterFavActionClosure?()
                        } else {
                            SVProgressHUD.dismiss()
                            print("Failed to update favorite status")
                        }
                        
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
//                    if isFavorite {
//                        self.RestaurantIDArray.append(restaurantID)
//                    } else {
//                        self.RestaurantIDArray.removeAll { $0 == restaurantID }
//                    }
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    completion(false)
                }
            }
        }.resume()
    }
    
    func AddRemoveFavouriteItems(){
        SVProgressHUD.show()
        guard let itemID = itemData?.Item.ItemID , let restaurantId = itemData?.Item.RestaurantID else {return}
        
        //   isFavorite = !isFavorite
        if !isFavorite {
            updateFavoriteStatus(itemId: itemID, restaurantId: restaurantId, isFavorite: isFavorite) { [self] success in
                if success {
                    print("Favorite status updated successfully")
                    DispatchQueue.main.async { [self] in
                        favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                    reloadDataAfterFavActionClosure?()
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
                         
                         reloadDataAfterFavActionClosure?()
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


 
