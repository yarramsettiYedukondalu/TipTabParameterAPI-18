//
//  JSONParse.swift
//  TipTap
//
//  Created by sriram on 11/12/23.
//

import Foundation
import UIKit
//public let jsonurl = "https://thetiptab.azurewebsites.net/mobileapi/"
enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidData
    case decodingError
}

func fetchJSONData<T: Decodable>(from url: URL, completion: @escaping (Result<T, APIError>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(.requestFailed))
            return
        }
        
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch let error as DecodingError {
            print("Decoding \(url) Error: \(error)")
            completion(.failure(.decodingError))
        } catch {
            print("Error in \(url): \(error)")
            completion(.failure(.decodingError))
        }
    }.resume()
}



func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error loading image: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data, let image = UIImage(data: data) else {
            print("Invalid data or unable to create UIImage")
            completion(nil)
            return
        }
        
        // Provide the loaded image to the completion handler
        
        completion(image)
    }.resume()
}

var onDataFetched: (([userRatingData]) -> Void)?
var restaurantRatingArray : fetchRestaurantRatingApiResponse?
func fetchrestaurantOffers(completion: @escaping () -> Void){
    let apiUrlString = restaurantOfferURL
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    fetchJSONData(from: apiUrl) { (result: Result<fetchRestaurantOfferApiResponse, APIError>) in
        switch result {
        case .success(let jsonData):
            if let records = jsonData.records{
                for offer in records  {
                    if let index = JsonDataArrays.restaurantCompleteDataArray.firstIndex(where: { $0.restaurant.RestaurantID == offer.restaurantID }) {
                        // Check if the restaurant is not already associated with an offer
                        if  JsonDataArrays.restaurantCompleteDataArray[index].rstaurantOffers == nil {
                            JsonDataArrays.restaurantCompleteDataArray[index].rstaurantOffers = offer
                        }
                    }
                }
            }
            
            completion()
        case .failure(let error):
            print("Error in fetchUserData: \(error)")
        }
    }
    
}

func fetchUserRatingJsonData(completion: @escaping () -> Void) {
    guard let url = URL(string: restaurantRatingURL) else {
        print("Invalid URL")
        completion()
        return
    }

    fetchJSONData(from: url) { (result: Result<fetchRestaurantRatingApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            JsonDataArrays.userRatingsDataArray.removeAll()
            restaurantRatingArray = jsondata

            if let records = jsondata.records {
                JsonDataArrays.UserRatingArray = records.filter { $0.UserId == loginUserID }
            }

            let userRatedRestaurantsIDArray = JsonDataArrays.UserRatingArray.compactMap { $0.RestaurantId }

            JsonDataArrays.userRatingsRestaurantArray = JsonDataArrays.restaurantModel.filter { restaurant in
                guard let restaurantID = restaurant.RestaurantID else { return false }
                return userRatedRestaurantsIDArray.contains(restaurantID)
            }

            for i in JsonDataArrays.UserRatingArray {
                if let matchingRestaurant = JsonDataArrays.userRatingsRestaurantArray.first(where: { $0.RestaurantID == i.RestaurantId }) {
                    let userRatingData = userRatingData(
                        RestaurantID: matchingRestaurant.RestaurantID,
                        RestaurantTitle: matchingRestaurant.RestaurantTitle,
                        Rating: i.Rating,
                        Review: i.Review,
                        ratingDate: i.RatingDate,
                        RestaurantImage: matchingRestaurant.RestaurantImage
                    )
                    JsonDataArrays.userRatingsDataArray.append(userRatingData)
                }
            }

            if let records = jsondata.records {
                for rating in records {
                    if let index = JsonDataArrays.restaurantCompleteDataArray.firstIndex(where: { $0.restaurant.RestaurantID == rating.RestaurantId }) {
                        if !JsonDataArrays.restaurantCompleteDataArray[index].restaurantRatings.contains(where: { $0.RestaurantRateId == rating.RestaurantRateId }) {
                            JsonDataArrays.restaurantCompleteDataArray[index].restaurantRatings.append(rating)
                            JsonDataArrays.restaurantCompleteDataArray[index].restaurantAverageRating = averageRating(for_restaurantID: rating.RestaurantId ?? "")
                        }
                    }
                }
            }

            print("Fetched and updated user rating JSON data.")
            completion()
            
        case .failure(let error):
            print("Error: \(error)")
            completion()
        }
    }
}



