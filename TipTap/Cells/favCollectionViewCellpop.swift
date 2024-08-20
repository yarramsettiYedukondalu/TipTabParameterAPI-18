////
////  favCollectionViewCellpop.swift
////  TipTap
////
////  Created by sriram on 09/11/23.
////
//
//import UIKit
//import SVProgressHUD
//
//class favCollectionViewCellpop: UICollectionViewCell {
//    var favoriteItem :ItemCompleteData?
//    var favoriteRestaurant : RestaurantCompleteData?
//    var reloadAfterFavActionClosure: (() -> Void)?
//    var isFavourite : Bool = false
//    @IBOutlet weak var backView: UIView!
//    @IBOutlet weak var promotedLabel: UILabel!
//    @IBOutlet weak var retingView: UIView!
//    @IBOutlet weak var offertypeLabel: UILabel!
//    @IBOutlet weak var offerLabel: UILabel!
//    @IBOutlet weak var descriLabels: UILabel!
//    @IBOutlet weak var dishNames: UILabel!
//    @IBOutlet weak var restaruntName: UILabel!
//    @IBOutlet weak var favResImage: UIImageView!
//    @IBOutlet weak var ratingLabel: UILabel!
//
//    @IBOutlet weak var favouriteButton: UIButton!
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setCellUI()
//
//    }
//    func setCellUI(){
//       
//        restaruntName.applyLabelStyle(for: .headingBlack)
//        dishNames.applyLabelStyle(for: .subTitleLightGray)
//        descriLabels.applyLabelStyle(for: .descriptionLightGray)
//        offertypeLabel.applyLabelStyle(for: .subTitleLightGray)
//        ratingLabel.applyLabelStyle(for: .OfferWhite)
//        retingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
//        retingView.layer.cornerRadius = 5
//        retingView.layer.masksToBounds = false
//        offerLabel.applyLabelStyle(for: .OfferWhite)
//        offerLabel.clipsToBounds = true
//        promotedLabel.applyLabelStyle(for: .promotedLabel)
//        backView.cellBackViewShadow()
//    
//    }
//    
//    
//    func updateFavoriteStatus(restaurantID: String, isFavorite: Bool, completion: @escaping (Bool) -> Void) {
//        let urlString = FavRestaurantURL
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
//            "UserID": loginUserID,  // Replace with the actual loginUserID
//            "RestaurantID": restaurantID,
////            "IsFavorite": isFavorite,
//            "disabled": false
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
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode == 200 {
//                    print("Favorite status updated successfully")
//                    completion(true)
////                    if isFavorite {
////                        self.RestaurantIDArray.append(restaurantID)
////                    } else {
////                        self.RestaurantIDArray.removeAll { $0 == restaurantID }
////                    }
//                } else {
//                    print("HTTP Status Code: \(httpResponse.statusCode)")
//                    completion(false)
//                }
//            }
//        }.resume()
//    }
//    
//    @IBAction func FavbuttonAction(_ sender: UIButton) {
//        
//        let restaurantID = favoriteRestaurant!.restaurant.RestaurantID
//        
//        //   isFavorite = !isFavorite
//        if !isFavourite { //false
//            SVProgressHUD.show()
//            updateFavoriteStatus(restaurantID: restaurantID ?? "", isFavorite: isFavourite) { [self] success in
//                if success {
//                    SVProgressHUD.dismiss()
//                    print("Favorite status updated successfully")
//                    //                        DispatchQueue.main.async { [self] in
//                    //                            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                    //                        }
//                    reloadAfterFavActionClosure?()
//                } else {
//                    SVProgressHUD.dismiss()
//                    print("Failed to update favorite status")
//                }
//            }
//            
//        } else {//favourite = true
//            SVProgressHUD.show()
//            var userFavoriteRestaurantIdToDelete: String?
//            fetchUserFavoriteRestaurantIdToDelete(restaurantID: restaurantID ?? "") { (matchingID) in
//                userFavoriteRestaurantIdToDelete = matchingID
//                print("User's favorite restaurant ID To Delete: \(matchingID)")
//                
//                deleteFavoriteRecord(userFavoriteRestaurantIdToDelete: userFavoriteRestaurantIdToDelete ?? ""){  [self] success in
//                    if success {
//                        SVProgressHUD.dismiss()
//                        print("Favorite status deleted successfully in Trending cell")
//                        
//                        reloadAfterFavActionClosure?()
//                    } else {
//                        SVProgressHUD.dismiss()
//                        print("Failed to update favorite status")
//                    }
//                    
//                }
//            }
//        }
//    }
//        
//      
////        if (favoriteRestaurant != nil){
////            deleteFavoriteRestaurantRecord(restaurantID: (favoriteRestaurant?.restaurant.RestaurantID)!){  [self] success in
////                if success {
////                    print(" \(favoriteRestaurant?.restaurant.RestaurantTitle ?? "") removed from your fav list")
////                    
////                    reloadAfterFavActionClosure?()             
////                } else {
////                    print("Failed to update favorite status")
////                }
////                
////            }
////        }
////        else{
////            deleteFavoriteItemRecord( restaurantID: (favoriteItem?.Item.RestaurantID)!, itemId: (favoriteItem?.Item.ItemID)!) {[self] success in
////                if success {
////                    print(" \(favoriteItem?.Item.ItemTitle ?? "") removed from your fav list")
////
////                    reloadAfterFavActionClosure?()
////                } else {
////                    print("Failed to delete favorite status")
////                   
////                    // Handle failure case, if needed
////                }
////
////            }
////        }
//    }
//    func deleteFavoriteItemRecord(restaurantID: String,itemId: String, completion: @escaping (Bool) -> Void) {
//        
//        let matchingIDs = JsonDataArrays.userFavouriteItemsArray
//            .filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID && $0.ItemID == itemId }
//            .map { $0.UserFavouriteItemID }
//        
//        guard !matchingIDs.isEmpty else {
//            completion(false)
//            return
//        }
//        let deleteUrlString = FavRestaurantURL + "\(matchingIDs[0] ?? "")"
//        
//        
//        guard let deleteApiUrl = URL(string: deleteUrlString) else {
//            print("Invalid URL: \(deleteUrlString)")
//            return
//        }
//        
//        var deleteRequest = URLRequest(url: deleteApiUrl)
//        deleteRequest.httpMethod = "DELETE"
//        
//        URLSession.shared.dataTask(with: deleteRequest) { (data, response, error) in
//            print("Actual HTTP Method: \(deleteRequest.httpMethod ?? "Unknown")")
//
//            if let error = error {
//                print("Error deleting record: \(error)")
//                completion(false)
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode == 200 {
//                    print("Favorite record deleted successfully")
//                    completion(true)
//                } else {
//                    print("HTTP Status Code: \(httpResponse.statusCode)")
//                    completion(false)
//                }
//            }
//        }.resume()
//    }
//    func deleteFavoriteRestaurantRecord(restaurantID: String, completion: @escaping (Bool) -> Void) {
//        
//       
//        let matchingIDs = JsonDataArrays.UserFavoriteRestauranArray
//            .filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID }
//            .map { $0.UserFavoriteRestaurantID }
//        
//        guard matchingIDs.count > 0 else {
//            return
//        }
//        let deleteUrlString = FavRestaurantURL + "\(matchingIDs[0] ?? "")"
//        
//   //https://favrestaurant.azurewebsites.net/api/userFavouriteRestaurant/UserFavRes/8d82d068-120c-4294-bf49-9f9cf3151498
//        
//        
//        
//        guard let deleteApiUrl = URL(string: deleteUrlString) else {
//            print("Invalid URL: \(deleteUrlString)")
//            completion(false)
//            return
//        }
//        
//        var deleteRequest = URLRequest(url: deleteApiUrl)
//        deleteRequest.httpMethod = "DELETE"
//        
//        URLSession.shared.dataTask(with: deleteRequest) { (data, response, error) in
//            print("Actual HTTP Method: \(deleteRequest.httpMethod ?? "Unknown")")
//
//            if let error = error {
//                print("Error deleting record: \(error)")
//                completion(false)
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode == 200 {
//                    print("Favorite record deleted successfully")
//                    completion(true)
//                } else {
//                    print("HTTP Status Code: \(httpResponse.statusCode)")
//                    completion(false)
//                }
//            }
//        }.resume()
//    }
//
//
// /*
// import UIKit
//
// class favCollectionViewCellpop: UICollectionViewCell {
//     var favoriteItem :ItemCompleteData?
//     var favoriteRestaurant : RestaurantCompleteData?
//     var reloadAfterFavActionClosure: (() -> Void)?
//     @IBOutlet weak var backView: UIView!
//     @IBOutlet weak var promotedLabel: UILabel!
//     @IBOutlet weak var retingView: UIView!
//     @IBOutlet weak var offertypeLabel: UILabel!
//     @IBOutlet weak var offerLabel: UILabel!
//     @IBOutlet weak var descriLabels: UILabel!
//     @IBOutlet weak var dishNames: UILabel!
//     @IBOutlet weak var restaruntName: UILabel!
//     @IBOutlet weak var favResImage: UIImageView!
//     @IBOutlet weak var ratingLabel: UILabel!
//
//     @IBOutlet weak var favouriteButton: UIButton!
//     override func awakeFromNib() {
//         super.awakeFromNib()
//         setCellUI()
//
//     }
//     func setCellUI(){
//        
//         restaruntName.applyLabelStyle(for: .headingBlack)
//         dishNames.applyLabelStyle(for: .subTitleLightGray)
//         descriLabels.applyLabelStyle(for: .descriptionLightGray)
//         offertypeLabel.applyLabelStyle(for: .subTitleLightGray)
//         ratingLabel.applyLabelStyle(for: .OfferWhite)
//         retingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
//         retingView.layer.cornerRadius = 5
//         retingView.layer.masksToBounds = false
//         offerLabel.applyLabelStyle(for: .OfferWhite)
//         offerLabel.clipsToBounds = true
//         promotedLabel.applyLabelStyle(for: .promotedLabel)
//         backView.cellBackViewShadow()
//     
//     }
//     @IBAction func FavbuttonAction(_ sender: UIButton) {
//         if (favoriteRestaurant != nil){
//             deleteFavoriteRestaurantRecord(restaurantID: (favoriteRestaurant?.restaurant.RestaurantID)!){  [self] success in
//                 if success {
//                     print(" \(favoriteRestaurant?.restaurant.RestaurantTitle ?? "") removed from your fav list")
//                     
//                     reloadAfterFavActionClosure?()
//                 } else {
//                     print("Failed to update favorite status")
//                 }
//                 
//             }
//         }
//         else{
//             deleteFavoriteItemRecord( restaurantID: (favoriteItem?.Item.RestaurantID)!, itemId: (favoriteItem?.Item.ItemID)!) {[self] success in
//                 if success {
//                     print(" \(favoriteItem?.Item.ItemTitle ?? "") removed from your fav list")
//
//                     reloadAfterFavActionClosure?()
//                 } else {
//                     print("Failed to delete favorite status")
//                    
//                     // Handle failure case, if needed
//                 }
//
//             }
//         }
//     }
//     func deleteFavoriteItemRecord(restaurantID: String,itemId: String, completion: @escaping (Bool) -> Void) {
//         
//         let matchingIDs = JsonDataArrays.userFavouriteItemsArray
//             .filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID && $0.ItemID == itemId }
//             .map { $0.UserFavouriteItemID }
//         
//         guard !matchingIDs.isEmpty else {
//             completion(false)
//             return
//         }
//         let deleteUrlString = "https://favouriteitem.azurewebsites.net/api/UserFavouriteItems/UserFavouriteItems/\(matchingIDs[0] ?? "")"
//         
//         
//         guard let deleteApiUrl = URL(string: deleteUrlString) else {
//             print("Invalid URL: \(deleteUrlString)")
//             return
//         }
//         
//         var deleteRequest = URLRequest(url: deleteApiUrl)
//         deleteRequest.httpMethod = "DELETE"
//         
//         URLSession.shared.dataTask(with: deleteRequest) { (data, response, error) in
//             print("Actual HTTP Method: \(deleteRequest.httpMethod ?? "Unknown")")
//
//             if let error = error {
//                 print("Error deleting record: \(error)")
//                 completion(false)
//                 return
//             }
//             
//             if let httpResponse = response as? HTTPURLResponse {
//                 print("HTTP Status Code: \(httpResponse.statusCode)")
//                 
//                 if httpResponse.statusCode == 200 {
//                     print("Favorite record deleted successfully")
//                     completion(true)
//                 } else {
//                     print("HTTP Status Code: \(httpResponse.statusCode)")
//                     completion(false)
//                 }
//             }
//         }.resume()
//     }
//     func deleteFavoriteRestaurantRecord(restaurantID: String, completion: @escaping (Bool) -> Void) {
//         
//        
//         let matchingIDs = JsonDataArrays.UserFavoriteRestauranArray
//             .filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID }
//             .map { $0.UserFavoriteRestaurantID }
//         
//         guard matchingIDs.count > 0 else {
//             print("No matching records found")
//                     completion(false)
//                     
//             return
//         }
//         let deleteUrlString = "https://favrestaurant.azurewebsites.net/api/userFavouriteRestaurant/UserFavRes/\(matchingIDs[0] ?? "")"
//         
//    //https://favrestaurant.azurewebsites.net/api/userFavouriteRestaurant/UserFavRes/8d82d068-120c-4294-bf49-9f9cf3151498
//         
//         
//         
//         guard let deleteApiUrl = URL(string: deleteUrlString) else {
//             print("Invalid URL: \(deleteUrlString)")
//             completion(false)
//             return
//         }
//         
//         var deleteRequest = URLRequest(url: deleteApiUrl)
//         deleteRequest.httpMethod = "DELETE"
//         
//         URLSession.shared.dataTask(with: deleteRequest) { (data, response, error) in
//             print("Actual HTTP Method: \(deleteRequest.httpMethod ?? "Unknown")")
//
//             if let error = error {
//                 print("Error deleting record: \(error)")
//                 completion(false)
//                 return
//             }
//             
//             if let httpResponse = response as? HTTPURLResponse {
//                 print("HTTP Status Code: \(httpResponse.statusCode)")
//                 
//                 if httpResponse.statusCode == 200 {
//                     print("Favorite record deleted successfully")
//                     completion(true)
//                 } else {
//                     print("HTTP Status Code: \(httpResponse.statusCode)")
//                     completion(false)
//                 }
//             }
//         }.resume()
//     }
// }
//
// 
//*/


import UIKit
import SVProgressHUD
 
class favCollectionViewCellpop: UICollectionViewCell {
    var favoriteItem :ItemCompleteData?
    var favoriteRestaurant : RestaurantCompleteData?
    var reloadAfterFavActionClosure: (() -> Void)?
    var isFavourite : Bool = false
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var promotedLabel: UILabel!
    @IBOutlet weak var retingView: UIView!
    @IBOutlet weak var offertypeLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var descriLabels: UILabel!
    @IBOutlet weak var dishNames: UILabel!
    @IBOutlet weak var restaruntName: UILabel!
    @IBOutlet weak var favResImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
    }
    
    func setCellUI(){
        restaruntName.applyLabelStyle(for: .headingBlack)
        dishNames.applyLabelStyle(for: .subTitleLightGray)
        descriLabels.applyLabelStyle(for: .descriptionLightGray)
        offertypeLabel.applyLabelStyle(for: .subTitleLightGray)
        ratingLabel.applyLabelStyle(for: .OfferWhite)
        retingView.backgroundColor = UIColor(red: 220/245, green: 175/245, blue: 106/245, alpha: 1)
        retingView.layer.cornerRadius = 5
        retingView.layer.masksToBounds = false
        offerLabel.applyLabelStyle(for: .OfferWhite)
        offerLabel.clipsToBounds = true
        promotedLabel.applyLabelStyle(for: .promotedLabel)
        backView.cellBackViewShadow()
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
    
    @IBAction func FavbuttonAction(_ sender: UIButton) {
        
        if let restaurantData = favoriteRestaurant {
            handleFavouriteAction(
                id: restaurantData.restaurant.RestaurantID,
                fetchIdToDelete: fetchUserFavoriteRestaurantIdToDelete,
                deleteFavourite: deleteFavoriteRecord,
                updateFavouriteStatus: updateFavoriteStatus(restaurantID:isFavorite:completion:)
            
                    
                
            )
        } else {
            if let itemData = favoriteItem{
                
                handleFavouriteAction(
                    id: itemData.Item.ItemID,
                    fetchIdToDelete: { fetchUserFavouriteItemIdToDelete(restaurantID: itemData.Item.RestaurantID ?? "", itemId: $0, completion: $1) },
                    deleteFavourite: deleteFavoriteItemRecord,
                    updateFavouriteStatus: { updateFavoriteStatus(itemId:itemData.Item.ItemID ?? "", restaurantId: itemData.Item.RestaurantID ?? "", isFavorite:$1, completion:$2) }
                )
            }
        }
        
        
        func handleFavouriteAction(id: String?, fetchIdToDelete: (String, @escaping (String?) -> Void) -> Void, deleteFavourite: @escaping (String, @escaping (Bool) -> Void) -> Void, updateFavouriteStatus: @escaping (String, Bool, @escaping (Bool) -> Void) -> Void) {
            guard let id = id else { return }
            if !isFavourite {
                SVProgressHUD.show()
                updateFavouriteStatus(id, isFavourite) { success in
                    SVProgressHUD.dismiss()
                    if success {
                        print("Favorite status updated successfully")
                        self.reloadAfterFavActionClosure?()
                    } else {
                        print("Failed to update favorite status")
                    }
                }
            } else {
                SVProgressHUD.show()
                fetchIdToDelete(id) { matchingID in
                    guard let matchingID = matchingID else { return }
                    deleteFavourite(matchingID) { success in
                        SVProgressHUD.dismiss()
                        if success {
                            print("Favorite status deleted successfully")
                            self.reloadAfterFavActionClosure?()
                        } else {
                            print("Failed to update favorite status")
                        }
                    }
                }
            }
        }
        
        func updateFavoriteStatus(restaurantID: String, isFavorite: Bool, completion: @escaping (Bool) -> Void) {
            updateFavourite(urlString: FavRestaurantURL, body: [
                "UserID": loginUserID ?? "",
                "RestaurantID": restaurantID,
                "disabled": false
            ], completion: {_ in
                
            })
        }
        
        func updateFavoriteStatus(itemId: String, restaurantId: String, isFavorite: Bool, completion: @escaping (Bool) -> Void) {
            updateFavourite(urlString: FavouriteItemURL, body: [
                "UserID": loginUserID ?? "",
                "RestaurantID": restaurantId,
                "ItemID": itemId,
                "Disabled": false
            ], completion: completion)
        }
        
        func updateFavourite(urlString: String, body: [String: Any], completion: @escaping (Bool) -> Void) {
            guard let apiUrl = URL(string: urlString) else {
                print("Invalid URL: \(urlString)")
                completion(false)
                return
            }
            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                print("Error encoding request body: \(error)")
                completion(false)
                return
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
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
    
}
