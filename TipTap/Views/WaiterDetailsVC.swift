////
////  WaiterDetailsVC.swift
////  TipTap
////
////  Created by Toqsoft on 19/12/23.
////
//
//import UIKit
//import TelrSDK
//
//class WaiterDetailsVC: UIViewController, UITextFieldDelegate{
//   //PaymentViewController
//    let KEY: String = "jT4F2^PjBp-n8jbr" // TODO: Fill key
//    let STOREID: String = "24717"
//    var EMAIL: String = "ashif@toqsoft.com"
// 
//    
//    @IBOutlet weak var indicator: UIActivityIndicatorView!
//    @IBOutlet weak var ImageView: UIView!
//    @IBOutlet weak var ratingView: UIView!
//    @IBOutlet weak var ratingCalculationView: UIView!
//    var getImageArray = [String]()
//    var restaurantImages = [RestaurantImage]()
//    var  ReviewDelegate : ReviewPostingDelegate?
//    var previousWaiterRatingByLoginUser :[waiterRatingUserData] = []
//    var userDataArray = [UserData]()
//    var waiterData : [WaiterCompleteData] = []
//    // var waiterRatingsArray = [waiterRating]()
//    var waiterRatingUserDataArray = [waiterRatingUserData]()
//    var waiterWorkedRestaurantsArray = [RestaurantCompleteData]()
//    var filteredRestaurantsArray = [RestaurantCompleteData]() // for search
//    var SelecterWaiterRatingArray = [waiterRating]()
//    var userRating :Int = 0
//    @IBOutlet weak var searchTF: UITextField!{
//        didSet{
//            searchTF.tintColor = .lightGray
//            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
//            searchTF.applyCustomPlaceholderStyle(size: "large")
//        }
//    }
//    @IBOutlet weak var reviewTableHeightConstraint: NSLayoutConstraint!
//    
//    
//    @IBOutlet weak var menuButton: UIButton!
//    
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var waiternameLabel: UILabel!
//    @IBOutlet weak var waiterEmaillabel: UILabel!
//    
//    @IBOutlet weak var starsViewIntro: CosmosView!
//    @IBOutlet weak var rateTheWaiterlabel: UILabel!
//    @IBOutlet weak var waiterImage: UIImageView!
//    @IBOutlet weak var contactLabel: UILabel!
//    @IBOutlet weak var DOJLabel: UILabel!
//    @IBOutlet weak var DOJTitleLabel: UILabel!
//    @IBOutlet weak var waiterReviewCount: UILabel!
//    @IBOutlet weak var starsView: CosmosView!
//    @IBOutlet weak var ratingsAndReviewHeadinglabel: UILabel!
//    @IBOutlet weak var allRatingdAndReviewsView: UIView!
//    @IBOutlet weak var leaveYourCommentView: UIView!
//    @IBOutlet weak var ratingsAndreviewsView: UIView!
//    
//    @IBOutlet weak var hintLabel: UILabel!
//    
//    @IBOutlet weak var viewAllButton2: UIButton!
//    @IBOutlet weak var ratedOutofLabel: UILabel!
//    @IBOutlet var ratingStarCollection: [UILabel]!
//    
//    @IBOutlet var ratingPercentLabelCollection: [UILabel]!
//    @IBOutlet weak var rateAndReviewButton: UIButton!
//    @IBOutlet weak var allRatingaAndReviewHeadingLabel: UILabel!
//    @IBOutlet weak var leaveaCommentTitleLAbel: UILabel!
//    @IBOutlet weak var rateThePlaceCommentLabel: UILabel!
//    @IBOutlet weak var yourCommentLabel: UILabel!
//    @IBOutlet weak var submitCommentButton: UIButton!
//    @IBOutlet weak var reviewTableView: UITableView!
//    @IBOutlet weak var MenuTableView: UITableView!
//    @IBOutlet weak var rateThisPlaceView: UIView!
//    @IBOutlet weak var menuTableviewHeight: NSLayoutConstraint!
//    @IBOutlet weak var seeAllReviewsButton: UIButton!
//    var isSearching = false
//    @IBOutlet weak var MenuView: UIView!
//    @IBOutlet weak var Allratingnreviewsview: UIView!
//    
//    @IBOutlet weak var rateTheWaiterUserAction: CosmosView!
//    
//    @IBOutlet weak var userEnteredWaiterRating: CosmosView!
//    
//    @IBOutlet weak var leaveAcommentTF: UITextField!
//    
//    @IBOutlet weak var fifthStarProgressView: UIProgressView!
//    @IBOutlet weak var fourthStarProgressView: UIProgressView!
//    @IBOutlet weak var threeStarProgressView: UIProgressView!
//    @IBOutlet weak var twoStarProgressView: UIProgressView!
//    @IBOutlet weak var oneStarProgressView: UIProgressView!
//    
//  
//    override func viewDidLoad() {
//        
//        DispatchQueue.main.async {
//      
//            super.viewDidLoad()
//           
//            self.hintLabel.isHidden = true
//            self.setUI()
//            self.DisplayWaiterData()
//            self.filteredRestaurantsArray = self.waiterWorkedRestaurantsArray
//            self.MenuTableView.delegate = self
//            self.MenuTableView.dataSource = self
//            self.reviewTableView.delegate = self
//            self.reviewTableView.dataSource = self
//            
//            // Set any additional properties if needed
//            self.rateTheWaiterUserAction.rating = 0
//            self.rateTheWaiterUserAction.text = ""
//            self.userEnteredWaiterRating.rating = 0
//            self.userEnteredWaiterRating.text = ""
//            self.rateTheWaiterUserAction.settings.fillMode = .full
//            
//            self.rateTheWaiterUserAction.settings.updateOnTouch = true
//            
//            // Add the closure to handle user interaction
//            self.rateTheWaiterUserAction.didTouchCosmos = { rating in
//                self.submitCommentButton.setTitle("Submit", for: .normal)
//                self.hintLabel.isHidden = true
//                print("User rated \(rating) stars")
//                self.userRating = Int(rating)
//                self.userEnteredWaiterRating.rating = rating
//                self.userEnteredWaiterRating.text = "\(rating)"
//                self.rateTheWaiterUserAction.rating = rating
//                self.rateTheWaiterUserAction.text = "\(rating)"
//            }
//            self.userEnteredWaiterRating.settings.fillMode = .full
//            
//            self.userEnteredWaiterRating.settings.updateOnTouch = true
//            
//            // Add the closure to handle user interaction
//            self.userEnteredWaiterRating.didTouchCosmos = { rating in
//                print("User rated \(rating) stars")
//                self.userRating = Int(rating)
//                self.rateTheWaiterUserAction.rating = rating
//                self.rateTheWaiterUserAction.text = "\(rating)"
//                self.userEnteredWaiterRating.rating = rating
//                self.userEnteredWaiterRating.text = "\(rating)"
//            }
//            self.leaveAcommentTF.delegate = self
//            let tipTapHomeVC = TipTapHomeVC()
//            self.ReviewDelegate = tipTapHomeVC
//        }
//        
//        DispatchQueue.main.async {
//            if self.previousWaiterRatingByLoginUser.count == 0 {
//                self.submitCommentButton.setTitle("Submit", for: .normal)
//                self.hintLabel.isHidden = true
//            }else if self.previousWaiterRatingByLoginUser.count == 1{
//                self.rateTheWaiterUserAction.rating = Double(self.previousWaiterRatingByLoginUser.first?.rating ?? 0)
//                self.submitCommentButton.setTitle("Give Tip", for: .normal)
//                self.hintLabel.isHidden = false
//            }
//        }
//      //PaymentViewController
//        let savedCards = getSavedCards()
//        if !savedCards.isEmpty {
//            // Directly navigate to payment method screen if there are saved cards
//            navigateToPaymentMethodScreen()
//        }
//    }
//    var paymentRequest: PaymentRequest?
//   
//    @IBOutlet weak var tripButton: UIButton!
//   
//    
//    @IBAction func tripButtonAction(_ sender: Any) {
//        let savedCards = getSavedCards()
//        if savedCards.isEmpty {
//            // Show card details screen if no saved cards
//            showCardDetailsScreen()
//        } else {
//            // Directly go to payment method screen if there are saved cards
//            navigateToPaymentMethodScreen()
//        }
//    }
//    private func startPayment(with paymentRequest: PaymentRequest) {
//        let customBackButton = UIButton(type: .custom)
//        customBackButton.setTitle("Back", for: .normal)
//        customBackButton.setTitleColor(.black, for: .normal)
//        let telrController = TelrController()
//        telrController.delegate = self
//        telrController.customBackButton = customBackButton
//        telrController.paymentRequest = paymentRequest
//        self.present(telrController, animated: true)
//    }
//    private func showCardDetailsScreen() {
//        // Assuming card details are entered in the current screen
//        let paymentRequest = preparePaymentRequest()
//        startPayment(with: paymentRequest)
//    }
//    private func navigateToPaymentMethodScreen() {
//        // Navigate to the payment method screen
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as! PaymentMethodViewController
//        controller.modalPresentationStyle = .fullScreen
//       let wa = waiterData[0].waiter.firstName
//        let image = waiterData[0].waiter.waiterImage
//        
//        controller.waiterData = wa!
//        controller.waiterImagesss = image ?? ""
//        self.present(controller, animated: true)
//    }
//    private func preparePaymentRequest() -> PaymentRequest {
//        let paymentReq = PaymentRequest()
//        
//        paymentReq.key = self.KEY
//        paymentReq.store = self.STOREID
//        paymentReq.appId = "123456789"
//        paymentReq.appName = "TelrSDK"
//        paymentReq.appUser = "123456"
//        paymentReq.appVersion = "0.0.1"
//        paymentReq.transTest = "1" // 0 for production
//        paymentReq.transType = "paypage"
//        paymentReq.transClass = "ecom"
//        paymentReq.transCartid = String(arc4random())
//        paymentReq.transDesc = "Test API"
//        paymentReq.transCurrency = "AED"
//        paymentReq.transAmount = "100"
//        paymentReq.billingEmail = EMAIL
//        paymentReq.billingPhone = "8888888888"
//        paymentReq.billingFName =  ""
//        paymentReq.billingLName =  ""
//        paymentReq.billingTitle = "Mr"
//        paymentReq.city = "Dubai"
//        paymentReq.country = "AE"
//        paymentReq.region = "Dubai"
//        paymentReq.address = "line1"
//        paymentReq.zip = "414202"
//        paymentReq.language = "en"
//        
//        return paymentReq
//    }
//    private func preparePaymentRequestSaveCard(lastResponse: TelrResponseModel) -> PaymentRequest {
//        let paymentReq = PaymentRequest()
//        
//        paymentReq.key = lastResponse.key ?? ""
//        paymentReq.store = lastResponse.store ?? ""
//        paymentReq.appId = lastResponse.appId ?? ""
//        paymentReq.appName = lastResponse.appName ?? ""
//        paymentReq.appUser = lastResponse.appUser ?? ""
//        paymentReq.appVersion = lastResponse.appVersion ?? ""
//        paymentReq.transTest = "1"
//        paymentReq.transType = "paypage"
//        paymentReq.transClass = "ecom"
//        paymentReq.transFirstRef = lastResponse.transFirstRef ?? ""
//        paymentReq.transCartid = String(arc4random())
//        paymentReq.transDesc = lastResponse.transDesc ?? ""
//        paymentReq.transCurrency = lastResponse.transCurrency ?? ""
//        paymentReq.billingFName = lastResponse.billingFName ?? ""
//        paymentReq.billingLName = lastResponse.billingLName ?? ""
//        paymentReq.billingTitle = lastResponse.billingTitle ?? ""
//        paymentReq.city = lastResponse.city ?? ""
//        paymentReq.country = lastResponse.country ?? ""
//        paymentReq.region = lastResponse.region ?? ""
//        paymentReq.address = lastResponse.address ?? ""
//        paymentReq.zip = lastResponse.zip ?? ""
//        paymentReq.transAmount = "100"
//        paymentReq.billingEmail = lastResponse.billingEmail ?? ""
//        paymentReq.billingPhone = lastResponse.billingPhone ?? ""
//        paymentReq.language = "en"
//        
//        return paymentReq
//    }
//    
//    // MARK: - Card Management (Save and Retrieve)
//    private func saveCardDetails(_ card: TelrResponseModel) {
//        var savedCards = getSavedCards()
//        savedCards.append(card)
//        
//        do {
//            let encoder = JSONEncoder()
//            let encodedCards = try encoder.encode(savedCards)
//            UserDefaults.standard.set(encodedCards, forKey: "savedCards")
//            UserDefaults.standard.synchronize()
//        } catch {
//            print("Error saving card details: \(error.localizedDescription)")
//        }
//    }
//    
//    private func getSavedCards() -> [TelrResponseModel] {
//        guard let savedCardsData = UserDefaults.standard.data(forKey: "savedCards") else {
//            return []
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            let savedCards = try decoder.decode([TelrResponseModel].self, from: savedCardsData)
//            return savedCards
//        } catch {
//            print("Error decoding saved cards data: \(error.localizedDescription)")
//            return []
//        }
//    }
//    // Function to hide the activity indicator
//    
//    @IBAction func SubmitReviewButtonAction(_ sender: UIButton) {
//        if submitCommentButton.currentTitle == "Submit" {
//            guard let loginUserID = loginUserID, loginUserID != "" else{
//                showAlert(title: "Error", message: "Invalid User attempting for adding Review")
//                return
//            }
//            
//            if previousWaiterRatingByLoginUser.count == 0{
//                // Show the alert with two options
//                
//                      let alert = UIAlertController(title: "Submit Review", message: "Thank You For Giving Rating. Would You Like To Give Tip?", preferredStyle: .alert)
//
//                      // Option 1: Give Rating Only
//                      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
//                          self.postCommentToWaiterRating()
//                          //let controller = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
//                         // self.present(controller, animated: true)
//                      }))
//
//                      // Option 2: With Tip
//                alert.addAction(UIAlertAction(title: "No, Close", style: .cancel, handler: {
//                    _ in
//                    self.postCommentToWaiterRating()
//                    self.reviewTableView.reloadData()
//                }))
//
//                      self.present(alert, animated: true, completion: nil)
//                  }
//            else{
//               updateWaiterReview()
//            }
//        }else if submitCommentButton.currentTitle == "Give Tip" {
//            //setUpPaymentPage()
//        }
//    }
//
//    func postCommentToWaiterRating() {
//            indicator.startAnimating()
//            let urlString = WaiterRatingsURL
//     
//            guard let apiUrl = URL(string: urlString) else {
//                indicator.stopAnimating()
//                print("Invalid URL: \(urlString)")
//                return
//            }
//     
//            print("Request URL: \(apiUrl)")
//            guard let loginUserID = loginUserID, loginUserID != "" else { return }
//     
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "POST"
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy/MM/dd"
//            let currentDate = dateFormatter.string(from: Date())
//     
//            dateFormatter.dateFormat = "HH:mm:ss"
//            let currentTime = dateFormatter.string(from: Date())
//     
//            let requestBody: [String: Any] =  [
//                "RestaurantID": waiterData[0].waiter.restaurantID ?? "",
//                "WaiterID": waiterData[0].waiter.waiterID ?? "",
//                "UserID": loginUserID,
//                "VisitDate": currentDate,
//                "VisitTime": currentTime,
//                "Rating": userRating,
//                "Review": "" ,
//                "RateDate": currentDate
//            ]
//     
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
//            } catch {
//                print("Error encoding request body: \(error)")
//                return
//            }
//     
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//     
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self.indicator.stopAnimating()
//                    }
//                    print("Error: \(error)")
//                    return
//                }
//     
//                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                    DispatchQueue.main.async {
//                        self.indicator.stopAnimating()
//     
//                        if let data = data {
//                            do {
//                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                                   let record = json["Record"] as? [String: Any],
//                                   let waiterRatingID = record["WaiterRatingID"] as? String {
//     
//                                    let newWaiterRating = waiterRating(
//                                        ratingID: waiterRatingID,
//                                        restaurantID: self.waiterData[0].waiter.restaurantID ?? "",
//                                        waiterID: self.waiterData[0].waiter.waiterID ?? "",
//                                        userID: loginUserID,
//                                        visitDate: currentDate,
//                                        visitTime: currentTime,
//                                        review: "Great service!",
//                                        rating: 5,
//                                        RateDate: currentDate
//                                    )
//     
//                                    // Update the local array
//                                    self.waiterData[0].waiterRating.append(newWaiterRating)
//                                    if let index = JsonDataArrays.WaiterCompleteDataArray
//                                        .firstIndex(where: { $0.waiter.waiterID == self.waiterData[0].waiter.waiterID }) {
//                                        JsonDataArrays.WaiterCompleteDataArray[index].waiterRating.append(newWaiterRating)
//                                        
//                                       // starsView.rating =
//                                    }
//                                    self.submitCommentButton.setTitle("Give Tip", for: .normal)
//                                    self.hintLabel.isHidden = false
//                                    self.reviewTableView.reloadData()
//                                    self.setRatingOnView()
//                                }
//                            } catch {
//                                print("Error decoding response data: \(error)")
//                            }
//                        }
//     
//                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
//                        controller.modalPresentationStyle = .fullScreen
//                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .waiter)
//                        controller.message = "Waiter ratings updated successfully"
//                        self.present(controller, animated: true)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.indicator.stopAnimating()
//                    }
//                }
//            }.resume()
//     
//        }
//        func updateWaiterReview() {
//            indicator.startAnimating()
//            
//            guard let updateURL = URL(string: WaiterRatingsURL) else {
//                indicator.stopAnimating()
//                print("Invalid API URL")
//                return
//            }
//            
//            guard let loginUserID = loginUserID, !loginUserID.isEmpty else {
//                return
//            }
//            
//            var request = URLRequest(url: updateURL)
//            request.httpMethod = "PUT"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            guard let previousWaiterRatingID = previousWaiterRatingByLoginUser.first?.WaiterRatingID else {
//                print("Waiter ID not found")
//                indicator.stopAnimating()
//                return
//            }
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy/MM/dd"
//            let currentDate = dateFormatter.string(from: Date())
//            
//            let updatedDetails: [String: Any] = [
//                "RowKey": previousWaiterRatingID,
//                "PartitionKey": "WaiterRatings",
//                "WaiterRatingID": previousWaiterRatingID,
//                "RestaurantID": waiterData[0].waiter.restaurantID ?? "",
//                "UserID": loginUserID,
//                "Rating": userRating,
//                "Review": "Removed",
//                "RatingDate": currentDate
//            ]
//            
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: updatedDetails)
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print("JSON data sent to server: \(jsonString)")
//                }
//                request.httpBody = jsonData
//            } catch {
//                indicator.stopAnimating()
//                print("Error encoding JSON: \(error.localizedDescription)")
//                return
//            }
//            
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    print("Error updating waiter details: \(error.localizedDescription)")
//                    DispatchQueue.main.async {
//                        self.showAlert(title: "Update Failed", message: "Failed to update restaurant ratings. Please try again.")
//                        self.indicator.stopAnimating()
//                    }
//                } else if let response = response as? HTTPURLResponse {
//                    if (200..<300).contains(response.statusCode) {
//                        if let data = data {
//                            let responseString = String(data: data, encoding: .utf8)
//                            print("Server response: \(responseString ?? "")")
//                        }
//                        
//                        self.fetchUpdatedwaiterReview(UpdatedWaiterRatingID: previousWaiterRatingID) {
//                            DispatchQueue.main.async {
//                                // Immediately reload UI after fetching updated review
//                                self.reviewTableView.reloadData()
//                                self.submitCommentButton.setTitle("Give Tip", for: .normal)
//                                self.hintLabel.isHidden = false
//                                
//                               
//                            }
//                        }
//                        
//                        print("Waiter review updated successfully")
//                        DispatchQueue.main.async {
//                            self.indicator.stopAnimating()
//                            
//                            let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
//                            controller.modalPresentationStyle = .fullScreen
//                            controller.message = "Waiter ratings updated successfully"
//                            self.ReviewDelegate?.didPostReviewSuccessfully(for: .waiter)
//                            self.present(controller, animated: true)
//                        }
//                        
//                    } else {
//                        print("Server returned an error: \(response.statusCode)")
//                        DispatchQueue.main.async {
//                            self.indicator.stopAnimating()
//                            self.showAlert(title: "Update Failed", message: "Failed to update restaurant ratings. Please try again.")
//                        }
//                    }
//                }
//            }
//            
//            task.resume()
//        }
//    
//    func fetchUpdatedwaiterReview(UpdatedWaiterRatingID: String, completion: @escaping () -> Void) {
//        var updatedReviewData: waiterRating?
//        let apiUrlString = WaiterRatingsURL + "?rowkey=\(UpdatedWaiterRatingID)"
//        
//        guard let apiUrl = URL(string: apiUrlString) else {
//            print("Invalid API URL")
//            return
//        }
//        
//        fetchJSONData(from: apiUrl) { [self] (result: Result<fetchWaiterRatingApiResponse, APIError>) in
//            switch result {
//            case .success(let jsondata):
//                if let record = jsondata.record {
//                    updatedReviewData = record
//                }
//                
//                if let indexOfRatingInSelectedWaiter = waiterData[0].waiterRating.firstIndex(where: { $0.ratingID == UpdatedWaiterRatingID }) {
//                    waiterData[0].waiterRating[indexOfRatingInSelectedWaiter] = updatedReviewData!
//                } else {
//                    if let newReviewData = updatedReviewData {
//                        waiterData[0].waiterRating.append(newReviewData)
//                        print(newReviewData)
//                    } else {
//                        print("Updated review data is nil")
//                    }
//                }
//                
//                // Update waiterRatingUserDataArray based on the new review
//                self.waiterRatingUserDataArray = self.waiterData[0].waiterRating.compactMap { rating in
//                    if let matchingUser = self.userDataArray.first(where: { $0.UserID == rating.userID }) {
//                        let userName = (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? "")
//                        return waiterRatingUserData(
//                            WaiterRatingID: rating.ratingID,
//                            waiterID: rating.waiterID,
//                            userID: rating.userID,
//                            rating: rating.rating,
//                            comments: rating.review,
//                            ratingDate: rating.visitDate,
//                            UserTitle: userName,
//                            UserImage: matchingUser.Userimage
//                        )
//                    }
//                    return nil
//                }
//                
//                // Ensure the table view is reloaded on the main thread
//                DispatchQueue.main.async {
//                    self.reviewTableView.reloadData()
//                    print(waiterRatingUserDataArray.count)
//                }
//                
//                completion()
//            case .failure(let error):
//                print("Error on fetchItemRatingJsonData: \(error)")
//            }
//        }
//    }
//
//    @IBAction func searchTextFieldChanged(_ sender: UITextField) {
//        print("searchTextFieldChanged called")
//        if let searchText = searchTF.text, !searchText.isEmpty {
//            isSearching = true
//            filterRestaurants(with: searchText)
//        } else {
//            isSearching = false
//            MenuTableView.reloadData()
//        }
//    }
//    
//    @IBAction func rateAndreviewAutoScroll(_ sender: UIButton) {
//        let offset = CGPoint(x: 0, y: rateThisPlaceView.frame.origin.y - scrollView.contentInset.top)
//        
//        scrollView.setContentOffset(offset, animated: true)
//    }
//    func filterRestaurants(with searchText: String) {
//        filteredRestaurantsArray = waiterWorkedRestaurantsArray.filter { restaurantData in
//            if let restaurantTitle = restaurantData.restaurant.RestaurantTitle {
//                // Unwrap the optional RestaurantTitle and check if it contains the searchText
//                return restaurantTitle.lowercased().contains(searchText.lowercased())
//            } else {
//                // Handle the case where RestaurantTitle is nil (optional chaining)
//                return false
//            }
//        }
//        MenuTableView.reloadData()
//    }
//    func DisplayWaiterData(){
//        waiternameLabel.text = (waiterData[0].waiter.firstName ?? "") + " " + (waiterData[0].waiter.lastName ?? "")
//        waiterEmaillabel.text = waiterData[0].waiter.email
//        waiterReviewCount.text = "(\(waiterData[0].waiterRating.count))"
//        starsViewIntro.text = "\(waiterData[0].waiterAverageRating ?? 0.0)"
//        starsViewIntro.rating = waiterData[0].waiterAverageRating ?? 0
//        DOJLabel.text = waiterData[0].waiter.joiningDate
//        
//        if let image = waiterData[0].waiter.waiterImage{
//            loadImage(from: image) { image  in
//                if let img = image {
//                    DispatchQueue.main.async {
//                        self.waiterImage.image = img
//                    }
//                }
//            }
//        }else{
//            DispatchQueue.main.async {
//                self.waiterImage.image = emptyImage
//            }
//        }
//        
//        fetchWaiterRatingsWithUserReview()
//        fetchWaiterWorkedRestaurants{
//            self.MenuTableView.reloadData()
//        }
//        setRatingOnView()
//    }
////    func fetchWaiterRatingsWithUserReview(){
////        
////        self.SelecterWaiterRatingArray = JsonDataArrays.waiterRatingArray.filter{ ratings in
////            return ratings.waiterID == self.waiterData[0].waiter.waiterID
////        }
////        for selectedWaiter in  SelecterWaiterRatingArray {
////            // Check if the user  contains a Item with the given ItemID
////            if let matchingUser = self.userDataArray.first(where: { $0.UserID == selectedWaiter.userID }) {
////                // If found, create a new userVisitedRestaurantData instance with the restaurant
////                let useName = (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? "")
////                // Append the new instance to the array
////                let waiterRatingUserData = waiterRatingUserData( WaiterRatingID: selectedWaiter.ratingID, waiterID: selectedWaiter.waiterID, userID: selectedWaiter.userID, rating: selectedWaiter.rating, comments: selectedWaiter.review, ratingDate: selectedWaiter.visitDate, UserTitle: useName, UserImage: matchingUser.Userimage)
////                self.waiterRatingUserDataArray.append(waiterRatingUserData)
////            }
////            // Handle the case where the restaurant is not found if needed
////            else {
////                // Handle the case where the restaurant is not found
////                // You might want to log an error or handle it in some way
////            }
////        }
////    }
////    
//    func fetchWaiterRatingsWithUserReview() {
//        // Clear existing data if needed
//        self.waiterRatingUserDataArray.removeAll()
//
//        // Filter waiter ratings based on the current waiter ID
//        self.SelecterWaiterRatingArray = JsonDataArrays.waiterRatingArray.filter { ratings in
//            return ratings.waiterID == self.waiterData[0].waiter.waiterID
//        }
//
//        for selectedWaiter in SelecterWaiterRatingArray {
//            if let matchingUser = self.userDataArray.first(where: { $0.UserID == selectedWaiter.userID }) {
//                let userName = (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? "")
//                let waiterRatingUserData = waiterRatingUserData(
//                    WaiterRatingID: selectedWaiter.ratingID,
//                    waiterID: selectedWaiter.waiterID,
//                    userID: selectedWaiter.userID,
//                    rating: selectedWaiter.rating,
//                    comments: selectedWaiter.review,
//                    ratingDate: selectedWaiter.visitDate,
//                    UserTitle: userName,
//                    UserImage: matchingUser.Userimage
//                )
//                self.waiterRatingUserDataArray.append(waiterRatingUserData)
//            } else {
//                // Handle the case where the user is not found
//                print("User with ID \(selectedWaiter.userID) not found")
//            }
//        }
//
//        // Ensure the table view is reloaded on the main thread
//        DispatchQueue.main.async {
//            self.reviewTableView.reloadData()
//        }
//    }
//
//    func fetchWaiterWorkedRestaurants( completion: @escaping () -> Void) {
//        
//        for waiter in waiterData {
//            let matchingRestaurants = JsonDataArrays.restaurantCompleteDataArray.filter { $0.restaurant.RestaurantID == waiter.waiter.restaurantID }
//            
//            for restaurant in matchingRestaurants {
//                // Check if the restaurant is not already in the array before appending
//                if !waiterWorkedRestaurantsArray.contains(where: { $0.restaurant.RestaurantID == restaurant.restaurant.RestaurantID }) {
//                    waiterWorkedRestaurantsArray.append(restaurant)
//                }
//            }
//        }
//        completion()
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        // Calculate the total height of the content
//        var contentHeight: CGFloat = 0
//        for subview in contentView.subviews {
//            contentHeight += subview.frame.size.height + 20
//        }
//        
//        // Set the contentSize to dynamically adjust the height
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentHeight + 20)
//    }
//    
//    func setUI(){
//        //  fetchUserData()
//        //backButton.backButtonStyle(
//        starsViewIntro.settings.fillMode = .precise
//        starsView.settings.fillMode = .precise
//        
//        MenuView.layer.cornerRadius = 5
//        MenuView.layer.shadowColor = UIColor.darkGray.cgColor
//        MenuView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        MenuView.layer.shadowRadius = 4
//        MenuView.layer.shadowOpacity = 0.5
//        MenuView.layer.masksToBounds = false
//        
//        ratingView.layer.cornerRadius = 5
//        ratingView.layer.shadowColor = UIColor.darkGray.cgColor
//        ratingView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        ratingView.layer.shadowRadius = 4
//        ratingView.layer.shadowOpacity = 0.5
//        ratingView.layer.masksToBounds = false
//        
//        ImageView.layer.cornerRadius = 5
//        ImageView.layer.shadowColor = UIColor.darkGray.cgColor
//        ImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        ImageView.layer.shadowRadius = 4
//        ImageView.layer.shadowOpacity = 0.5
//        ImageView.layer.masksToBounds = false
//        
//        rateThisPlaceView.layer.cornerRadius = 5
//        rateThisPlaceView.layer.shadowColor = UIColor.darkGray.cgColor
//        rateThisPlaceView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        rateThisPlaceView.layer.shadowRadius = 4
//        rateThisPlaceView.layer.shadowOpacity = 0.5
//        rateThisPlaceView.layer.masksToBounds = false
//        
//        leaveYourCommentView.layer.cornerRadius = 5
//        leaveYourCommentView.layer.shadowColor = UIColor.darkGray.cgColor
//        leaveYourCommentView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        leaveYourCommentView.layer.shadowRadius = 4
//        leaveYourCommentView.layer.shadowOpacity = 0.5
//        leaveYourCommentView.layer.masksToBounds = false
//        
//        ratingCalculationView.layer.cornerRadius = 5
//        ratingCalculationView.layer.shadowColor = UIColor.darkGray.cgColor
//        ratingCalculationView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        ratingCalculationView.layer.shadowRadius = 4
//        ratingCalculationView.layer.shadowOpacity = 0.5
//        ratingCalculationView.layer.masksToBounds = false
//        
//       
//        waiternameLabel.applyLabelStyle(for: .headingBlack)
//        waiterEmaillabel.applyLabelStyle(for: .subTitleLightGray)
//        waiterReviewCount.applyLabelStyle(for: .descriptionLightGray)
//        DOJTitleLabel.applyLabelStyle(for: .descriptionLightGray)
//        DOJLabel.applyLabelStyle(for: .descriptionLightGray)
//        //contactLabel.applyLabelStyle(for: .OfferWhite)
//        DOJTitleLabel.text = "Date of Joining :"
//        viewAllButton2.viewAllButtonStyle(title: "Top rated", systemImageName: "")
//        rateTheWaiterlabel.applyLabelStyle(for: .headingBlack)
//        ratingsAndReviewHeadinglabel.applyLabelStyle(for: .headingBlack)
//        
//        ratedOutofLabel.applyLabelStyle(for: .descriptionLightGray)
//        for ratingStars in ratingStarCollection {
//            ratingStars.applyLabelStyle(for: .descriptionLightGray)
//        }
//        for ratingpercentage in ratingPercentLabelCollection {
//            ratingpercentage.applyLabelStyle(for: .descriptionLightGray)
//        }
//        rateAndReviewButton.titleLabel?.applyLabelStyle(for: .OfferWhite)
//        allRatingaAndReviewHeadingLabel.applyLabelStyle(for: .headingBlack)
//        leaveaCommentTitleLAbel.applyLabelStyle(for: .headingBlack)
//        rateThePlaceCommentLabel.applyLabelStyle(for: .subTitleBlack)
//        yourCommentLabel.applyLabelStyle(for: .descriptionLightGray)
//        submitCommentButton.titleLabel?.applyLabelStyle(for: .OfferWhite)
//        
//        if waiterRatingUserDataArray.count >= 3{
//            self.seeAllReviewsButton.isHidden = false
//        }else{
//            self.seeAllReviewsButton.isHidden = true
//        }
//        
//        
//    }
//    
//    func setRatingOnView() {
//        var ratingCounts: [Int: Int] = [:]
//        var totalRatings: Int = 0
//        
//        
//        ratingCounts = Dictionary(grouping: waiterRatingUserDataArray) { waiterRating in
//            waiterRating.rating ?? 0 // Use 0 as the default value if rating is nil
//        }
//        .mapValues { ratings in
//            ratings.count
//        }
//        
//        // Calculate totalRatings
//        totalRatings = waiterRatingUserDataArray.count
//        
//        // Filter previousWaiterRatingByLoginUser
//        self.previousWaiterRatingByLoginUser = waiterRatingUserDataArray.filter { $0.userID == loginUserID }
//        
//        // Get previous review count and set text
//        let previousReviewCount = self.previousWaiterRatingByLoginUser.count
//        self.leaveAcommentTF.text = previousReviewCount > 0 ? self.previousWaiterRatingByLoginUser[0].comments : ""
//        self.yourCommentLabel.text = previousReviewCount > 0 ? "Your Previous Review" : "New Review"
//        self.rateTheWaiterUserAction.rating = previousReviewCount > 0 ? Double(self.previousWaiterRatingByLoginUser[0].rating ?? 0) : 0.0
//        self.userEnteredWaiterRating.rating = previousReviewCount > 0 ? Double(self.previousWaiterRatingByLoginUser[0].rating ?? 0) : 0.0
//        
//        self.userEnteredWaiterRating.text = previousReviewCount > 0 ?  "\(previousWaiterRatingByLoginUser[0].rating!)" : "0.0"
//       
//        self.ratedOutofLabel.text = "Rated \(waiterData[0].waiterAverageRating?.rounded(toPlaces: 2) ?? 0.0) out of 5"
//       
//        self.userRating = previousReviewCount > 0 ? previousWaiterRatingByLoginUser[0].rating! : 0
//        
//        
//        // Update UIProgressViews
//        self.fifthStarProgressView.progress = Float(ratingCounts[5] ?? 0) / Float(totalRatings)
//        self.fourthStarProgressView.progress = Float(ratingCounts[4] ?? 0) / Float(totalRatings)
//        self.threeStarProgressView.progress = Float(ratingCounts[3] ?? 0) / Float(totalRatings)
//        self.twoStarProgressView.progress = Float(ratingCounts[2] ?? 0) / Float(totalRatings)
//        self.oneStarProgressView.progress = Float(ratingCounts[1] ?? 0) / Float(totalRatings)
//        
//        // Update UILabels with count
//        self.ratingPercentLabelCollection[0].text = "\(ratingCounts[5] ?? 0)"
//        self.ratingPercentLabelCollection[1].text = "\(ratingCounts[4] ?? 0)"
//        self.ratingPercentLabelCollection[2].text = "\(ratingCounts[3] ?? 0)"
//        self.ratingPercentLabelCollection[3].text = "\(ratingCounts[2] ?? 0)"
//        self.ratingPercentLabelCollection[4].text = "\(ratingCounts[1] ?? 0)"
//        
//        // Calculate sumOfRatings and averageRating
//        let sumOfRatings = waiterRatingUserDataArray.compactMap { $0.rating }.reduce(0, +)
//        let averageRating = totalRatings > 0 ? Double(sumOfRatings) / Double(totalRatings) : 0
//        
//        // Update starsView and ratedOutofLabel
//        self.starsView.rating = averageRating
//        self.starsView.text = "\(totalRatings)"
//        self.ratedOutofLabel.text = "Rated \(averageRating.rounded(toPlaces: 2)) out of 5"
//        self.starsViewIntro.rating = averageRating
//        self.starsViewIntro.text = "\(totalRatings)"
//    }
//    
//    @IBAction func backBtnAction(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
//    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
//        //menuButton.setImage(UIImage(systemName: "xmark"), for: .normal)
//        if (sender.tag == 10)
//        {
//            // To Hide Menu If it already there
//            sender.tag = 0;
//            let viewMenuBack : UIView = view.subviews.last!
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                var frameMenu : CGRect = viewMenuBack.frame
//                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
//                viewMenuBack.frame = frameMenu
//                viewMenuBack.layoutIfNeeded()
//                viewMenuBack.backgroundColor = UIColor.clear
//            }, completion: { (finished) -> Void in
//                viewMenuBack.removeFromSuperview()
//            })
//            return
//        }
//        sender.isEnabled = false
//        sender.tag = 10
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let menuVC : LeftMenuViewController = storyBoard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
//        menuVC.btnMenu = sender
//        // menuVC.delegate = self as? SlideMenuDelegate
//        self.view.addSubview(menuVC.view)
//        self.addChild(menuVC)
//        self.navigationController?.isNavigationBarHidden = true
//        //  self.present(menuVC, animated: true)
//        menuVC.view.layoutIfNeeded()
//        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//            sender.isEnabled = true
//        }, completion:nil)
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        // Hide the keyboard
//        leaveAcommentTF.resignFirstResponder()
//        return true
//    }
//}
//extension WaiterDetailsVC: UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == MenuTableView{
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
//            let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.size.width / 2 , height: 22))
//            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//            titleLabel.textColor = UIColor.black
//            let subtitleLabel = UILabel(frame: CGRect(x: titleLabel.frame.size.width + 5, y: 0, width: headerView.frame.size.width / 3, height: 22))
//            subtitleLabel.font = UIFont.systemFont(ofSize: 14)
//            subtitleLabel.textColor = UIColor.gray
//            headerView.addSubview(titleLabel)
//            headerView.addSubview(subtitleLabel)
//            titleLabel.text = "Restaurants"
//            // subtitleLabel.text = "\(waiterModel.count) waiters"
//            return headerView
//        }
//        else{
//            return nil
//        }
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == MenuTableView{
//            return isSearching ? (filteredRestaurantsArray.isEmpty ? 1 : filteredRestaurantsArray.count) : (waiterWorkedRestaurantsArray.isEmpty ? 1 : waiterWorkedRestaurantsArray.count)
//        }else{
//            waiterRatingUserDataArray.count
//        }
//       return 0
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == MenuTableView{
//            var restaurant: RestaurantCompleteData
//            // let restaurant = waiterWorkedRestaurantsArray[indexPath.row]
//            if isSearching{
//                if filteredRestaurantsArray.isEmpty{
//                    //empty cell
//                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
//                    emptyCell.textLabel?.text = "No restaurant's found"
//                    
//                    emptyCell.textLabel?.textAlignment = .center
//                    return emptyCell
//                }else{
//                    let menuCell = MenuTableView.dequeueReusableCell(withIdentifier: "RestaurantMenuTVC", for: indexPath)as! RestaurantMenuTVC
//                    restaurant = filteredRestaurantsArray[indexPath.row]
//                    menuCell.configureRestaurant(with: restaurant)
//                    return menuCell
//                }
//            }else{
//                if waiterWorkedRestaurantsArray.isEmpty{
//                    //empty cell
//                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
//                    emptyCell.textLabel?.text = "No restaurant's found"
//                    emptyCell.textLabel?.textAlignment = .center
//                    return emptyCell
//                }else{
//                    let menuCell = MenuTableView.dequeueReusableCell(withIdentifier: "RestaurantMenuTVC", for: indexPath)as! RestaurantMenuTVC
//                    restaurant = waiterWorkedRestaurantsArray[indexPath.row]
//                    menuCell.configureRestaurant(with: restaurant)
//                    return menuCell
//                }
//            }
//            
//        }
//        else{
//            if waiterRatingUserDataArray.count == 0{
//                let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
//                emptyCell.textLabel?.text = "No Reviews for waiter"
//                emptyCell.textLabel?.textAlignment = .center
//                return emptyCell
//            }else{
//                let reviewCell = reviewTableView.dequeueReusableCell(withIdentifier: "ViewAllReviewsTVC")as! ViewAllReviewsTVC
//                let review = waiterRatingUserDataArray[indexPath.row]
//                reviewCell.configureWithWaiter(with: review, currentUserId: loginUserID!)
//                return reviewCell
//            }
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == MenuTableView{
//            return 170
//        }else{
//            if waiterRatingUserDataArray.isEmpty{
//                return 40
//            }
//            else{
//                return 180
//            }
//            
//            
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == MenuTableView{
//            let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
//            let selectedFood = waiterWorkedRestaurantsArray[indexPath.row]
//            restarantHomeVC.selectedFor = "restaurant"
//            restarantHomeVC.modalPresentationStyle = .fullScreen
//            restarantHomeVC.modalTransitionStyle = .coverVertical
//            // restarantHomeVC.restaurantName = selectedFoodName
//           
//            restarantHomeVC.selectedRestaurantData = [selectedFood]
//            self.present(restarantHomeVC, animated: true, completion: nil)
//        }
//    }
//}
//    extension WaiterDetailsVC: TelrControllerDelegate {
//        
//        func didPaymentCancel() {
//            print("Payment Cancelled")
//        }
//        func didPaymentFail(messge message: String) {
//            print("Payment Failed: \(message)")
//        }
//        func didPaymentSuccess(response: TelrResponseModel) {
//            // Save the card details for future use
//            saveCardDetails(response)
//            
//            // Print the last 4 digits of the card number
//            if let cardLast4 = response.cardLast4 {
//                print("Card Last 4 Digits: \(cardLast4)")
//            } else {
//                print("Card Last 4 Digits not available")
//            }
//            // Assuming the cardholder's name is inputted and stored elsewhere in the app
//            if let billingFName = response.billingFName, let billingLName = response.billingLName {
//                let cardholderName = "\(billingFName) \(billingLName)"
//                print("Cardholder Name: \(cardholderName)")
//            } else {
//                print("Cardholder Name not available")
//            }
//            
//            // Show completion message or alert
//            showPaymentCompletionAlert()
//        }
//        private func showPaymentCompletionAlert() {
//            let alert = UIAlertController(title: "Payment Successful", message: "Your payment has been completed.", preferredStyle: .alert)
//            self.navigateToPaymentMethodScreen()
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                // Navigate to payment method screen after user acknowledges
//                self.navigateToPaymentMethodScreen()
//            }))
//            
//            present(alert, animated: true, completion: nil)
//        }
//    }
//
//
//

import UIKit
import TelrSDK

class WaiterDetailsVC: UIViewController, UITextFieldDelegate{
    //PaymentViewController
    let KEY: String = "jT4F2^PjBp-n8jbr" // TODO: Fill key
    let STOREID: String = "24717"
    var EMAIL: String = "ashif@toqsoft.com"
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var ImageView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingCalculationView: UIView!
    var getImageArray = [String]()
    var restaurantImages = [RestaurantImage]()
    var  ReviewDelegate : ReviewPostingDelegate?
    var previousWaiterRatingByLoginUser :[waiterRatingUserData] = []
    var userDataArray = [UserData]()
    var waiterData : [WaiterCompleteData] = []
    // var waiterRatingsArray = [waiterRating]()
    var waiterRatingUserDataArray = [waiterRatingUserData]()
    var waiterWorkedRestaurantsArray = [RestaurantCompleteData]()
    var filteredRestaurantsArray = [RestaurantCompleteData]() // for search
    var SelecterWaiterRatingArray = [waiterRating]()
    var userRating :Int = 0
    @IBOutlet weak var searchTF: UITextField!{
        didSet{
            searchTF.tintColor = .lightGray
            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
            searchTF.applyCustomPlaceholderStyle(size: "large")
        }
    }
    @IBOutlet weak var reviewTableHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var waiternameLabel: UILabel!
    @IBOutlet weak var waiterEmaillabel: UILabel!
    
    @IBOutlet weak var starsViewIntro: CosmosView!
    @IBOutlet weak var rateTheWaiterlabel: UILabel!
    @IBOutlet weak var waiterImage: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var DOJLabel: UILabel!
    @IBOutlet weak var DOJTitleLabel: UILabel!
    @IBOutlet weak var waiterReviewCount: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var ratingsAndReviewHeadinglabel: UILabel!
    @IBOutlet weak var allRatingdAndReviewsView: UIView!
    @IBOutlet weak var leaveYourCommentView: UIView!
    @IBOutlet weak var ratingsAndreviewsView: UIView!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var viewAllButton2: UIButton!
    @IBOutlet weak var ratedOutofLabel: UILabel!
    @IBOutlet var ratingStarCollection: [UILabel]!
    
    @IBOutlet var ratingPercentLabelCollection: [UILabel]!
    @IBOutlet weak var rateAndReviewButton: UIButton!
    @IBOutlet weak var allRatingaAndReviewHeadingLabel: UILabel!
    @IBOutlet weak var leaveaCommentTitleLAbel: UILabel!
    @IBOutlet weak var rateThePlaceCommentLabel: UILabel!
    @IBOutlet weak var yourCommentLabel: UILabel!
    @IBOutlet weak var submitCommentButton: UIButton!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var rateThisPlaceView: UIView!
    @IBOutlet weak var menuTableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var seeAllReviewsButton: UIButton!
    var isSearching = false
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var Allratingnreviewsview: UIView!
    
    @IBOutlet weak var rateTheWaiterUserAction: CosmosView!
    
    @IBOutlet weak var userEnteredWaiterRating: CosmosView!
    
    @IBOutlet weak var leaveAcommentTF: UITextField!
    
    @IBOutlet weak var fifthStarProgressView: UIProgressView!
    @IBOutlet weak var fourthStarProgressView: UIProgressView!
    @IBOutlet weak var threeStarProgressView: UIProgressView!
    @IBOutlet weak var twoStarProgressView: UIProgressView!
    @IBOutlet weak var oneStarProgressView: UIProgressView!
    
    
    override func viewDidLoad() {
        
        DispatchQueue.main.async {
            
            super.viewDidLoad()
            
            self.hintLabel.isHidden = true
            self.setUI()
            self.DisplayWaiterData()
            self.filteredRestaurantsArray = self.waiterWorkedRestaurantsArray
            self.MenuTableView.delegate = self
            self.MenuTableView.dataSource = self
            self.reviewTableView.delegate = self
            self.reviewTableView.dataSource = self
            
            // Set any additional properties if needed
            self.rateTheWaiterUserAction.rating = 0
            self.rateTheWaiterUserAction.text = ""
            self.userEnteredWaiterRating.rating = 0
            self.userEnteredWaiterRating.text = ""
            self.rateTheWaiterUserAction.settings.fillMode = .full
            
            self.rateTheWaiterUserAction.settings.updateOnTouch = true
            
            // Add the closure to handle user interaction
            self.rateTheWaiterUserAction.didTouchCosmos = { rating in
                self.submitCommentButton.setTitle("Submit", for: .normal)
                self.hintLabel.isHidden = true
                print("User rated \(rating) stars")
                self.userRating = Int(rating)
                self.userEnteredWaiterRating.rating = rating
                self.userEnteredWaiterRating.text = "\(rating)"
                self.rateTheWaiterUserAction.rating = rating
                self.rateTheWaiterUserAction.text = "\(rating)"
            }
            self.userEnteredWaiterRating.settings.fillMode = .full
            
            self.userEnteredWaiterRating.settings.updateOnTouch = true
            
            // Add the closure to handle user interaction
            self.userEnteredWaiterRating.didTouchCosmos = { rating in
                print("User rated \(rating) stars")
                self.userRating = Int(rating)
                self.rateTheWaiterUserAction.rating = rating
                self.rateTheWaiterUserAction.text = "\(rating)"
                self.userEnteredWaiterRating.rating = rating
                self.userEnteredWaiterRating.text = "\(rating)"
            }
            self.leaveAcommentTF.delegate = self
            let tipTapHomeVC = TipTapHomeVC()
            self.ReviewDelegate = tipTapHomeVC
        }
        
        DispatchQueue.main.async {
            if self.previousWaiterRatingByLoginUser.count == 0 {
                self.submitCommentButton.setTitle("Submit", for: .normal)
                self.hintLabel.isHidden = true
            }else if self.previousWaiterRatingByLoginUser.count == 1{
                self.rateTheWaiterUserAction.rating = Double(self.previousWaiterRatingByLoginUser.first?.rating ?? 0)
                self.submitCommentButton.setTitle("Give Tip", for: .normal)
                self.hintLabel.isHidden = false
            }
        }
        //PaymentViewController
        let savedCards = getSavedCards()
        if !savedCards.isEmpty {
            // Directly navigate to payment method screen if there are saved cards
            navigateToPaymentMethodScreen()
        }
    }
    var paymentRequest: PaymentRequest?
    
    @IBOutlet weak var tripButton: UIButton!
    
    
    @IBAction func tripButtonAction(_ sender: Any) {
        let savedCards = getSavedCards()
        if savedCards.isEmpty {
            // Show card details screen if no saved cards
            showCardDetailsScreen()
        } else {
            // Directly go to payment method screen if there are saved cards
            navigateToPaymentMethodScreen()
        }
    }
    private func startPayment(with paymentRequest: PaymentRequest) {
        let customBackButton = UIButton(type: .custom)
        customBackButton.setTitle("Back", for: .normal)
        customBackButton.setTitleColor(.black, for: .normal)
        let telrController = TelrController()
        telrController.delegate = self
        telrController.customBackButton = customBackButton
        telrController.paymentRequest = paymentRequest
        self.present(telrController, animated: true)
    }
    private func showCardDetailsScreen() {
        // Assuming card details are entered in the current screen
        let paymentRequest = preparePaymentRequest()
        startPayment(with: paymentRequest)
    }
    private func navigateToPaymentMethodScreen() {
        // Navigate to the payment method screen
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as! PaymentMethodViewController
        controller.modalPresentationStyle = .fullScreen
        let wa = waiterData[0].waiter.firstName
        let image = waiterData[0].waiter.waiterImage
        
        controller.waiterData = wa!
        controller.waiterImagesss = image ?? ""
        self.present(controller, animated: true)
    }
    private func preparePaymentRequest() -> PaymentRequest {
        let paymentReq = PaymentRequest()
        
        paymentReq.key = self.KEY
        paymentReq.store = self.STOREID
        paymentReq.appId = "123456789"
        paymentReq.appName = "TelrSDK"
        paymentReq.appUser = "123456"
        paymentReq.appVersion = "0.0.1"
        paymentReq.transTest = "1" // 0 for production
        paymentReq.transType = "paypage"
        paymentReq.transClass = "ecom"
        paymentReq.transCartid = String(arc4random())
        paymentReq.transDesc = "Test API"
        paymentReq.transCurrency = "AED"
        paymentReq.transAmount = "100"
        paymentReq.billingEmail = EMAIL
        paymentReq.billingPhone = "8888888888"
        paymentReq.billingFName =  ""
        paymentReq.billingLName =  ""
        paymentReq.billingTitle = "Mr"
        paymentReq.city = "Dubai"
        paymentReq.country = "AE"
        paymentReq.region = "Dubai"
        paymentReq.address = "line1"
        paymentReq.zip = "414202"
        paymentReq.language = "en"
        
        return paymentReq
    }
    private func preparePaymentRequestSaveCard(lastResponse: TelrResponseModel) -> PaymentRequest {
        let paymentReq = PaymentRequest()
        
        paymentReq.key = lastResponse.key ?? ""
        paymentReq.store = lastResponse.store ?? ""
        paymentReq.appId = lastResponse.appId ?? ""
        paymentReq.appName = lastResponse.appName ?? ""
        paymentReq.appUser = lastResponse.appUser ?? ""
        paymentReq.appVersion = lastResponse.appVersion ?? ""
        paymentReq.transTest = "1"
        paymentReq.transType = "paypage"
        paymentReq.transClass = "ecom"
        paymentReq.transFirstRef = lastResponse.transFirstRef ?? ""
        paymentReq.transCartid = String(arc4random())
        paymentReq.transDesc = lastResponse.transDesc ?? ""
        paymentReq.transCurrency = lastResponse.transCurrency ?? ""
        paymentReq.billingFName = lastResponse.billingFName ?? ""
        paymentReq.billingLName = lastResponse.billingLName ?? ""
        paymentReq.billingTitle = lastResponse.billingTitle ?? ""
        paymentReq.city = lastResponse.city ?? ""
        paymentReq.country = lastResponse.country ?? ""
        paymentReq.region = lastResponse.region ?? ""
        paymentReq.address = lastResponse.address ?? ""
        paymentReq.zip = lastResponse.zip ?? ""
        paymentReq.transAmount = "100"
        paymentReq.billingEmail = lastResponse.billingEmail ?? ""
        paymentReq.billingPhone = lastResponse.billingPhone ?? ""
        paymentReq.language = "en"
        
        return paymentReq
    }
    
    // MARK: - Card Management (Save and Retrieve)
    private func saveCardDetails(_ card: TelrResponseModel) {
        var savedCards = getSavedCards()
        savedCards.append(card)
        
        do {
            let encoder = JSONEncoder()
            let encodedCards = try encoder.encode(savedCards)
            UserDefaults.standard.set(encodedCards, forKey: "savedCards")
            UserDefaults.standard.synchronize()
        } catch {
            print("Error saving card details: \(error.localizedDescription)")
        }
    }
    
    private func getSavedCards() -> [TelrResponseModel] {
        guard let savedCardsData = UserDefaults.standard.data(forKey: "savedCards") else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let savedCards = try decoder.decode([TelrResponseModel].self, from: savedCardsData)
            return savedCards
        } catch {
            print("Error decoding saved cards data: \(error.localizedDescription)")
            return []
        }
    }
    // Function to hide the activity indicator
    
    @IBAction func SubmitReviewButtonAction(_ sender: UIButton) {
        if submitCommentButton.currentTitle == "Submit" {
            guard let loginUserID = loginUserID, loginUserID != "" else{
                showAlert(title: "Error", message: "Invalid User attempting for adding Review")
                return
            }
            
            if previousWaiterRatingByLoginUser.count == 0{
                // Show the alert with two options
                
                let alert = UIAlertController(title: "Submit Review", message: "Thank You For Giving Rating. Would You Like To Give Tip?", preferredStyle: .alert)
                
                // Option 1: Give Rating Only
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.postCommentToWaiterRating()
                    //let controller = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                    // self.present(controller, animated: true)
                }))
                
                // Option 2: With Tip
                alert.addAction(UIAlertAction(title: "No, Close", style: .cancel, handler: {
                    _ in
                    self.postCommentToWaiterRating()
                    self.reviewTableView.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                updateWaiterReview()
            }
        }else if submitCommentButton.currentTitle == "Give Tip" {
            //setUpPaymentPage()
        }
    }
    //    func postCommentToWaiterRating(){
    //        self.showHUD()
    //        let urlString = WaiterRatingsURL
    //        guard let apiUrl = URL(string: urlString) else {
    //            self.hideHUD()
    //            print("Invalid URL: \(urlString)")
    //            return
    //        }
    //        print("Request URL: \(apiUrl)")
    //        guard let loginUserID = loginUserID, loginUserID != "" else{ return}
    //        // Create the URLRequest
    //        var request = URLRequest(url: apiUrl)
    //        request.httpMethod = "POST"
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy/MM/dd"
    //        let currentDate = dateFormatter.string(from: Date())
    //
    //        dateFormatter.dateFormat = "HH:mm:ss"
    //        let currentTime = dateFormatter.string(from: Date())
    //        // Create the request body
    //        let requestBody: [String: Any] =  [
    //            "RestaurantID": waiterData[0].waiter.restaurantID ?? "",
    //            "WaiterID": waiterData[0].waiter.waiterID ?? "",
    //            "UserID": loginUserID,
    //            "VisitDate": currentDate,
    //            "VisitTime": currentTime,
    //            //     "UserId": loginUserID,
    //            "Rating": userRating,
    //            "Review": "" ,
    //            "RateDate" : currentDate
    //        ]
    //        // Convert the request body to JSON data
    //        do {
    //            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    //        } catch {
    //            print("Error encoding request body: \(error)")
    //            return
    //        }
    //        // Set the request headers
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
    //        // Perform the request
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            if let error = error {
    //                self.showHUD()
    //                print("Error: \(error)")
    //                return
    //            }
    //            // Handle the response
    //            if let httpResponse = response as? HTTPURLResponse {
    //                print("HTTP Status Code: \(httpResponse.statusCode)")
    //                if httpResponse.statusCode == 200 {
    //                    // print("waiter ratings updated successfully")
    //                    DispatchQueue.main.async {
    //                        self.hideHUD()
    //                        if let data = data {
    //                            do {
    //                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
    //                                    if let record = json["Record"] as? [String: Any] {
    //                                        if let WaiterRatingID = record["WaiterRatingID"] as? String {
    //
    //                                            self.leaveAcommentTF.text = record["Review"] as? String
    //                                            self.fetchUpdatedwaiterReview(UpdatedWaiterRatingID: WaiterRatingID){
    //                                            }
    //                                        }
    //                                    }
    //                                }
    //                            } catch {
    //                                print("Error decoding response data: \(error)")
    //                            }
    //                        }
    //                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
    //                        controller.modalPresentationStyle = .fullScreen
    //                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .waiter)
    //                        controller.message = "Waiter ratings updated successfully"
    //                        self.present(controller, animated: true)
    //                    }
    //
    //                    // You may want to perform additional actions here if needed
    //                } else {
    //                    self.hideHUD()
    //                    print("HTTP Status Code: \(httpResponse.statusCode)")
    //                    // Handle other status codes if needed
    //                }
    //            }
    //        }.resume()
    //    }
    func postCommentToWaiterRating() {
        self.showHUD()
        let urlString = WaiterRatingsURL
        guard let apiUrl = URL(string: urlString) else {
            self.hideHUD()
            print("Invalid URL: \(urlString)")
            return
        }
        
        guard let loginUserID = loginUserID, loginUserID != "" else { return }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        
        let requestBody: [String: Any] = [
            "RestaurantID": waiterData[0].waiter.restaurantID ?? "",
            "WaiterID": waiterData[0].waiter.waiterID ?? "",
            "UserID": loginUserID,
            "VisitDate": currentDate,
            "VisitTime": currentTime,
            "Rating": userRating,
            "Review": "",
            "RateDate": currentDate
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.hideHUD()
                    print("Error: \(error)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                   let record = json["record"] as? [String: Any],
                                   let WaiterRatingID = record["WaiterRatingID"] as? String {
                                    self.leaveAcommentTF.text = record["Review"] as? String
                                    self.fetchUpdatedwaiterReview(UpdatedWaiterRatingID: WaiterRatingID) {
                                        DispatchQueue.main.async {
                                            self.setRatingOnView()
                                        }
                                    }
                                }
                            } catch {
                                print("Error decoding response data: \(error)")
                            }
                        }
                        
                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                        controller.modalPresentationStyle = .fullScreen
                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .waiter)
                        controller.message = "Waiter ratings updated successfully"
                        self.present(controller, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        print("HTTP Status Code: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }
    
    
    func updateWaiterReview(){
        self.reviewTableView.reloadData()
        self.showHUD()
        guard let updateURL = URL(string: WaiterRatingsURL) else {
            self.hideHUD()
            print("Invalid API URL")
            return
        }
        guard let loginUserID = loginUserID,!loginUserID.isEmpty else{
            return
        }
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let previuosWaiterRatingID = previousWaiterRatingByLoginUser.first?.WaiterRatingID else {
            print("Waiter ID not found")
            self.hideHUD()
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        let updatedDetails: [String: Any] = [
            "RowKey": previuosWaiterRatingID,
            "PartitionKey": "WaiterRatings",
            "WaiterRatingID" : previuosWaiterRatingID,
            "RestaurantID": waiterData[0].waiter.restaurantID ?? "",
            "UserID": loginUserID,
            "Rating": userRating,
            "Review": "Removed",
            "RatingDate": currentDate
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updatedDetails)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON data sent to server: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            self.hideHUD()
            print("Error encoding JSON: \(error.localizedDescription)")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error updating waiter details: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Update Failed", message: "Failed to update restaurant ratings. Please try again.")
                    //self.indicator.stopAnimating()
                }
            } else if let response = response as? HTTPURLResponse {
                if (200..<300).contains(response.statusCode) {
                    if let data = data {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Server response: \(responseString ?? "")")
                    }
                    self.fetchUpdatedwaiterReview(UpdatedWaiterRatingID: previuosWaiterRatingID){
                        DispatchQueue.main.async {
                            self.setRatingOnView()
                        }
                    }
                    print("Restaurant review updated successfully")
                    DispatchQueue.main.async {
                        self.hideHUD()
                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                        controller.modalPresentationStyle = .fullScreen
                        controller.message = "Waiter ratings updated successfully"
                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .waiter)
                        self.present(controller, animated: true)
                    }
                } else {
                    print("Server returned an error: \(response.statusCode)")
                    // Handle the error appropriately (e.g., show an alert)
                    DispatchQueue.main.async {
                        self.hideHUD()
                        self.showAlert(title: "Update Failed", message: "Failed to update restaurant ratings. Please try again.")
                    }
                }
            }
        }
        task.resume()
    }
    //    func fetchUpdatedwaiterReview(UpdatedWaiterRatingID: String, completion: @escaping () -> Void) {
    //        var updatedReviewData: waiterRating?
    //        let apiUrlString = WaiterRatingsURL + "?rowkey=\(UpdatedWaiterRatingID)"
    //
    //        guard let apiUrl = URL(string: apiUrlString) else {
    //            print("Invalid API URL")
    //            return
    //        }
    //
    //        fetchJSONData(from: apiUrl) { [self] (result: Result<fetchWaiterRatingApiResponse, APIError>) in
    //            switch result {
    //            case .success(let jsondata):
    //
    //
    //                if let record = jsondata.record{
    //                    updatedReviewData = record
    //                }
    //
    //                if let indexOfRatingInSelectedWaiter = SelecterWaiterRatingArray.firstIndex(where: { $0.ratingID == UpdatedWaiterRatingID }) {
    //                    SelecterWaiterRatingArray[indexOfRatingInSelectedWaiter] = updatedReviewData!
    //                } else {
    //                    if let newReviewData = updatedReviewData {
    //                        SelecterWaiterRatingArray.append(newReviewData)
    //                    } else {
    //                        // Handle the case where updatedReviewData is nil
    //                        print("Updated review data is nil")
    //                    }
    //                }
    //
    //
    //                // Find the index of the item in the array
    //                if let index = JsonDataArrays.WaiterCompleteDataArray.firstIndex(where: { $0.waiter.waiterID == waiterData[0].waiter.waiterID }) {
    //                    // Make sure ItemRatings property is accessible
    //                    var updatedWaiterCompleteData = JsonDataArrays.WaiterCompleteDataArray[index]
    //
    //                    // Update the ItemRatings array in the found item
    //                    updatedWaiterCompleteData.waiterRating = updatedWaiterCompleteData.waiterRating.map { waiterRating in
    //                        var updatedWaiterRating = waiterRating
    //                        if waiterRating.ratingID == UpdatedWaiterRatingID {
    //                            // Update the properties of the ItemRating based on your logic
    //                            updatedWaiterRating = updatedReviewData!
    //                        }
    //                        return updatedWaiterRating
    //                    }
    //
    //
    //                    JsonDataArrays.WaiterCompleteDataArray[index] = updatedWaiterCompleteData
    //                }
    //                completion()
    //            case .failure(let error):
    //                print("Error on fetchItemRatingJsonData: \(error)")
    //            }
    //        }
    //    }
    //
    func fetchUpdatedwaiterReview(UpdatedWaiterRatingID: String, completion: @escaping () -> Void) {
        var updatedReviewData: waiterRating?
        let apiUrlString = WaiterRatingsURL + "?rowkey=\(UpdatedWaiterRatingID)"
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        fetchJSONData(from: apiUrl) { [self] (result: Result<fetchWaiterRatingApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                if let record = jsondata.record {
                    updatedReviewData = record
                }
                
                if let indexOfRatingInSelectedWaiter = SelecterWaiterRatingArray.firstIndex(where: { $0.ratingID == UpdatedWaiterRatingID }) {
                    SelecterWaiterRatingArray[indexOfRatingInSelectedWaiter] = updatedReviewData!
                } else {
                    if let newReviewData = updatedReviewData {
                        SelecterWaiterRatingArray.append(newReviewData)
                        print(newReviewData)
                    } else {
                        print("Updated review data is nil")
                    }
                }
                
                // Update waiterRatingUserDataArray based on the new review
                self.waiterRatingUserDataArray = self.SelecterWaiterRatingArray.compactMap { rating in
                    if let matchingUser = self.userDataArray.first(where: { $0.UserID == rating.userID }) {
                        let userName = (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? "")
                        return waiterRatingUserData(
                            WaiterRatingID: rating.ratingID,
                            waiterID: rating.waiterID,
                            userID: rating.userID,
                            rating: rating.rating,
                            comments: rating.review,
                            ratingDate: rating.visitDate,
                            UserTitle: userName,
                            UserImage: matchingUser.Userimage
                        )
                    }
                    return nil
                }
                
                // Ensure the table view is reloaded on the main thread
//                DispatchQueue.main.async {
//                    self.reviewTableView.reloadData()
//                    print(waiterRatingUserDataArray.count)
//                }
                
                completion()
            case .failure(let error):
                print("Error on fetchItemRatingJsonData: \(error)")
            }
        }
    }
    
    @IBAction func searchTextFieldChanged(_ sender: UITextField) {
        print("searchTextFieldChanged called")
        if let searchText = searchTF.text, !searchText.isEmpty {
            isSearching = true
            filterRestaurants(with: searchText)
        } else {
            isSearching = false
            MenuTableView.reloadData()
        }
    }
    
    @IBAction func rateAndreviewAutoScroll(_ sender: UIButton) {
        let offset = CGPoint(x: 0, y: rateThisPlaceView.frame.origin.y - scrollView.contentInset.top)
        
        scrollView.setContentOffset(offset, animated: true)
    }
    func filterRestaurants(with searchText: String) {
        filteredRestaurantsArray = waiterWorkedRestaurantsArray.filter { restaurantData in
            if let restaurantTitle = restaurantData.restaurant.RestaurantTitle {
                // Unwrap the optional RestaurantTitle and check if it contains the searchText
                return restaurantTitle.lowercased().contains(searchText.lowercased())
            } else {
                // Handle the case where RestaurantTitle is nil (optional chaining)
                return false
            }
        }
        MenuTableView.reloadData()
    }
    func DisplayWaiterData(){
        waiternameLabel.text = (waiterData[0].waiter.firstName ?? "") + " " + (waiterData[0].waiter.lastName ?? "")
        waiterEmaillabel.text = waiterData[0].waiter.email
        waiterReviewCount.text = "(\(SelecterWaiterRatingArray.count))"
        starsViewIntro.text = "\(waiterData[0].waiterAverageRating ?? 0.0)"
        starsViewIntro.rating = waiterData[0].waiterAverageRating ?? 0
        DOJLabel.text = waiterData[0].waiter.joiningDate
        
        if let image = waiterData[0].waiter.waiterImage{
            loadImage(from: image) { image  in
                if let img = image {
                    DispatchQueue.main.async {
                        self.waiterImage.image = img
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                self.waiterImage.image = emptyImage
            }
        }
        
        fetchWaiterRatingsWithUserReview()
        fetchWaiterWorkedRestaurants{
            self.MenuTableView.reloadData()
        }
        setRatingOnView()
    }
    //    func fetchWaiterRatingsWithUserReview(){
    //
    //        self.SelecterWaiterRatingArray = JsonDataArrays.waiterRatingArray.filter{ ratings in
    //            return ratings.waiterID == self.waiterData[0].waiter.waiterID
    //        }
    //        for selectedWaiter in  SelecterWaiterRatingArray {
    //            // Check if the user  contains a Item with the given ItemID
    //            if let matchingUser = self.userDataArray.first(where: { $0.UserID == selectedWaiter.userID }) {
    //                // If found, create a new userVisitedRestaurantData instance with the restaurant
    //                let useName = (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? "")
    //                // Append the new instance to the array
    //                let waiterRatingUserData = waiterRatingUserData( WaiterRatingID: selectedWaiter.ratingID, waiterID: selectedWaiter.waiterID, userID: selectedWaiter.userID, rating: selectedWaiter.rating, comments: selectedWaiter.review, ratingDate: selectedWaiter.visitDate, UserTitle: useName, UserImage: matchingUser.Userimage)
    //                self.waiterRatingUserDataArray.append(waiterRatingUserData)
    //            }
    //            // Handle the case where the restaurant is not found if needed
    //            else {
    //                // Handle the case where the restaurant is not found
    //                // You might want to log an error or handle it in some way
    //            }
    //        }
    //    }
    //
    func fetchWaiterRatingsWithUserReview() {
        // Clear existing data if needed
        self.waiterRatingUserDataArray.removeAll()
        
        // Filter waiter ratings based on the current waiter ID
        self.SelecterWaiterRatingArray = JsonDataArrays.waiterRatingArray.filter { ratings in
            return ratings.waiterID == self.waiterData[0].waiter.waiterID
           
        }
        
        
        
        for selectedWaiter in SelecterWaiterRatingArray {
            if let matchingUser = self.userDataArray.first(where: { $0.UserID == selectedWaiter.userID }) {
                let userName = (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? "")
                let waiterRatingUserData = waiterRatingUserData(
                    WaiterRatingID: selectedWaiter.ratingID,
                    waiterID: selectedWaiter.waiterID,
                    userID: selectedWaiter.userID,
                    rating: selectedWaiter.rating,
                    comments: selectedWaiter.review,
                    ratingDate: selectedWaiter.visitDate,
                    UserTitle: userName,
                    UserImage: matchingUser.Userimage
                )
                self.waiterRatingUserDataArray.append(waiterRatingUserData)
            } else {
                // Handle the case where the user is not found
                print("User with ID \(selectedWaiter.userID) not found")
            }
        }
        
        // Ensure the table view is reloaded on the main thread
//        DispatchQueue.main.async {
//            self.reviewTableView.reloadData()
//        }
    }
    
    func fetchWaiterWorkedRestaurants( completion: @escaping () -> Void) {
        
        for waiter in waiterData {
            let matchingRestaurants = JsonDataArrays.restaurantCompleteDataArray.filter { $0.restaurant.RestaurantID == waiter.waiter.restaurantID }
            
            for restaurant in matchingRestaurants {
                // Check if the restaurant is not already in the array before appending
                if !waiterWorkedRestaurantsArray.contains(where: { $0.restaurant.RestaurantID == restaurant.restaurant.RestaurantID }) {
                    waiterWorkedRestaurantsArray.append(restaurant)
                }
            }
        }
        completion()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Calculate the total height of the content
        var contentHeight: CGFloat = 0
        for subview in contentView.subviews {
            contentHeight += subview.frame.size.height + 20
        }
        
        // Set the contentSize to dynamically adjust the height
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentHeight + 20)
    }
    
    func setUI(){
        //  fetchUserData()
        //backButton.backButtonStyle(
        starsViewIntro.settings.fillMode = .precise
        starsView.settings.fillMode = .precise
        MenuView.layer.cornerRadius = 5
        MenuView.layer.shadowColor = UIColor.darkGray.cgColor
        MenuView.layer.shadowOffset = CGSize(width: 3, height: 3)
        MenuView.layer.shadowRadius = 4
        MenuView.layer.shadowOpacity = 0.5
        MenuView.layer.masksToBounds = false
        
        ratingView.layer.cornerRadius = 5
        ratingView.layer.shadowColor = UIColor.darkGray.cgColor
        ratingView.layer.shadowOffset = CGSize(width: 3, height: 3)
        ratingView.layer.shadowRadius = 4
        ratingView.layer.shadowOpacity = 0.5
        ratingView.layer.masksToBounds = false
        
        ImageView.layer.cornerRadius = 5
        ImageView.layer.shadowColor = UIColor.darkGray.cgColor
        ImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        ImageView.layer.shadowRadius = 4
        ImageView.layer.shadowOpacity = 0.5
        ImageView.layer.masksToBounds = false
        
        rateThisPlaceView.layer.cornerRadius = 5
        rateThisPlaceView.layer.shadowColor = UIColor.darkGray.cgColor
        rateThisPlaceView.layer.shadowOffset = CGSize(width: 3, height: 3)
        rateThisPlaceView.layer.shadowRadius = 4
        rateThisPlaceView.layer.shadowOpacity = 0.5
        rateThisPlaceView.layer.masksToBounds = false
        
        leaveYourCommentView.layer.cornerRadius = 5
        leaveYourCommentView.layer.shadowColor = UIColor.darkGray.cgColor
        leaveYourCommentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        leaveYourCommentView.layer.shadowRadius = 4
        leaveYourCommentView.layer.shadowOpacity = 0.5
        leaveYourCommentView.layer.masksToBounds = false
        
        ratingCalculationView.layer.cornerRadius = 5
        ratingCalculationView.layer.shadowColor = UIColor.darkGray.cgColor
        ratingCalculationView.layer.shadowOffset = CGSize(width: 3, height: 3)
        ratingCalculationView.layer.shadowRadius = 4
        ratingCalculationView.layer.shadowOpacity = 0.5
        ratingCalculationView.layer.masksToBounds = false
        
        
        waiternameLabel.applyLabelStyle(for: .headingBlack)
        waiterEmaillabel.applyLabelStyle(for: .subTitleLightGray)
        waiterReviewCount.applyLabelStyle(for: .descriptionLightGray)
        DOJTitleLabel.applyLabelStyle(for: .descriptionLightGray)
        DOJLabel.applyLabelStyle(for: .descriptionLightGray)
        //contactLabel.applyLabelStyle(for: .OfferWhite)
        DOJTitleLabel.text = "Date of Joining :"
        viewAllButton2.viewAllButtonStyle(title: "Top rated", systemImageName: "")
        rateTheWaiterlabel.applyLabelStyle(for: .headingBlack)
        ratingsAndReviewHeadinglabel.applyLabelStyle(for: .headingBlack)
        
        ratedOutofLabel.applyLabelStyle(for: .descriptionLightGray)
        for ratingStars in ratingStarCollection {
            ratingStars.applyLabelStyle(for: .descriptionLightGray)
        }
        for ratingpercentage in ratingPercentLabelCollection {
            ratingpercentage.applyLabelStyle(for: .descriptionLightGray)
        }
        rateAndReviewButton.titleLabel?.applyLabelStyle(for: .OfferWhite)
        allRatingaAndReviewHeadingLabel.applyLabelStyle(for: .headingBlack)
        leaveaCommentTitleLAbel.applyLabelStyle(for: .headingBlack)
        rateThePlaceCommentLabel.applyLabelStyle(for: .subTitleBlack)
        yourCommentLabel.applyLabelStyle(for: .descriptionLightGray)
        submitCommentButton.titleLabel?.applyLabelStyle(for: .OfferWhite)
        
        if waiterRatingUserDataArray.count >= 3{
            self.seeAllReviewsButton.isHidden = false
        }else{
            self.seeAllReviewsButton.isHidden = true
        }
        
        
    }
    
    func setRatingOnView() {
        var ratingCounts: [Int: Int] = [:]
        var totalRatings: Int = 0
        
        
        ratingCounts = Dictionary(grouping: waiterRatingUserDataArray) { waiterRating in
            waiterRating.rating ?? 0 // Use 0 as the default value if rating is nil
        }
        .mapValues { ratings in
            ratings.count
        }
        
        // Calculate totalRatings
        totalRatings = waiterRatingUserDataArray.count
        
        // Filter previousWaiterRatingByLoginUser
        self.previousWaiterRatingByLoginUser = waiterRatingUserDataArray.filter { $0.userID == loginUserID }
        
        // Get previous review count and set text
        let previousReviewCount = self.previousWaiterRatingByLoginUser.count
        self.leaveAcommentTF.text = previousReviewCount > 0 ? self.previousWaiterRatingByLoginUser[0].comments : ""
        self.yourCommentLabel.text = previousReviewCount > 0 ? "Your Previous Review" : "New Review"
        self.rateTheWaiterUserAction.rating = previousReviewCount > 0 ? Double(self.previousWaiterRatingByLoginUser[0].rating ?? 0) : 0.0
        self.userEnteredWaiterRating.rating = previousReviewCount > 0 ? Double(self.previousWaiterRatingByLoginUser[0].rating ?? 0) : 0.0
        
        self.userEnteredWaiterRating.text = previousReviewCount > 0 ?  "\(previousWaiterRatingByLoginUser[0].rating!)" : "0.0"
        //  self.userEnteredRating.rating = previousReviewCount > 0 ?  Double(previousWaiterRatingByLoginUser[0].rating!) : 0.0
        self.ratedOutofLabel.text = "Rated \(waiterData[0].waiterAverageRating?.rounded(toPlaces: 2) ?? 0.0) out of 5"
        
        self.userRating = previousReviewCount > 0 ? previousWaiterRatingByLoginUser[0].rating! : 0
        
        
        // Update UIProgressViews
        self.fifthStarProgressView.progress = Float(ratingCounts[5] ?? 0) / Float(totalRatings)
        self.fourthStarProgressView.progress = Float(ratingCounts[4] ?? 0) / Float(totalRatings)
        self.threeStarProgressView.progress = Float(ratingCounts[3] ?? 0) / Float(totalRatings)
        self.twoStarProgressView.progress = Float(ratingCounts[2] ?? 0) / Float(totalRatings)
        self.oneStarProgressView.progress = Float(ratingCounts[1] ?? 0) / Float(totalRatings)
        
        // Update UILabels with count
        self.ratingPercentLabelCollection[0].text = "\(ratingCounts[5] ?? 0)"
        self.ratingPercentLabelCollection[1].text = "\(ratingCounts[4] ?? 0)"
        self.ratingPercentLabelCollection[2].text = "\(ratingCounts[3] ?? 0)"
        self.ratingPercentLabelCollection[3].text = "\(ratingCounts[2] ?? 0)"
        self.ratingPercentLabelCollection[4].text = "\(ratingCounts[1] ?? 0)"
        
        // Calculate sumOfRatings and averageRating
        let sumOfRatings = waiterRatingUserDataArray.compactMap { $0.rating }.reduce(0, +)
        let averageRating = totalRatings > 0 ? Double(sumOfRatings) / Double(totalRatings) : 0
        
        // Update starsView and ratedOutofLabel
        self.starsView.rating = averageRating
        self.starsView.text = "\(averageRating)"
        self.ratedOutofLabel.text = "Rated \(averageRating.rounded(toPlaces: 2)) out of 5"
        self.starsViewIntro.rating = averageRating
        self.starsViewIntro.text = "\(totalRatings)"
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
        //menuButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            sender.tag = 0;
            let viewMenuBack : UIView = view.subviews.last!
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            return
        }
        sender.isEnabled = false
        sender.tag = 10
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC : LeftMenuViewController = storyBoard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        menuVC.btnMenu = sender
        // menuVC.delegate = self as? SlideMenuDelegate
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        self.navigationController?.isNavigationBarHidden = true
        //  self.present(menuVC, animated: true)
        menuVC.view.layoutIfNeeded()
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        leaveAcommentTF.resignFirstResponder()
        return true
    }
}
extension WaiterDetailsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == MenuTableView{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
            let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.size.width / 2 , height: 22))
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textColor = UIColor.black
            let subtitleLabel = UILabel(frame: CGRect(x: titleLabel.frame.size.width + 5, y: 0, width: headerView.frame.size.width / 3, height: 22))
            subtitleLabel.font = UIFont.systemFont(ofSize: 14)
            subtitleLabel.textColor = UIColor.gray
            headerView.addSubview(titleLabel)
            headerView.addSubview(subtitleLabel)
            titleLabel.text = "Restaurants"
            // subtitleLabel.text = "\(waiterModel.count) waiters"
            return headerView
        }
        else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == MenuTableView{
            return isSearching ? (filteredRestaurantsArray.isEmpty ? 1 : filteredRestaurantsArray.count) : (waiterWorkedRestaurantsArray.isEmpty ? 1 : waiterWorkedRestaurantsArray.count)
        }else{
            waiterRatingUserDataArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == MenuTableView{
            var restaurant: RestaurantCompleteData
            // let restaurant = waiterWorkedRestaurantsArray[indexPath.row]
            if isSearching{
                if filteredRestaurantsArray.isEmpty{
                    //empty cell
                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    emptyCell.textLabel?.text = "No restaurant's found"
                    
                    emptyCell.textLabel?.textAlignment = .center
                    return emptyCell
                }else{
                    let menuCell = MenuTableView.dequeueReusableCell(withIdentifier: "RestaurantMenuTVC", for: indexPath)as! RestaurantMenuTVC
                    restaurant = filteredRestaurantsArray[indexPath.row]
                    menuCell.configureRestaurant(with: restaurant)
                    return menuCell
                }
            }else{
                if waiterWorkedRestaurantsArray.isEmpty{
                    //empty cell
                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    emptyCell.textLabel?.text = "No restaurant's found"
                    emptyCell.textLabel?.textAlignment = .center
                    return emptyCell
                }else{
                    let menuCell = MenuTableView.dequeueReusableCell(withIdentifier: "RestaurantMenuTVC", for: indexPath)as! RestaurantMenuTVC
                    restaurant = waiterWorkedRestaurantsArray[indexPath.row]
                    menuCell.configureRestaurant(with: restaurant)
                    return menuCell
                }
            }
            
        }
        else{
            if waiterRatingUserDataArray.count == 0{
                let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                emptyCell.textLabel?.text = "No Reviews for waiter"
                emptyCell.textLabel?.textAlignment = .center
                return emptyCell
            }else{
                let reviewCell = reviewTableView.dequeueReusableCell(withIdentifier: "ViewAllReviewsTVC")as! ViewAllReviewsTVC
                let review = waiterRatingUserDataArray[indexPath.row]
                reviewCell.configureWithWaiter(with: review, currentUserId: loginUserID!)
                return reviewCell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == MenuTableView{
            return 170
        }else{
            if waiterRatingUserDataArray.isEmpty{
                return 40
            }
            else{
                return 180
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == MenuTableView{
            let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
            let selectedFood = waiterWorkedRestaurantsArray[indexPath.row]
            restarantHomeVC.selectedFor = "restaurant"
            restarantHomeVC.modalPresentationStyle = .fullScreen
            restarantHomeVC.modalTransitionStyle = .coverVertical
            // restarantHomeVC.restaurantName = selectedFoodName
            
            restarantHomeVC.selectedRestaurantData = [selectedFood]
            self.present(restarantHomeVC, animated: true, completion: nil)
        }
    }
}
extension WaiterDetailsVC: TelrControllerDelegate {
    
    func didPaymentCancel() {
        print("Payment Cancelled")
    }
    func didPaymentFail(messge message: String) {
        print("Payment Failed: \(message)")
    }
    func didPaymentSuccess(response: TelrResponseModel) {
        // Save the card details for future use
        saveCardDetails(response)
        
        // Print the last 4 digits of the card number
        if let cardLast4 = response.cardLast4 {
            print("Card Last 4 Digits: \(cardLast4)")
        } else {
            print("Card Last 4 Digits not available")
        }
        // Assuming the cardholder's name is inputted and stored elsewhere in the app
        if let billingFName = response.billingFName, let billingLName = response.billingLName {
            let cardholderName = "\(billingFName) \(billingLName)"
            print("Cardholder Name: \(cardholderName)")
        } else {
            print("Cardholder Name not available")
        }
        
        // Show completion message or alert
        showPaymentCompletionAlert()
    }
    private func showPaymentCompletionAlert() {
        let alert = UIAlertController(title: "Payment Successful", message: "Your payment has been completed.", preferredStyle: .alert)
        self.navigateToPaymentMethodScreen()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Navigate to payment method screen after user acknowledges
            self.navigateToPaymentMethodScreen()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}