func averageRating(for_restaurantID restaurantID: String ) -> (Double)? {
    if let records = restaurantRatingArray?.records {
        let ratingsForRestaurant = records.filter { $0.RestaurantId == restaurantID }
        
        if ratingsForRestaurant.isEmpty {
            return nil
        }
        
        
        //   let totalRating = ratingsForRestaurant!.reduce(0) { $0 + $1.Rating }
        
        
        let totalRating = ratingsForRestaurant.reduce(0) { total, rating in
            if let unwrappedRating = rating.Rating {
                return total + unwrappedRating
            } else {
                return total
            }
        }
        let averageRating = Double(totalRating) / Double(ratingsForRestaurant.count)
        let roundedAverage = averageRating.rounded(toPlaces: 1)
        return (roundedAverage)
        // Use totalRating here
        
        
    }else{
        return 0.0
    }
}



func fetchuserVisitedjsonData(completion: @escaping () -> Void){
    JsonDataArrays.userVisitedRestaurantwithReview.removeAll()
    JsonDataArrays.userVisitedArray.removeAll()
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let apiUrlString = userVisitedURL + "?filter= UserID eq '\(loginUserID)'"
    
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    
    fetchJSONData(from: apiUrl)  { (result: Result<fetchUserVisitedApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            
            if let records = jsondata.records{
                JsonDataArrays.userVisitedArray = records
            }
            
            
            let userVitedRestaurantsIDarray = JsonDataArrays.userVisitedArray.compactMap { userVisit in
                if let restaurantID = userVisit.RestaurantID {
                    return restaurantID
                } else {
                    return nil
                }
            }
            
            JsonDataArrays.userVisitedResstaurantArray =  JsonDataArrays.restaurantCompleteDataArray.filter{
                result in
                if let id = result.restaurant.RestaurantID{
                    return   userVitedRestaurantsIDarray.contains(id)
                }else{
                    return false
                }
                
            }
            
            
            var visitedArray = [userVisitedRestaurantData]()
            
            for i in  JsonDataArrays.userVisitedArray {
                // Check if the userVisitedResstaurantArray contains a restaurant with the given RestaurantID
                if let matchingRestaurant = JsonDataArrays.userVisitedResstaurantArray.first(where: { $0.restaurant.RestaurantID == i.RestaurantID }) {
                    // If found, create a new userVisitedRestaurantData instance with the restaurant
                    let userVisitedData = userVisitedRestaurantData(
                        visitedDate: i.VisitDate ?? "",
                        review: i.Review ?? "",
                        rating: i.Rating ?? 0,
                        restaurant: matchingRestaurant
                    )
                    
                    // Append the new instance to the array
                    visitedArray.append(userVisitedData)
                }
                // Handle the case where the restaurant is not found if needed
                else {
                    // Handle the case where the restaurant is not found
                    // You might want to log an error or handle it in some way
                }
            }
            
            JsonDataArrays.userVisitedRestaurantwithReview = visitedArray
            
            //  print("userVisitedRestaurantwithReview : \(userVisitedRestaurantwithReview)")
            
            //                self.favoriteCV.reloadData()
            completion()
            
            
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}


func fetchuserRewardsjsonData(completion: @escaping () -> Void){
    JsonDataArrays.userRewardsArray.removeAll()
    JsonDataArrays.userRewardsDataArray.removeAll()
    JsonDataArrays.userRewardRestaurantArray.removeAll()
    
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let apiUrlString = userRewardsURL + "?filter= UserID eq '\(loginUserID)'"
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    fetchJSONData(from: apiUrl)  { (result: Result<fetchUserRewardsApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            
            if let records = jsondata.records{
                JsonDataArrays.userRewardsArray = records
            }
            //            JsonDataArrays.RestaurantIDArray =  JsonDataArrays.userRewardsArray.map{$0.RestaurantID}
            
            let userREwardsRestaurantIDarray = JsonDataArrays.userRewardsArray.compactMap { userRewardsArray in
                if let restaurantID = userRewardsArray.RestaurantID {
                    return restaurantID
                } else {
                    return nil
                }
            }
            
            
            JsonDataArrays.userRewardRestaurantArray =  JsonDataArrays.restaurantModel.filter{
                result in
                if let id = result.RestaurantID{
                    return userREwardsRestaurantIDarray.contains(id)
                    
                }else{
                    return false
                }
            }
            
            for i in  JsonDataArrays.userRewardsArray {
                // Check if the userVisitedResstaurantArray contains a restaurant with the given RestaurantID
                if let matchingRestaurant =  JsonDataArrays.userRewardRestaurantArray.first(where: { $0.RestaurantID == i.RestaurantID }) {
                    // If found, create a new userVisitedRestaurantData instance with the restaurant
                    let userRewardsData = userRewardsData(RestaurantTitle: matchingRestaurant.RestaurantTitle ?? "", PointsEarned: i.PointsEarned ?? 0, DateEarned: i.DateEarned ?? "", RestaurantImage: matchingRestaurant.RestaurantImage ?? ""
                                                          
                    )
                    
                    // Append the new instance to the array
                    JsonDataArrays.userRewardsDataArray.append(userRewardsData)
                }
                // Handle the case where the restaurant is not found if needed
                else {
                    // Handle the case where the restaurant is not found
                    // You might want to log an error or handle it in some way
                }
            }
            completion()
            
            
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

func fetchFavioureRestaurant(completion: @escaping () -> Void) {
    
    JsonDataArrays.FavouriteRestaurantIDArray.removeAll()
    JsonDataArrays.UserFavoriteRestauranArray.removeAll()
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let url = FavRestaurantURL + "?filter= UserID eq '\(loginUserID)'"
    let apiUrl = URL(string: url)
    
    fetchJSONData(from: apiUrl!) { (result: Result<fetchuserFavouriteRestaurantApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            // DispatchQueue.main.async {
            // print(jsondata)
            if let records = jsondata.records{
                JsonDataArrays.UserFavoriteRestauranArray = records
            }
            //                JsonDataArrays.RestaurantIDArray = JsonDataArrays.UserFavoriteRestauranArray.map { $0.RestaurantID }
            
            
            
            JsonDataArrays.FavouriteRestaurantIDArray = JsonDataArrays.UserFavoriteRestauranArray.compactMap { userFavoriteRestaurant in
                userFavoriteRestaurant.RestaurantID // Return optional String?
            }
            
            
            // print(" UserFavoriteRestaurant Data received: \(JsonDataArrays.UserFavoriteRestauranArray)")
            //  print(JsonDataArrays.RestaurantIDArray)
            
            // Call the completion handler after processing the data
            completion()
            //  }
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}


func fetchFavouriteItems(completion: @escaping () -> Void) {
    JsonDataArrays.userFavouriteItemsArray.removeAll()
    JsonDataArrays.FavouriteItemsIDArray.removeAll()
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let url = FavouriteItemURL + "?filter= UserID eq '\(loginUserID)'"
    guard let url = URL(string: url) else {
        print("Invalid URL")
        return
    }
    
    fetchJSONData(from: url) { (result: Result<fetchuserFavouriteItemApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            if let records = jsondata.records{
                JsonDataArrays.userFavouriteItemsArray = records
                JsonDataArrays.FavouriteItemsIDArray = JsonDataArrays.userFavouriteItemsArray.map { UserFavItemIDs(itemID: $0.ItemID, RestaurantID: $0.RestaurantID) }
            }
            
            completion()
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    
    // Assuming you're calling this function from a UIViewController
    if let viewController = UIApplication.shared.keyWindow?.rootViewController {
        viewController.present(alertController, animated: true, completion: nil)
    }
}
func fetchUserData(completion : @escaping () -> Void){
    let apiUrlString = userURL
    
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    fetchJSONData(from: apiUrl) { (result: Result<fetchUserApiResponse, APIError>) in
        switch result {
        case .success(let jsonData):
            
            
            // print(jsondata)
            if let records = jsonData.records {
                JsonDataArrays.userDataArray = records
            }
            
            completion()
        case .failure(let error):
            print("Error in fetchUserData: \(error)")
        }
    }
}
func fetchItemRatingJson(completion: @escaping () -> Void){
    //     var  itemRatingArray = [ItemRatings]()
    
    let apiUrlString = ItemRatingURL
    
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    
    //  print(url)
    
    fetchJSONData(from: apiUrl ) {  (result: Result<fetchItemRatingsApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            
            
            if let records = jsondata.records{
                AllItemsRatingsArray = records
            }else{
                AllItemsRatingsArray = []
            }
            
            for rating in AllItemsRatingsArray {
                for (index, element) in JsonDataArrays.itemCompleteDataArray.enumerated() {
                    // Unwrap optional itemID and restaurantID
                    if let itemID = rating.itemID, let restaurantID = rating.restaurantID,
                       element.Item.ItemID == itemID && element.Item.RestaurantID == restaurantID {
                        // Append rating to ItemRatings array
                        JsonDataArrays.itemCompleteDataArray[index].ItemRatings.append(rating)
                        
                        // Calculate and set average rating
                        let averageRating = averageRating(forItemID: itemID)
                        JsonDataArrays.itemCompleteDataArray[index].itemAverageRating = averageRating
                    }
                }
            }
            
            var itemRatingByLoginUserArray: [ItemRatings] = []
            JsonDataArrays.LoginUserItemRatingDataArray.removeAll()
            if let records = jsondata.records{
                itemRatingByLoginUserArray = records.filter{ $0.userID == loginUserID }
            }
            for items in itemRatingByLoginUserArray{
                if let matchingitem =  JsonDataArrays.itemCompleteDataArray.first(where: { $0.Item
                    .ItemID == items.itemID }) {
                    let userRatingItemData = ItemRatingByLoginUserData(itemRatingId: items.itemRatingId, restaurantID: items.restaurantID, itemID: items.itemID, rating: items.rating, review: items.review, userID: items.userID, itemImage: matchingitem.Item.itemImage, itemTitle: matchingitem.Item.ItemTitle, RateDate: items.RateDate )
                    JsonDataArrays.LoginUserItemRatingDataArray.append(userRatingItemData)
                }
            }
            
            //            fetchWaiterRatingsBYLoginUser{
            //                
            //            }
            completion()
        case .failure(let error):
            print("Error on fetchItemRatingJsonData: \(error)")
        }
    }
}
func averageRating(forItemID itemID: String) -> (Double)? {
    let ratingsForItem = AllItemsRatingsArray.filter { $0.itemID == itemID }
    
    guard !ratingsForItem.isEmpty else {
        return nil // No ratings found for the given item ID
    }
    
    //        let totalRating = ratingsForItem.reduce(0) { $0 + $1.rating }
    
    let totalRating = ratingsForItem.reduce(0) { total, rating in
        if let unwrappedRating = rating.rating {
            return total + unwrappedRating
        } else {
            return total
        }
    }
    
    let averageRating = Double(totalRating) / Double(ratingsForItem.count)
    let roundedAverage = averageRating.rounded(toPlaces: 1)
    
    return (roundedAverage)
}

protocol ReviewPostingDelegate {
    func didPostReviewSuccessfully(for type: ReviewType)
}

enum ReviewType {
    case restaurant
    case item
    case waiter
}


import Foundation

class OffersViewModel: ObservableObject {
    @Published var offers: [OfferRecord] = []
    @Published var errorMessage: String? = nil
    
    func fetchOffers() {
        guard let url = URL(string: restaurantOfferURL) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let offerResponse = try decoder.decode(OfferResponse.self, from: data)
                DispatchQueue.main.async {
                    self.offers = offerResponse.records
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
private func showError(message: String) {
       let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default))
      
   }
