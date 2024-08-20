//
//  RestaurantModel.swift
//  TipTap
//
//  Created by Toqsoft on 16/11/23.
//

//
//  RestaurantModel.swift
//  TipTap
//
//  Created by Toqsoft on 16/11/23.
//

import Foundation
import GoogleMaps


//public var itemCompleteDataArray = [ItemCompleteData]()
//public var RestaurantCompleteDataArray = [RestaurantCompleteData]()
//var ApplicationInformationArray = [Applicationinformation]()
//var userPaymentDataArray = [UserPaymentData]()
//var userRewardRestaurantArray = [Restaurant]()
//var userRewardsDataArray = [userRewardsData]()
//var userVisitedRestaurantwithReview = [userVisitedRestaurantData]()
//var userRatingsRestaurantArray = [Restaurant]()
//public var itemModel = [Item]()
//public var UserFavoriteRestauranArray = [userFavouriteRestaurant]()
//var cuisineModel = [CuisineModel]()
//public var RestaurantIDArray = [Int]()
//public var cuisinesArrayfromItems : [[Item]] = [[]]
//public var signatureItems :[Item] = []
//public var cuisinesArrayfromItems : [[ItemCompleteData]] = [[]]

//public var signatureItems :[ItemCompleteData] {
//    return  itemCompleteDataArray.filter { $0.Item.IsSignatureItem  }
//}
//public var restaurantModel = [Restaurant]()
//public var userVisitedArray = [userVisited]()
//public var feedbackArray = [companyfeedback]()
//public var userRewardsArray = [userRewards]()
//public var userFavouriteItemsArray = [userFavouriteItem]()
//public var FavouriteItemsIDArray = [Int]() //for store user's Favourite Item id's
//public var  UserRatingArray = [userRatings]()  // For User Ratings
//public var userRatingsDataArray = [userRatingData]()
//public var userVisitedResstaurantArray = [RestaurantCompleteData]()
//public var restaurantRatingsDataArray = [RestaurantRatingData]()
//
//public var  RestaurantRatingArray = [userRatings]()
//public var ItemRatingReviewDataArray = [ItemRatingReviewData]()
//public var userLogArray = [userLogs]()
//public var userPaymentArray = [RestaurantUserPayments]()
//public var UserEnquiryArray = [UserEnquiry]()
//public var UserReportArray = [userReports]()
//public var waiterRatingArray = [waiterRating]()
//
//
//public var itemOffersArray = [ItemOffer]()
//public var waiterRatingUserDataArray = [waiterRatingUserData]()
//public var userDataArray = [UserData]()
//public var restaurantOfferArray = [RestaurantOffer]()

//public var RestaurantaverageRatings = [AverageRatingForRestaurantInHomeView]()
//public var ItemsaverageRatings = [AverageRatingForItemInHomeView]()


