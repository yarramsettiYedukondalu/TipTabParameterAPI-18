import Foundation
import GoogleMaps


@available(iOS 13.0, *)
let emptyImage = UIImage(systemName: "photo.fill")!

// MARK: - Data Arrays
struct JsonDataArrays {
    static var fetchRestaurantApiArray = [fetchRestaurantApiResponse]()
    static var itemCompleteDataArray = [ItemCompleteData]()
    static var restaurantCompleteDataArray = [RestaurantCompleteData]()
    static var WaiterCompleteDataArray = [WaiterCompleteData]()
    static var applicationInformationArray = [Applicationinformation]()
    static var userPaymentDataArray = [UserPaymentData]()
    static var userRewardRestaurantArray = [Restaurant]()
    static var userRewardsDataArray = [userRewardsData]()
    static var userVisitedRestaurantwithReview = [userVisitedRestaurantData]()
    static var userRatingsRestaurantArray = [Restaurant]()
    static var itemModel = [Item]()
    static var UserFavoriteRestauranArray = [userFavouriteRestaurant]()
    static var cuisineModel = [CuisineModel]()
    //   static var RestaurantIDArray = [String]()
    
    static var restaurantModel = [Restaurant]()
    static var userVisitedArray = [userVisited]()
    static var feedbackArray = [companyfeedback]()
    static var userRewardsArray = [userRewards]()
    static var userFavouriteItemsArray = [userFavouriteItem]()
    //static var FavouriteItemsIDArray = [String]() //for store user's Favourite Item id's
    static var  UserRatingArray = [userRatings]()  // For User Ratings
    static var userRatingsDataArray = [userRatingData]()
    static var userVisitedResstaurantArray = [RestaurantCompleteData]()
    
    
    static var  RestaurantRatingArray = [userRatings]()
    //  static var ItemRatingReviewDataArray = [ItemRatingReviewData]()
    // static var userLogArray = [userLogs]()
    static var userPaymentArray = [RestaurantUserPayments]()
    static var UserEnquiryArray = [UserEnquiry]()
    static var UserReportArray = [userReports]()
    static  var waiterRatingArray = [waiterRating]()
    
    static var itemOffersArray = [ItemOffer]()
    static var waiterRatingUserDataArray = [waiterRatingUserData]()
    static var userDataArray = [UserData]()
    static var restaurantOfferArray = [RestaurantOffer]()
    
    static var userLogArray = [userLogs]()
    static var FavouriteRestaurantIDArray = [String]()
    static var LoginUserItemRatingDataArray = [ItemRatingByLoginUserData]()
    static var LoginUserWaiterRatingDataArray = [waiterRatingByLoginUserData]()
    static var FavouriteItemsIDArray = [UserFavItemIDs]()
}

// MARK: - Constants
public var loginUserID = UserDefaults.standard.string(forKey: "UserID")
//public let loginUserID = "c7f76ada-bae3-42a2-bf48-ba706f8d789f"//"da08d52b-bf47-4f83-a972-a35ec3911748"//"2e0fc814-4e43-47af-8fb7-fcbd654641a7"//"68642a66-e73d-406b-9b8b-ab1f9924a92a"//"c7f76ada-bae3-42a2-bf48-ba706f8d789f"//"2e0fc814-4e43-47af-8fb7-fcbd654641a7"//768642a66-e73d-406b-9b8b-ab1f9924a92a

public var AllItemsRatingsArray = [ItemRatings]()


public var currentLocation: CLLocationCoordinate2D?

public var restaurantOffersArray = [RestaurantOffer]()
var currentRestauran : RestaurantCompleteData? = nil
public var cuisinesArrayfromItems: [[ItemCompleteData]] {
    return groupItemsByCuisineArrays()
}

// MARK: - Reuse Identifier Constants
struct ReuseIdentifierConstant {
    static let trendingThisWeekVCIdentifier = "TrendingThisWeekVC"
    static let notificationVCIdentifier = "NotificationViewController"
    static let favoritesVCIdentifier = "FavoritesVC"
    static let rewardsCellIdentifier = "cell"
}
struct RestaurantImage: Codable {
    let PartitionKey: String
    let RowKey: String
    let Timestamp: String
    let ETag: [String: String]
    let RestaurantID: String
    let ImageOne: String
    let ImageTwo: String
    let ImageThree: String
    
