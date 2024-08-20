//
//  WaiterJSONParsing.swift
//  TipTap
//
//  Created by Toqsoft on 10/04/24.
//

import Foundation
func fetchWaiterData() {
    let dispatchGroup = DispatchGroup()
    
    // Enter the dispatch group
    dispatchGroup.enter()
    // Call fetchWaiterData asynchronously
    fetchWaiterData {
        // Leave the dispatch group once fetchWaiterData completion handler is called
        dispatchGroup.leave()
    }
    
    // Enter the dispatch group
    dispatchGroup.enter()
    // Call fetchWaiterRatingsData asynchronously
    fetchWaiterRatingsData {
        // Leave the dispatch group once fetchWaiterRatingsData completion handler is called
        dispatchGroup.leave()
    }
    
    // Notify when all tasks in the dispatch group are completed
    dispatchGroup.notify(queue: .main) {
        // All tasks completed, perform any final actions
        print("All waiter tasks completed")
    }
}

func fetchWaiterData(completion: @escaping () -> Void) {
    let apiUrl = waiterURL
    
    guard let url = URL(string: apiUrl) else {
        print("Invalid URL")
        completion()
        return
    }
    
    fetchJSONData(from: url) { (result: Result<fetchWaitersApiResponse, APIError>) in
        switch result {
        case .success(let response):
            if let records = response.records {
                JsonDataArrays.WaiterCompleteDataArray.removeAll()
                JsonDataArrays.WaiterCompleteDataArray.append(contentsOf: records.map { WaiterCompleteData(waiter: $0) })
            }
        case .failure(let error):
            print("Error on fetchWaiterData: \(error)")
        }
        completion()
    }
}

func fetchWaiterRatingsData(completion: @escaping () -> Void) {
    let apiUrl = WaiterRatingsURL
    
    guard let url = URL(string: apiUrl) else {
        print("Invalid API URL")
        completion()
        return
    }
    
    fetchJSONData(from: url) { (result: Result<fetchWaiterRatingApiResponse, APIError>) in
        switch result {
        case .success(let apiResponse):
            if let records = apiResponse.records {
                JsonDataArrays.waiterRatingArray = records
                
                // Update WaiterCompleteDataArray with waiter ratings
                for rating in JsonDataArrays.waiterRatingArray {
                    for (index, element) in JsonDataArrays.WaiterCompleteDataArray.enumerated() {
                        if let waiterID = rating.waiterID, let restaurantID = rating.restaurantID,
                           element.waiter.waiterID == waiterID && element.waiter.restaurantID == restaurantID {
                            JsonDataArrays.WaiterCompleteDataArray[index].waiterRating.append(rating)
                            let averageRating = averageRating(for_waiter: waiterID)
                            JsonDataArrays.WaiterCompleteDataArray[index].waiterAverageRating = averageRating
                        }
                    }
                }
                
                // Update LoginUserWaiterRatingDataArray with ratings by login user
                let waiterRatingByLoginUserArray = records.filter { $0.userID == loginUserID }
                JsonDataArrays.LoginUserWaiterRatingDataArray.removeAll()
                for waiter in waiterRatingByLoginUserArray {
                    if let matchingitem = JsonDataArrays.WaiterCompleteDataArray.first(where: { $0.waiter.waiterID == waiter.waiterID }) {
                        let userRatingWaiterData = waiterRatingByLoginUserData(
                            ratingID: waiter.ratingID,
                            restaurantID: waiter.restaurantID,
                            waiterID: waiter.waiterID,
                            userID: waiter.userID,
                            visitDate: waiter.visitDate,
                            visitTime: waiter.visitTime,
                            review: waiter.review,
                            rating: waiter.rating,
                            waiterTitle: (matchingitem.waiter.firstName ?? "") + " " + (matchingitem.waiter.lastName ?? ""),
                            waiterImage: matchingitem.waiter.waiterImage,
                            RateDate: waiter.RateDate
                        )
                        JsonDataArrays.LoginUserWaiterRatingDataArray.append(userRatingWaiterData)
                    }
                }
            }
        case .failure(let error):
            print("Error on fetchWaiterRatingsData: \(error)")
        }
        completion()
    }
}

func averageRating(for_waiter waiterID: String) -> Double? {
    let ratingsForWaiter = JsonDataArrays.waiterRatingArray.filter { $0.waiterID == waiterID }
    
    guard !ratingsForWaiter.isEmpty else {
        return nil
    }
    
    let totalRating = ratingsForWaiter.reduce(0) { total, ratingData in
        if let rating = ratingData.rating {
            return total + rating
        } else {
            return total
        }
    }
    
    let averageRating = Double(totalRating) / Double(ratingsForWaiter.count)
    return averageRating.rounded(toPlaces: 2)
}