//func groupItemsByCuisineArrays() -> [[ItemCompleteData]] {
//    var groupedItems: [[ItemCompleteData]] = []
//    var uniqueCuisineTitles: Set<String> = Set()
//
//    for item in  DataArrays.itemCompleteDataArray {
//        let cuisineTitle = item.Item.CusineTitle
//
//        // Check if the cuisine title is already in the set
//        if !uniqueCuisineTitles.contains(cuisineTitle) {
//            // If not, add it to the set and append the item to the groupedItems array
//            uniqueCuisineTitles.insert(cuisineTitle)
//            groupedItems.append([item])
//        }
//    }
//
//    return groupedItems
//}
//
//let loginuserID = 7
//
//
//public struct Applicationinformation : Codable{    
//    var applicationID : Int
//    var   applicationTitle : String
//    var  applicationVersion : String
//    var  description : String
//    var  releaseDate : String
//    var  companyName : String
//    var  companyAddress :  String
//    var companyEmail : String
//    var companyPhone : String
//    var disabled : Bool
//}
//
//public struct Restaurant : Codable, Hashable{
//    let RestaurantID: Int
//    let RestaurantTitle: String
//    let RestaurantAddress: String
//    let RestaurantCity: String
//    let RestaurantState: String
//    let ZipCode: String
//    let RestaurantPhone: String
//    let RestaurantCategory: String
//    let RestaurantRating: Int
//    let OpeningHours: String
//    let IsPromoted: Bool
//    let Longitude: Double
//    let Latitude: Double
//    let LandMark: String
//    let RestaurantImage: String
//    let Disable: Bool
//    let Description : String
//  
//}
//
//public struct CompleteRestaurant {
//    let Restaurantdata : Restaurant
//    let RestaurantOffer : RestaurantOffer
//    let RestaurantRatings : RestaurantRatingData
//    
//}
//
//public struct RestaurantOffer : Codable{
//    let offerID: Int
//    let restaurantID :  Int
//    let offerTitle : String
//    let description : String
//    let discount: Int
//    let startDate: String
//    let endDate: String
//    let restaurantOfferIsValid : Bool
//    let disabled : Bool
//}
//
//public struct RestaurantUserPayments : Codable {
//    var PaymentID : Int
//    var UserID : Int
//    var RestaurantID : Int
//    var Amount : Float
//    var PaymentDate : String
//    var PaymentMethod : String
//    var PaymentStatus  : String
//    var Disabled : Bool
//}
//
//public struct UserPaymentData {
//    
//    var payment :  RestaurantUserPayments
//    var restaurantTitle : String
//    
//}
//
//public struct userReports : Codable {
//    var ReportID : Int
//    var RestaurantID : Int
//    var UserID : Int
//    var ReportText : String
//    var ReportDate : String
//    var Disabled : Bool
//}
//
//
//public struct userRewards  : Codable{
//    var RewardID : Int
//    var UserID : Int
//    var RestaurantID : Int
//    var PointsEarned : Int
//    var DateEarned : String
//    var Disabled : Bool
//}
//
//public struct userFavouriteRestaurant : Codable{
//    var UserFavoriteRestaurantID : Int
//    var UserID : Int
//    var RestaurantID : Int
//    var Disabled : Bool
//}
//
//public struct userFavouriteItem : Codable {
//    var UserFavouriteItemID : Int
//    var UserID : Int
//    var RestaurantID : Int
//    var ItemID : Int
//    var Disabled : Bool
//}
//
//
//public struct userVisited  : Codable{
//    var VisitID : Int
//    var UserID : Int
//    var RestaurantID : Int
//    var VisitDate : String
//    var Review : String
//    var Rating : Int
//    var Disabled : Bool
//}
//
//
//public struct userLogs : Codable {
//    var LogID : Int
//    var UserID : Int
//    var LogType : String
//    var LogDateTime : String
//    var LogDetails : String    
//}
//
//public struct Item: Codable {
//    let ItemID: Int
//    let RestaurantID: Int
//    let ItemTitle: String
//    let CategoryID: Int
//    let CusineTitle: String
//    let IsSignatureItem: Bool
//    let Description: String
//    let itemImage: String
//    let Disable: Bool
//    
//}
//
//public struct Waiters: Codable {
//    let waiterID: Int
//    let firstName: String
//    let lastName: String
//    let gender: String
//    let birthDate: String
//    let contactNumber: String
//    let email: String
//    let joiningDate: String
//    let waiterImage: String
//    let restaurantID: Int
//    let disable: Bool
//    
//    enum CodingKeys: String, CodingKey {
//        case waiterID = "WaiterID"
//        case firstName = "FirstName"
//        case lastName = "LastName"
//        case gender = "Gender"
//        case birthDate = "BirthDate"
//        case contactNumber = "ContactNumber"
//        case email = "Email"
//        case joiningDate = "joiningDate"
//        case waiterImage = "Waiterimage"
//        case restaurantID = "RestaurantID"
//        case disable = "Disable"
//    }
//}
//
//
//public struct ReviewModel  : Codable{
//    var reviewPersonName : String
//    var reviewDate: String
//    var reviewText: String
//    var likesCount : String
//    var dislikesCount : String
//    var ratings : String
//    var reviewPersonImage : String
//}
//
//public struct userRatings: Codable{
//    var ratingID : Int
//   var  restaurantID : Int
//    var userID : Int
//    var rating : Int
//    var review : String
//    var rating_date : String
//    var disabled : Bool
//}
//
//
//public struct userRatingData {
//    var RestaurantID : Int
//    var RestaurantTitle : String
//    var Rating : Int // Should be double in json file
//    var Review : String
//    var ratingDate : String
//    var RestaurantImage : String
//}
//
//public struct ItemRatings : Codable{
//    var restaurantID : Int
//    var  itemID : Int
//    var rating : Int
//    var review : String
//    var userID : Int
//    var disabled : Bool
//}
//
//
//public struct RestaurantRatingData{
//    //Here we have to store user details also
//    var RestaurantID : Int
//    var UserID : Int
//    var UserTitle : String
//    var UserImage : String
//    var Rating : Int
//    var Review : String
//    var RatingDate : String
//
//}
//
//public struct UserData : Codable {
//    let UserID: Int
//    let FirstName: String
//    let LastName: String
//    let Email: String
//    let PasswordHash: String
//    let UserType: String
//    let Userimage: String
//    let RegistrationDate: String
//    let LastLoginDate: String
//    let Disabled: Bool
//}
//struct ItemCategory : Codable {
//    let categoryID: Int
//    let restaurantID: Int
//    let categoryTitle: String
//    let description: String
//    let isDisabled: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case categoryID = "CategoryID"
//        case restaurantID = "RestaurantID"
//        case categoryTitle = "Categorytitle"
//        case description = "Description"
//        case isDisabled = "disable"
//    }
//}
//
//
//public struct ItemRatingReviewData{
//    //Here we have to store user details also
//    var RestaurantID : Int
//    var UserID : Int
//    var UserTitle : String
//    var UserImage : String
//    var Rating : Int
//    var Review : String
//    
//}
//
//
//public struct companyfeedback : Codable{
//    var feedbackID : Int
//    var UserID : Int
//    var oftenuseapp : String
//    var motivationtouse : String
//    var mostusedfeature : String
//    var toimprove : String
//}
//
//public struct UserEnquiry : Codable{
//    var EnquiryID : Int
//    var RestaurantID : Int
//    var UserID : Int
//    var UserName : String
//    var Email : String
//    var ContactNumber : String
//    var Message : String
//    var EnquiryDate : String
//}
//
//
//public struct ItemOffer: Codable {
//    let itemOfferID: Int
//    let restaurantID: Int
//    let itemID: Int
//    let offerTitle: String
//    let description: String
//    let discount: Double
//    let startDate: String
//    let endDate: String
//    let isOffer: Bool
//    let disable: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case itemOfferID = "ItemOfferID"
//        case restaurantID = "RestaurantID"
//        case itemID = "ItemID"
//        case offerTitle = "OfferTitle"
//        case description = "Description"
//        case discount = "Discount"
//        case startDate = "StartDate"
//        case endDate = "EndDate"
//        case isOffer = "IsOffer"
//        case disable = "Disable"
//    }
//}
//public struct waiterRating : Codable{
//    let ratingID: Int
//    let WaiterID: Int
//    let userID: Int
//    let rating: Double
//    let comments: String
//    let ratingDate: String
//    let disabled: Bool
//}
//public struct waiterRatingUserData : Codable{
//    let ratingID: Int
//    let waiterID: Int
//    let userID: Int
//    let rating: Double
//    let comments: String
//    let ratingDate: String
//    var UserTitle : String
//    var UserImage : String
//}
//
////public struct AverageRatingForRestaurantInHomeView{
////    let restaurantID : Int
////    let AverateRating : Double
////    let TotalRating : Int
////}
////
////
////public struct AverageRatingForItemInHomeView{
////    let ItemID : Int
////    let restaurantID : Int
////    let AverateRating : Double
////    let TotalRating : Int
////}
//public struct ItemCompleteData: Codable {
//   
//    
//    let Item: Item
//    var ItemRatings: [ItemRatings]
//    var ItemCategory: ItemCategory?
//    var ItemOffer: ItemOffer?
//    var itemAverageRating: Double?
//
//    init(Item: Item, ItemRatings: [ItemRatings] = [], ItemCategory: ItemCategory? = nil, ItemOffer: ItemOffer? = nil, itemAverageRating: Double? = nil) {
//        self.Item = Item
//        self.ItemRatings = ItemRatings
//        self.ItemCategory = ItemCategory
//        self.ItemOffer = ItemOffer
//        self.itemAverageRating = itemAverageRating
//    }
//}
//public struct RestaurantCompleteData: Codable{
//    var restaurant : Restaurant
//    var restaurantRatings : [userRatings]
//    var rstaurantOffers: restaurantOffers?
//    var restaurantAverageRating : Double?
//    init(restaurant: Restaurant, restaurantRatings: [userRatings] = [], rstaurantOffers: restaurantOffers? = nil, restaurantAverageRating: Double? = nil) {
//        self.restaurant = restaurant
//        self.restaurantRatings = restaurantRatings
//        self.rstaurantOffers = rstaurantOffers
//        self.restaurantAverageRating = restaurantAverageRating
//    }
//}
//
//public struct restaurantOffers: Codable {
//    var offerID : Int
//    var restaurantID: Int
//    var offerTitle: String
//    var description: String
//    var discount: Double
//    var startDate: String
//    var endDate: String
//    var restaurantOfferIsValid: Bool
//    var disabled: Bool
//}


//public struct ReuseIdentifierConstant{
//    static let trendingThisWeekVCIdentifier = "TrendingThisWeekVC"
//        static let notificationVCIdentifier = "NotificationViewController"
//        static let favoritesVCIdentifier = "FavoritesVC"
//    
//}

// Reusable Function to Present View Controller
//extension UIViewController {
//    func presentViewController(withIdentifier identifier: String) {
//        guard let controller = storyboard?.instantiateViewController(identifier: identifier) else { return }
//        controller.modalPresentationStyle = .fullScreen
//        controller.modalTransitionStyle = .coverVertical
//        self.present(controller, animated: true)
//    }
//}