    init(PartitionKey: String, RowKey: String, Timestamp: String, ETag: [String : String], RestaurantID: String, ImageOne: String, ImageTwo: String, ImageThree: String) {
        self.PartitionKey = PartitionKey
        self.RowKey = RowKey
        self.Timestamp = Timestamp
        self.ETag = ETag
        self.RestaurantID = RestaurantID
        self.ImageOne = ImageOne
        self.ImageTwo = ImageTwo
        self.ImageThree = ImageThree
    }
}
// MARK: - Functions
func groupItemsByCuisineArrays() -> [[ItemCompleteData]] {
    var groupedItems: [[ItemCompleteData]] = []
    var uniqueCuisineTitles: Set<String> = Set()
    
    for item in JsonDataArrays.itemCompleteDataArray {
        let cuisineTitle = item.Item.CusineTitle  ?? ""
        
        // Check if the cuisine title is already in the set
        if !uniqueCuisineTitles.contains(cuisineTitle) {
            // If not, add it to the set and append the item to the groupedItems array
            uniqueCuisineTitles.insert(cuisineTitle)
            groupedItems.append([item])
        }
    }
    
    return groupedItems
}

// MARK: - Extensions
extension Array where Element == ItemCompleteData {
    func filterSignatureItems() -> [ItemCompleteData] {
        return self.filter { $0.Item.IsSignatureItem ?? false }
    }
}

extension UIViewController {
    func presentViewController(withIdentifier identifier: String) {
        guard let controller = storyboard?.instantiateViewController(identifier: identifier) else { return }
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
    }
    
}

extension UITableView {
    func createEmptyCell(with message: String?) -> UITableViewCell {
        let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        emptyCell.textLabel?.text = message
        emptyCell.textLabel?.textAlignment = .center
        return emptyCell
    }
}

// MARK: - Structs
public struct Applicationinformation : Codable{
    var applicationID : String?
    var   applicationTitle : String?
    var  applicationVersion : String?
    var  description : String?
    var  releaseDate : String?
    var  companyName : String?
    var  companyAddress :  String?
    var companyEmail : String?
    var companyPhone : String?
    var disabled : Bool
}

