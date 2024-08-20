//
//  FavButtonActions.swift
//  TipTap
//
//  Created by Toqsoft on 15/04/24.
//

import Foundation

// MARK: - RESTAURANT | Functions to DELETE restaurant from fav list

func deleteFavoriteRecord(userFavoriteRestaurantIdToDelete: String, completion: @escaping (Bool) -> Void) {
    
    //  let matchingIDs = JsonDataArrays.UserFavoriteRestauranArray.filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID }.map { $0.UserFavoriteRestaurantID }
    guard  userFavoriteRestaurantIdToDelete.count > 0 else {
        
        completion(true)
        return
    }
    let deleteUrlString = FavRestaurantURL
    
    guard let deleteApiUrl = URL(string: deleteUrlString) else {
        print("Invalid URL: \(deleteUrlString)")
        completion(false)
        return
    }
    
    
    
    var request = URLRequest(url: deleteApiUrl)
    request.httpMethod = "DELETE"
    
    let requestBody: [String: Any] = [
        "rowKey": userFavoriteRestaurantIdToDelete,
        "partitionKey": "UserFavRes"
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
                print("Favorite status deleted successfully in FavButtonActions")
                completion(true)
            } else {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                completion(false)
            }
        }
    }.resume()
    
    
}


func fetchUserFavoriteRestaurantIdToDelete(restaurantID: String, completion: @escaping (String) -> Void) {
    var matchingID = ""
    guard let loginUserID = loginUserID, !loginUserID.isEmpty else {
        completion("loginUserID")
        return
    }
    
    let apiUrlString = FavRestaurantURL + "?filter=UserID eq '\(loginUserID)' and RestaurantID eq '\(restaurantID)'"
    
    
    let apiUrl = URL(string: apiUrlString)
    fetchJSONData(from: apiUrl!) { (result: Result<fetchuserFavouriteRestaurantApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            if let records = jsondata.records {
                matchingID = records.first?.UserFavoriteRestaurantID ?? ""
            }
            completion(matchingID)
        case .failure(let error):
            print("Error: \(error)")
            completion("")  // Return an empty string in case of failure
        }
    }
}

// MARK: - ITEM | Functions to DELETE item from fav list

func fetchUserFavouriteItemIdToDelete(restaurantID: String, itemId: String, completion: @escaping (String) -> Void) {
    var matchingID = ""
    guard let loginUserID = loginUserID, !loginUserID.isEmpty else {
        completion("loginUserID")
        return
    }
    let apiUrlString = FavouriteItemURL + "?filter=UserID eq '\(loginUserID)' and RestaurantID eq '\(restaurantID)' and ItemID eq '\(itemId)'"
    
    
    let apiUrl = URL(string: apiUrlString)
    fetchJSONData(from: apiUrl!) { (result: Result<fetchuserFavouriteItemApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            if let records = jsondata.records {
                matchingID = records.first?.UserFavouriteItemID ?? ""
            }
            completion(matchingID)
        case .failure(let error):
            print("Error: \(error)")
            completion("")  // Return an empty string in case of failure
        }
    }
}

func deleteFavoriteItemRecord(userFavoriteItemIdToDelete: String, completion: @escaping (Bool) -> Void) {
    
    //        let matchingIDs = JsonDataArrays.userFavouriteItemsArray
    //            .filter { $0.UserID == loginUserID && $0.RestaurantID == restaurantID && $0.ItemID == itemId }
    //            .map { $0.UserFavouriteItemID }
    guard  userFavoriteItemIdToDelete.count > 0 else {
        
        completion(true)
        return
    }
    
    let deleteUrlString = FavouriteItemURL
    guard let deleteApiUrl = URL(string: deleteUrlString) else {
        print("Invalid URL: \(deleteUrlString)")
        return
    }
    
    
    var request = URLRequest(url: deleteApiUrl)
    request.httpMethod = "DELETE"
    
    let requestBody: [String: Any] = [
        "rowKey": userFavoriteItemIdToDelete,
        "partitionKey": "UserFavouriteItems"
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