public struct fetchRestaurantApiResponse : Codable{
    let records: [Restaurant]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchWaiterRatingApiResponse : Codable{
    let records: [waiterRating]?
    let StatusCode: Int?
    let StatusMessage: String?
    let record : waiterRating?
    
    
}
struct fetchWaitersApiResponse: Codable {
    let records: [Waiters]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchItemApiResponse : Codable{
    let records: [Item]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchUserApiResponse : Codable{
    let records: [UserData]?
    let record: UserData?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchItemCategoryApiResponse : Codable{
    let records: [ItemCategory]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchRestaurantRatingApiResponse : Codable{
    let records: [userRatings]?
    let record: userRatings?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchUserVisitedApiResponse : Codable{
    let records: [userVisited]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchUserLogsApiResponse : Codable{
    var records: [userLogs]?
    let StatusCode: Int?
    let StatusMessage: String?
}

public struct fetchRestaurantOfferApiResponse : Codable{
    var records: [RestaurantOffer]?
    let StatusCode: Int?
    let StatusMessage: String?
}

//public struct fetchuserLogsApiResponse : Codable{
//    var Records: [userLogs]?
//    let StatusCode: Int?
//    let StatusMessage: String?
//}
public struct fetchItemRatingsApiResponse : Codable{
    var records: [ItemRatings]?
    var record: ItemRatings?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchCompanyfeedbackApiResponse : Codable{
    var records: [companyfeedback]?
    let StatusCode: Int?
    let StatusMessage: String?
}

public struct fetchUserRewardsApiResponse : Codable{
    var records: [userRewards]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchuserFavouriteRestaurantApiResponse : Codable{
    var records: [userFavouriteRestaurant]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchuserFavouriteItemApiResponse : Codable{
    var records: [userFavouriteItem]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchUserEnquiryApiResponse : Codable{
    var records: [UserEnquiry]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchuserReportsApiResponse : Codable{
    var records: [userReports]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchItemOfferApiResponse : Codable{
    var records: [ItemOffer]?
    let StatusCode: Int?
    let StatusMessage: String?
}
public struct fetchUserPaymentsApiResponse : Codable{
    var records: [RestaurantUserPayments]?
    let StatusCode: Int?
    let StatusMessage: String?
}

public struct Restaurant : Codable, Hashable{
    let RestaurantID: String?
    let RestaurantTitle: String?
    let RestaurantAddress: String?
    let RestaurantCity: String?
    let RestaurantState: String?
    let ZipCode: Int?
    let RestaurantPhone: Int?
    let RestaurantCategory: String?
    //  let RestaurantRating: Int?
    let OpeningHours: String?
    let IsPromoted: Bool?
    let Longitude: Double?
    let Latitude: Double?
    let LandMark: String?
    let RestaurantImage: String?
    let Disable: Bool?
    let Description : String?
  
    enum CodingKeys: String, CodingKey {
        case RestaurantID = "RestaurantID"
        case RestaurantTitle = "RestaurantTitle"
        case RestaurantAddress = "RestaurantAddress"
        case RestaurantCity = "City"
        case RestaurantState = "State"
        case ZipCode = "ZipCode"
        case RestaurantPhone = "RestaurantPhone"
        case RestaurantCategory = "RestaurantCategory"
        //  case RestaurantRating = "RestaurantRating"
        case OpeningHours = "OpeningHours"
        case IsPromoted = "IsPromoted"
        case Longitude = "Longitude"
        case Latitude = "Latitude"
        case LandMark = "LandMark"
        case RestaurantImage = "RestaurantImage"
        case Description = "Description"
        case Disable = "Disable"
      
    }
}

public struct CompleteRestaurant {
    let Restaurantdata : Restaurant
    let RestaurantOffer : RestaurantOffer
    let RestaurantRatings : RestaurantRatingData
    
}

public struct RestaurantOffer : Codable{
    let offerID: String?
    let restaurantID :  String
    let offerTitle : String?
    let description : String?
    let discount: Int?
    let startDate: String?
    let endDate: String?
    //    let restaurantOfferIsValid : Bool
    //   let disabled : Bool
    let offerImage : String
    enum CodingKeys: String, CodingKey {
        case offerID = "OfferID"
        case restaurantID = "RestaurantID"
        case offerTitle = "OfferTitle"
        case description = "Description"
        case discount = "Discount"
        case startDate = "startDate"
        case endDate = "EndDate"
        //     case restaurantOfferIsValid = "restaurantOfferIsValid"
        //     case disabled = "disabled"
        case offerImage = "offerImage"
    }
}

public struct RestaurantUserPayments : Codable {
    var PaymentID : String?
    var UserID : String?
    var RestaurantID : String?
    var Amount : Float?
    var PaymentDate : String?
    var PaymentMethod : String?
    var PaymentStatus  : String?
    var Disabled : Bool
}

public struct UserPaymentData {
    
    var payment :  RestaurantUserPayments
    var restaurantTitle : String?
    
}

public struct userReports : Codable {
    var ReportID : String?
    var FirstName : String?
    var LastName : String?
    var UserID : String?
    var EmailID : String?
    var ReportDate : String?
    var Issue : String?
}


public struct userRewards  : Codable{
    var RewardID : String?
    var UserID : String?
    var RestaurantID : String?
    var PointsEarned : Int?
    var DateEarned : String?
    var Disabled : Bool
}

public struct userFavouriteRestaurant : Codable{
    var UserFavoriteRestaurantID : String?
    var UserID : String?
    var RestaurantID : String?
    var disabled : Bool
}

public struct userFavouriteItem : Codable {
    var UserFavouriteItemID : String?
    var UserID : String?
    var RestaurantID : String?
    var ItemID : String?
    var Disabled : Bool
}


public struct userVisited  : Codable{
    var VisitID : String?
    var UserID : String?
    var RestaurantID : String?
    var VisitDate : String?
    var Review : String?
    var Rating : Int?
    //  var Disabled : Bool
    enum CodingKeys: String, CodingKey {
        case VisitID = "VisitID"
        case UserID = "UserID"
        case RestaurantID = "RestaurantID"
        case VisitDate = "VisitDate"
        case Review = "Review"
        case Rating = "Rating"
        // case Disabled = "Disabled"
        
    }
}

public struct userLogs : Codable {
    var LogID : String?
    var UserID : String?
    var LogType : String?
    var LogDateTime : String?
    var LogDetails : String?
}

public struct Item : Codable {
    let ItemID: String?
    let RestaurantID: String?
    let ItemTitle: String?
    let CategoryID: String?
    let CusineTitle: String?
    let IsSignatureItem: Bool?
    let Description: String?
    let itemImage: String?
    let Disable: Bool?
    
}


public struct Waiters: Codable {
    let waiterID: String?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let birthDate: String?
    let contactNumber: Int?
    let email: String?
    let joiningDate: String?
    let waiterImage: String?
    let restaurantID: String?
    let disable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case waiterID = "WaiterID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case gender = "Gender"
        case birthDate = "BirthDate"
        case contactNumber = "ContactNumber"
        case email = "Email"
        case joiningDate = "joiningDate"
        case waiterImage = "Waiterimage"
        case restaurantID = "RestaurantID"
        case disable = "Disable"
    }
}


public struct ReviewModel  : Codable{
    var reviewPersonName : String?
    var reviewDate: String?
    var reviewText: String?
    var likesCount : String?
    var dislikesCount : String?
    var ratings : String?
    var reviewPersonImage : String?
}

//public struct userRatings: Codable{
//    var ratingID : Int?
//    var  restaurantID : Int?
//    var userID : Int?
//    var rating : Int?
//    var review : String?
//    var rating_date : String?
//    var disabled : Bool
//}

public struct userRatings: Codable{
    var RestaurantRateId : String?
    var  RestaurantId : String?
    var UserId : String?
    var Rating : Int?
    var Review : String?
    var RatingDate : String?
    
    enum CodingKeys: String, CodingKey {
        case RestaurantRateId = "RestaurantRateId"
        case RestaurantId = "RestaurantID"
        case UserId = "UserID"
        case Rating = "Rating"
        case Review = "Review"
        case RatingDate = "RatingDate"
        
    }
}
public struct userRatingData {
    var RestaurantID : String?
    var RestaurantTitle : String?
    var Rating : Int? // Should be double in json file
    var Review : String?
    var ratingDate : String?
    var RestaurantImage : String?
}
public struct ItemRatingByLoginUserData {
    var itemRatingId : String?
    var restaurantID : String?
    var  itemID : String?
    var rating : Int?
    var review : String?
    var userID : String?
    var itemImage : String?
    var itemTitle : String?
    var RateDate : String?
}
//public struct ItemRatings : Codable{
//    var itemRatingId : String?
//    var restaurantID : String?
//    var  itemID : String?
//    var rating : Int?
//    var review : String?
//    var userID : String?
//    var disabled : Bool
//    var RateDate : String?
//    
//    enum CodingKeys: String, CodingKey {
//        case itemRatingId = "ItemRatingId"
//        case restaurantID = "RestaurantID"
//        case itemID = "ItemID"
//        case rating = "Rating"
//        case review = "Review"
//        case userID = "UserID"
//        case disabled = "disable"
//        case RateDate = "RateDate"
//    }
//}
public struct ItemRatings : Codable{
    var RowKey : String?
    var itemRatingId : String?
    var restaurantID : String?
    var  itemID : String?
    var rating : Int?
    var review : String?
    var userID : String?
    var disabled : Bool
    var RateDate : String?
    
    enum CodingKeys: String, CodingKey {
        case RowKey = "RowKey"
        case itemRatingId = "ItemRatingId"
        case restaurantID = "RestaurantID"
        case itemID = "ItemID"
        case rating = "Rating"
        case review = "Review"
        case userID = "UserID"
        case disabled = "disable"
        case RateDate = "RateDate"
    }
}

public struct RestaurantRatingData{
    //Here we have to store user details also
    var RestaurantratingID :String
    var RestaurantID : String?
    var UserID : String?
    var UserTitle : String?
    var UserImage : String?
    var Rating : Int?
    var Review : String?
    var RatingDate : String?
    
}

public struct UserData : Codable {
    let UserID: String?
    let FirstName: String?
    let LastName: String?
    let Email: String?
    let PasswordHash: String?
    let UserType: String?
    let Userimage: String?
    let RegistrationDate: String?
    let LastLoginDate: String?
    let Disable: Bool?
    
    
}
struct ItemCategory : Codable {
    let categoryID: String?
    // let restaurantID: String?
    let categoryTitle: String?
    //let description: String?
    let isDisabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "CategoryID"
        //case restaurantID = "RestaurantID"
        case categoryTitle = "Categorytitle"
        // case description = "Description"
        case isDisabled = "Disable"
    }
}

//public struct ItemRatingReviewData{
//    //Here we have to store user details also
//    var ItemRatingId : String?
//    var RestaurantID : String?
//    var UserID : String?
//    var UserTitle : String?
//    var UserImage : String?
//    var Rating : Int?
//    var Review : String?
//    var ratingDate : String?
//    
//}


public struct companyfeedback : Codable{
    var feedbackID : String?
    var UserID : String?
    var oftenuseapp : String?
    var motivationtouse : String?
    var mostusedfeature : String?
    var toimprove : String?
}
//"feedbackID": 4,
//         "UserID": 7,
//         "oftenuseapp": "daily",
//         "motivationtouse": "efficient task management",
//         "mostusedfeature": "calendar integration",
//         "toimprove": "faster response times"
public struct UserEnquiry : Codable{
    var EnquiryID : String?
    var UserID : String?
    var firstName : String?
    var lastName : String?
    var emailEQ : String?
    var comment : String?
    var enquiryType : String?
    var  EnquiryDate: String?
}


public struct ItemOffer: Codable {
    let itemOfferID: String?
    let restaurantID: String?
    let itemID: String?
    let offerTitle: String?
    let description: String?
    let discount: Double
    let startDate: String?
    let endDate: String?
    let isOffer: Bool
    let disable: Bool
    
    enum CodingKeys: String, CodingKey {
        case itemOfferID = "ItemOfferID"
        case restaurantID = "RestaurantID"
        case itemID = "ItemID"
        case offerTitle = "OfferTitle"
        case description = "Description"
        case discount = "Discount"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case isOffer = "IsOffer"
        case disable = "disabled"
    }
    
}
//public struct waiterRating : Codable{
//    let ratingID: Int?
//    let WaiterID: Int?
//    let userID: Int?
//    let rating: Double
//    let comments: String?
//    let ratingDate: String?
//    let disabled: Bool
//}
public struct waiterRatingUserData : Codable{
    let WaiterRatingID: String?
    let waiterID: String?
    let userID: String?
    let rating: Int?
    let comments: String?
    let ratingDate: String?
    var UserTitle : String?
    var UserImage : String?
}

public struct ItemCompleteData: Codable {
    
    
    let Item: Item
    var ItemRatings: [ItemRatings]
    var ItemCategory: ItemCategory?
    var ItemOffer: ItemOffer?
    var itemAverageRating: Double?
    
    init(Item: Item, ItemRatings: [ItemRatings] = [], ItemCategory: ItemCategory? = nil, ItemOffer: ItemOffer? = nil, itemAverageRating: Double? = nil) {
        self.Item = Item
        self.ItemRatings = ItemRatings
        self.ItemCategory = ItemCategory
        self.ItemOffer = ItemOffer
        self.itemAverageRating = itemAverageRating
    }
}
public struct RestaurantCompleteData: Codable{
    var restaurant : Restaurant
    var restaurantRatings : [userRatings]
    var rstaurantOffers: RestaurantOffer?
    var restaurantAverageRating : Double?
    init(restaurant: Restaurant, restaurantRatings: [userRatings] = [], rstaurantOffers: RestaurantOffer? = nil, restaurantAverageRating: Double? = nil) {
        self.restaurant = restaurant
        self.restaurantRatings = restaurantRatings
        self.rstaurantOffers = rstaurantOffers
        self.restaurantAverageRating = restaurantAverageRating
    }
}

//public struct restaurantOffers: Codable {
//    var offerID : Int?
//    var restaurantID: Int?
//    var offerTitle: String?
//    var description: String?
//    var discount: Double
//    var startDate: String?
//    var endDate: String?
//    var restaurantOfferIsValid: Bool
//    var disabled: Bool
//}

struct CuisineModel {
    var cuisineName : String?
    var description : String?
    var ratings : String?
    var promoted : Bool
    var offers : Bool
    var offerName : String?
    var cuisineImage : String?
}

struct SignatureDishModel {
    var dishName : String?
    var description : String?
    var estimatedTime: String?
    var ratings : String?
    var subDescription: String?
    var promoted : Bool
    var offers : Bool
    var offerName : String?
    var dishImage : String?
}
public struct waiterRatingByLoginUserData {
    let ratingID: String?
    let restaurantID: String?
    let waiterID: String?
    let userID: String?
    let visitDate: String?
    let visitTime: String?
    let review: String?
    let rating: Int?
    let waiterTitle: String?
    let waiterImage: String?
    let RateDate : String?
}
public struct waiterRating: Codable {
    let ratingID: String?
    let restaurantID: String?
    let waiterID: String?
    let userID: String?
    let visitDate: String?
    let visitTime: String?
    let review: String?
    let rating: Int?
    let RateDate : String?
    enum CodingKeys: String, CodingKey {
        case ratingID = "WaiterRatingID"
        case restaurantID = "RestaurantID"
        case waiterID = "WaiterID"
        case userID = "UserID"
        case visitDate = "VisitDate"
        case visitTime = "VisitTime"
        case review = "Review"
        case rating = "Rating"
        case RateDate = "RateDate"
    }
}
public struct WaiterCompleteData: Codable{
    var waiter :Waiters
    var waiterRating : [waiterRating]
    var waiterAverageRating : Double?
    init(waiter: Waiters, waiterRating: [waiterRating] = [], waiterAverageRating: Double? = nil) {
        self.waiter = waiter
        self.waiterRating = waiterRating
        self.waiterAverageRating = waiterAverageRating
    }
}

public struct UserFavItemIDs{
    var itemID : String?
    var RestaurantID : String?
}

public enum DataType: Codable {
    case restaurant(Restaurant)
    case item(Item)
    case waiter(Waiters)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let restaurant = try? container.decode(Restaurant.self) {
            self = .restaurant(restaurant)
        } else if let item = try? container.decode(Item.self) {
            self = .item(item)
        } else if let waiter = try? container.decode(Waiters.self) {
            self = .waiter(waiter)
        } else {
            throw DecodingError.typeMismatch(DataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid data type"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .restaurant(let restaurant):
            try container.encode(restaurant)
        case .item(let item):
            try container.encode(item)
        case .waiter(let waiter):
            try container.encode(waiter)
        }
    }
}


// Mark Restaurant Offer Model


import Foundation

// MARK: - OfferRecord
struct OfferRecord: Codable {
    let partitionKey: String
    let rowKey: String
    let offerID: String
    let restaurantID: String
    let offerTitle: String?
    let description: String
    let discount: Double
    let startDate: String
    let endDate: String
    let eTag: [String: String]
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case partitionKey = "PartitionKey"
        case rowKey = "RowKey"
        case offerID = "OfferID"
        case restaurantID = "RestaurantID"
        case offerTitle = "OfferTitle"
        case description = "Description"
        case discount = "Discount"
        case startDate = "startDate"
        case endDate = "EndDate"
        case eTag = "eTag"
        case timestamp = "timestamp"
    }
}

// MARK: - OfferResponse
struct OfferResponse: Codable {
    let records: [OfferRecord]
    let record: String?
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case records
        case record
        case statusCode
        case statusMessage
    }
}




public struct ItemRatingReviewData{
    //Here we have to store user details also
    var  RowKey : String?
    var ItemRatingId : String?
    var RestaurantID : String?
    var UserID : String?
    var UserTitle : String?
    var UserImage : String?
    var Rating : Int?
    var Review : String?
    var RateDate : String?
    init(RowKey: String?, ItemRatingId: String? = nil, RestaurantID: String? = nil, UserID: String? = nil, UserTitle: String? = nil, UserImage: String? = nil, Rating: Int? = nil, Review: String? = nil, RateDate: String? = nil) {
        self.RowKey = RowKey
        self.ItemRatingId = ItemRatingId
        self.RestaurantID = RestaurantID
        self.UserID = UserID
        self.UserTitle = UserTitle
        self.UserImage = UserImage
        self.Rating = Rating
        self.Review = Review
        self.RateDate = RateDate
    }
    
}

