//  TipTapHomeVC.swift
//  TipTap
//  Created by Toqsoft on 27/10/23.

import UIKit
import GoogleSignIn
import GoogleMaps
import CoreLocation
import SystemConfiguration
import SVProgressHUD
struct FirstCV {
    var icons: UIImage
    var titles: String
}
import Foundation
import Combine
var getRestarantImage = [RestaurantImage]()
var loginuserFavouriteItemArray = [ItemCompleteData]()
class TipTapHomeVC: UIViewController,UITextFieldDelegate,GMSMapViewDelegate, CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
    //Payment
    var transactionHistory: [Transaction] = []
    //RestaurantOffer
       private var viewModel = OffersViewModel()
       private var cancellables: Set<AnyCancellable> = []
       private let tableView = UITableView()
    //LocalNotification
    var getImageArray = [String]()
    var restaurantImages = [RestaurantImage]()
    @IBOutlet weak var navThreeDotsButton: UIButton!
    @IBOutlet weak var navNotificationButton: UIButton!
    @IBOutlet weak var navFavoriteButton: UIButton!
    @IBOutlet weak var navSquareButton: UIButton!
    @IBOutlet weak var rightMenuDismissBtn: UIButton!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var RightMenuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var RightMenuTableView: UITableView!
    @IBOutlet weak var leftMenuButton: UIButton!
    @IBOutlet weak var viewAllButton1: UIButton!
    @IBOutlet weak var viewAllButton2: UIButton!
    @IBOutlet weak var viewAllButton3: UIButton!
    @IBOutlet weak var FoodGroupCollectionView: UICollectionView!
    @IBOutlet weak var TrandingthisweekCollectonView: UICollectionView!
    @IBOutlet weak var discountCardCV: UICollectionView!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var MostSalesTableView: UITableView!
    @IBOutlet weak var notibadgeLabel: UILabel!
    @IBOutlet weak var favbadgeLabel: UILabel!
    @IBOutlet weak var SearchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var offerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var SignatureDishViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var featuredRestaurantViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mostPopularViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signatureDishesView: UIView!
    @IBOutlet weak var featuredCuisinesView: UIView!
    @IBOutlet weak var featuredRestaurantsView: UIView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    let locationManager = CLLocationManager()
    var locationManagerPage: LocationManager?
    var completionBlock: (() -> Void)?
    var progressBarTimer: Timer!
    var isRunning = false
    let progressView = UIProgressView()
    var itemOffersDataFetched = false
    var itemCategoryDataFetched = false
    var menus: [FirstCV] = [
    FirstCV(icons: UIImage(systemName:"dollarsign")!, titles: "My Tip"),
    FirstCV(icons: UIImage(systemName: "mappin.and.ellipse")!, titles: "My Visits"),
    FirstCV(icons: UIImage(systemName: "heart")!, titles: "My Favourites"),
    FirstCV(icons: UIImage(systemName: "star")!, titles: "My Ratings"),
    FirstCV(icons: UIImage(systemName: "rosette")!, titles: "My Rewards"),
    FirstCV(icons: UIImage(systemName: "bubble")!, titles: "My Feedbacks")
   // FirstCV(icons: UIImage(systemName: "person")!, titles: "My Profile")
        // FirstCV(icons: UIImage(named: "Tips")!, titles: "Tips"),
    ]
    var cuisineModel = [CuisineModel]()
    //var signatureDishModel = [SignatureDishModel]()
    var image = ["pro1","pro2","pro3","pro4","pro1","pro2","pro3","pro4","pro1","pro2","pro3","pro4"]
    var threeDotsData = ["Feedback", "Enquiry", "Report an app", "Terms and Conditions", "Privacy Policy", "Logout"]
    let userNotificationCenter = UNUserNotificationCenter.current()
    var notificationCount = 0
    var internetCheckTimer: Timer?
    var placeholderIndex = 0
    var placeholders = ["Search here Featured Restaurents", "Search here Your Favorite Dishes", "Search here For Signature Dishes"] // Add your desired placeholders here
    var timer: Timer?
    var hideForTable : Bool = false
    var loginuserFavouriteRestaurantArray = [RestaurantCompleteData]() // For store Fav Restaurant
    //RestaurantOffer
    private var OfferViewModelDataArray = OfferViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        OfferViewModelDataArray.fetchOffers()
        setupBind()
        setupBind()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
        
        
        self.userNotificationCenter.delegate = self
        
        internetCheckTimer?.tolerance = 2.0
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        
        TrandingthisweekCollectonView.alpha = 0.1
        popularCollectionView.alpha = 0.1
        MostSalesTableView.alpha = 0.1
        setCustomProgressBar(withDelay: 0, onView: "Restaurants") {
            self.setCustomProgressBar(withDelay: 0, onView: "Dishes") {
                
                self.setCustomProgressBar(withDelay: 0, onView: "Cuisines") {
                    //                    // All progress bars have completed their animations
                    DispatchQueue.main.async {
                        self.updateProgressView()
                    }
                    
                }
            }
        }
        
        
        fetchRestaurantData {
            
            // Perform any UI-related operations here
            DispatchQueue.main.async {
                self.TrandingthisweekCollectonView.reloadData()
                self.FoodGroupCollectionView.reloadData()
                
                self.updateProgressView()
            }
            if currentLocation != nil{
                self.checkCurrentRestaurant() // After some time need to uncomment
            }
            
            
            
            
            self.fetchItemData {
                DispatchQueue.main.async {
                    self.MostSalesTableView.delegate = self
                    self.MostSalesTableView.dataSource = self
                    self.popularCollectionView.delegate = self
                    self.popularCollectionView.dataSource = self
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.updateProgressView()
                        
                        
                        self.MostSalesTableView.reloadData()
                        self.popularCollectionView.reloadData()
                        
                        self.FoodGroupCollectionView.reloadData()
                    }
                    self.SetFavouriteRestaurantAndItem{
                        DispatchQueue.main.async{
                            self.updateProgressView()
                        }
                    }
                    
                }
                
            }
            
        }
        TrandingthisweekCollectonView.register(EmptyCell.self, forCellWithReuseIdentifier: "emptyCell")
        popularCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: "emptyCell")
        
        fetchFeedbackJsonData {
            // This block is executed once fetchFeedbackJsonData is completed
            print("Feedback data fetching and processing completed!")
            // Perform any additional actions or UI updates
        }
        //        fetchWaiterData{
        //            fetchWaiterRatingsData{
        //                print("Waiter data fetching completed!, waiter ")
        //            }
        //        }
        fetchWaiterData()
        locationManagerPage = LocationManager()
        // You may optionally pass the array of restaurants to the location manager
        // locationManager?.restaurants = fetchRestaurants()
        rightMenuDismissBtn.isHidden = true
        setUI()
        setNavUI()
        searchTextfield.delegate = self
        UITabBar.appearance().barTintColor = .blue
        RightMenuTableView.isUserInteractionEnabled =  true
        RightMenuTableView.isHidden = true
        RightMenuTableView.layer.cornerRadius = 10
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            SearchViewHeightConstraint.constant = 150
        }else{
            SearchViewHeightConstraint.constant = 130
        }
        
        discountCardCV.delegate = self
        discountCardCV.dataSource = self
        
        
        let customFlowLayout = TwoByTwoFlowLayout()
        customFlowLayout.minimumInteritemSpacing = 10
        customFlowLayout.minimumLineSpacing = 10
        popularCollectionView.collectionViewLayout = customFlowLayout
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 10)
        
        BadgeCorner(myLabel: notibadgeLabel)
        BadgeCorner(myLabel: favbadgeLabel)
        //  fetchUserPayments()
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFavFromFavVCPressedNotification(_:)), name: Notification.Name("DeleteFavouriteActionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FeedbackSubmitActionNotification(_:)), name: Notification.Name("FeedbackSubmitActionNotification"), object: nil)
        fetchRestaurantImages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetFavouriteRestaurantAndItem{
            
        }
        let indexPath = IndexPath(item: 1, section: 0)
        self.FoodGroupCollectionView.reloadItems(at: [indexPath])
    }
    private func setupBind() {
        OfferViewModelDataArray.$offers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.discountCardCV.reloadData()
                
            }
            .store(in: &cancellables)
        
        OfferViewModelDataArray.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }

    // Restaurant Offer
    private func setupBindings() {
          viewModel.$offers
              .receive(on: DispatchQueue.main)
              .sink { [weak self] _ in
                  self?.tableView.reloadData()
              }
              .store(in: &cancellables)
          
          viewModel.$errorMessage
              .receive(on: DispatchQueue.main)
              .sink { [weak self] errorMessage in
                  if let errorMessage = errorMessage {
                      self?.showError(message: errorMessage)
                  }
              }
              .store(in: &cancellables)
      }
    private func showError(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
 
    func fetchRestaurantImages() {
            let urlString = "https://tiptabapi.azurewebsites.net/api/RestaurantImages"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.restaurantImages = try decoder.decode([RestaurantImage].self, from: data)
                   
                   
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
            
            task.resume()
        }
    
    @objc func deleteFavFromFavVCPressedNotification(_ notification: Notification) {
        SVProgressHUD.show()
        SetFavouriteRestaurantAndItem{
            
            DispatchQueue.main.async {
                self.FoodGroupCollectionView.reloadData()
                self.MostSalesTableView.reloadData()
            }
            SVProgressHUD.dismiss(withDelay: 0.2)
        }
        
    }
    @objc func FeedbackSubmitActionNotification(_ notification: Notification) {
        SVProgressHUD.show()
        fetchFeedbackJsonData{
            
            DispatchQueue.main.async {
                
                self.FoodGroupCollectionView.reloadData()
                
                
            }
            SVProgressHUD.dismiss(withDelay: 0.2)
        }
        
    }
    func SetFavouriteRestaurantAndItem(completion: @escaping () -> Void){
        loginuserFavouriteRestaurantArray.removeAll()
        loginuserFavouriteItemArray.removeAll()
        fetchFavioureRestaurant {
            fetchFavouriteItems {
                
                self.FilteruserFavResturant{
                    self.FilteruserFavItems{
                        DispatchQueue.main.async {
                            self.BadgeCorner(myLabel: self.notibadgeLabel)
                            self.BadgeCorner(myLabel: self.favbadgeLabel)
                            
                            let indexPath = IndexPath(item: 2, section: 0)
                            self.FoodGroupCollectionView.reloadItems(at: [indexPath])
                            self.TrandingthisweekCollectonView.reloadData()
                            self.MostSalesTableView.reloadData()
                            
                           
                            self.popularCollectionView.reloadData()
                        }
                    }
                }
                
            }
            completion()
            // self.TrandingthisweekCollectonView.reloadData()
            
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    func sendLocalNotification(for restaurant: RestaurantCompleteData?) {
        guard let restaurant = restaurant else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Nearby Restaurant"
        content.body = "You are near \(restaurant.restaurant.RestaurantTitle!)"
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error adding local notification: \(error.localizedDescription)")
            }else{
                print("Local Notification send successfully")
            }
        }
    }
    
    @objc func checkInternet() {
        if !ReachabilityTipTapHomeVC.isConnectedToNetwork() {
            internetCheckTimer?.invalidate()
            redirectToResponsePage()
        }
    }
    func redirectToResponsePage() {
        // Implement the logic to navigate to the response page
        let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as! InternetViewController
        controller.modalPresentationStyle = .fullScreen
        controller.message = "No Internet Connection"
        self.present(controller, animated: true)
    }
    
    func FilteruserFavResturant(completion: @escaping () -> Void) {
        loginuserFavouriteRestaurantArray.removeAll()
        
        for restaurant in JsonDataArrays.restaurantCompleteDataArray {
            if JsonDataArrays.FavouriteRestaurantIDArray.contains(restaurant.restaurant.RestaurantID ?? "") {
                // Check if the restaurant is not already in the array before appending
                if !loginuserFavouriteRestaurantArray.contains(where: { $0.restaurant.RestaurantID == restaurant.restaurant.RestaurantID }) {
                    loginuserFavouriteRestaurantArray.append(restaurant)
                }
            }
        }
        completion()
    }
    func FilteruserFavItems(completion: @escaping () -> Void) {
        loginuserFavouriteItemArray.removeAll()
        
        for item in JsonDataArrays.FavouriteItemsIDArray {
            let matchingItems =  JsonDataArrays.itemCompleteDataArray.filter { $0.Item.ItemID == item.itemID }
            
            for matchingItem in matchingItems {
                // Check if the item is not already in the array before appending
                if !loginuserFavouriteItemArray.contains(where: { $0.Item.ItemID == matchingItem.Item.ItemID }) {
                    loginuserFavouriteItemArray.append(matchingItem)
                }
            }
            
        }
        completion()
        
    }
    
    
    
    
    
    func fetchItemOffersData(completion: @escaping () -> Void){
        guard !itemOffersDataFetched else { return }
        itemOffersDataFetched = true
        
        let url = ItemOffresURL
        let apiUrl = URL(string: url)
        fetchJSONData(from: apiUrl!) { (result: Result<fetchItemOfferApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                
                
                if let records = jsondata.records{
                    JsonDataArrays.itemOffersArray = records
                }else{
                    JsonDataArrays.itemOffersArray = []
                }
                for offer in JsonDataArrays.itemOffersArray {
                    for (index, element) in JsonDataArrays.itemCompleteDataArray.enumerated() {
                        if element.Item.ItemID == offer.itemID && element.Item.RestaurantID == offer.restaurantID {
                            JsonDataArrays.itemCompleteDataArray[index].ItemOffer = offer
                        }
                    }
                }
                completion()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    
    
    func fetchItemCategoryData(completion: @escaping () -> Void) {
        guard !itemCategoryDataFetched else { return }
        itemCategoryDataFetched = true
        
        let apiUrlString = itemCategoryURL
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        fetchJSONData(from: apiUrl) { (result: Result<fetchItemCategoryApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                
                if let records = jsondata.records{
                    let itemCategoryForSelectedRestaurant = records
                    
                    for category in itemCategoryForSelectedRestaurant {
                        for (index, element) in JsonDataArrays.itemCompleteDataArray.enumerated() {
                            if element.Item.CategoryID == category.categoryID  {
                                // itemCompleteDataArray[index].ItemRatings = rating
                                JsonDataArrays.itemCompleteDataArray[index].ItemCategory = category
                                // print("Category Name...", category)
                            }
                        }
                    }
                    
                }
                completion()
                
            case .failure(let error):
                print("Error on fetchItemCategoryData: \(error)")
            }
            
            
        }
    }
    
    
    func fetchItemData(completion: @escaping () -> Void) {
        
        let apiUrlString = ItemListURL
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        fetchJSONData(from: apiUrl) { (result: Result<fetchItemApiResponse, APIError>) in
            switch result {
            case .success(let apiResponse):
                JsonDataArrays.itemCompleteDataArray.removeAll()
                //  DispatchQueue.main.async { [self] in
                
                if let records = apiResponse.records{
                    JsonDataArrays.itemModel = records
                }else{
                    JsonDataArrays.itemModel = []
                }
                
                for item in JsonDataArrays.itemModel {
                    JsonDataArrays.itemCompleteDataArray.append(ItemCompleteData(Item: item))
                }
                
                fetchItemRatingJson {
                    self.fetchItemOffersData {
                        self.fetchItemCategoryData {
                            
                            
                            completion()
                        }
                    }
                }
                //  }
            case .failure(let error):
                print("Error in fetchItemData : \(error)")
                completion() // Call completion even in case of failure
            }
        }
    }
    
    
    
    
    
    @IBAction func rightMenuDismissBtnAct(_ sender: UIButton) {
        
        if hideForTable {
            RightMenuTableView.isHidden = true
            rightMenuDismissBtn.isHidden = true
        }
    }
    
    
    func setNavUI(){
        navFavoriteButton.NavigationButtonImageStyle(withImage: nil, systemImageName: "heart")
        navNotificationButton.NavigationButtonImageStyle(withImage: nil, systemImageName: "bell")
        navSquareButton.NavigationButtonImageStyle(withImage: nil, systemImageName: "square.grid.2x2")
        navThreeDotsButton.NavigationButtonImageStyle(withImage: UIImage(named: "more"), systemImageName: nil)
        // leftMenuButton.NavigationButtonImageStyle(withImage: nil, systemImageName: "line.3.horizontal")
        
    }
    func setUI(){
        viewAllButton1.viewAllButtonStyle(title: "View all", systemImageName: "chevron.right.2")
        viewAllButton2.viewAllButtonStyle(title: "View all", systemImageName: "chevron.right.2")
        viewAllButton3.viewAllButtonStyle(title: "View all", systemImageName: "chevron.right.2")
        
        titleLabel1.text = "Featured Restaurants"
        titleLabel1.applyLabelStyle(for: .titleBlack)
        titleLabel2.text = "Featured Cuisines"
        titleLabel2.applyLabelStyle(for: .titleBlack)
        titleLabel3.text = "Our Signature Dishes"
        titleLabel3.applyLabelStyle(for: .titleBlack)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == searchTextfield{
            let controller =
            storyboard?.instantiateViewController(identifier: ReuseIdentifierConstant.trendingThisWeekVCIdentifier) as! TrendingThisWeekVC
            //    controller.restaurantModel = restaurantModel
            controller.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
            
            
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .coverVertical
            self.present(controller, animated: true)
            
        }
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let historyData = UserDefaults.standard.data(forKey: "transactionHistory") {
            do {
                transactionHistory = try JSONDecoder().decode([Transaction].self, from: historyData)
            } catch {
                print("Error decoding transaction history data: \(error.localizedDescription)")
            }
        }
        // Request location permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Start updating location
        locationManager.startUpdatingLocation()
        
        updatePlaceholder()
        startTimer()
        self.SetFavouriteRestaurantAndItem{
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Handle the updated location
        currentLocation = location.coordinate
        
        print("Current Latitude: \(currentLocation?.latitude ?? 0.0), Longitude: \(currentLocation!.longitude)")
        
        
        checkCurrentRestaurant()
        locationManager.stopUpdatingLocation()
    }
    
    
    func checkCurrentRestaurant(){
        if let currentLocation = currentLocation {
            var allRestaurant : [RestaurantCompleteData] = []
            for i in JsonDataArrays.restaurantCompleteDataArray{
                
                allRestaurant.append(i)
            }
            let nearbyRestaurants = filterRestaurantsByLocation(restaurants: allRestaurant, currentLocation: currentLocation)
            
            if nearbyRestaurants.isEmpty {
                print("No nearby restaurants found.")
            } else {
                print("Nearby restaurants:")
                for restaurant in nearbyRestaurants {
                    print("Restaurant ID: \(restaurant.restaurant.RestaurantID)")
                    // Print other restaurant details as needed
                    
                }
                
                
                //Send local notification on device like you are near to xyz Restaurant
                if notificationCount == 0{
                    sendLocalNotification(for: nearbyRestaurants.first)
                    notificationCount += 1
                }
                
                //        Show Current Restaurant Page
                //                let controller = storyboard?.instantiateViewController(withIdentifier: "CurrentRestaurantViewController") as! CurrentRestaurantViewController
                //                currentRestauran = nearbyRestaurants.first
                //                //  controller.modalPresentationStyle = .none
                //                self.present(controller, animated: true)
                
            }
        } else {
            print("Current location is unknown.")
        }
    }
    
    func areLocationsEqual(restaurantLocation: CLLocationCoordinate2D, currentLocation: CLLocationCoordinate2D) -> Bool {
        let restaurantCLLocation = CLLocation(latitude: restaurantLocation.latitude, longitude: restaurantLocation.longitude)
        let currentCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        let distance = restaurantCLLocation.distance(from: currentCLLocation)
        
        // You can choose a threshold distance (e.g., 10 meters) for considering locations as the same
        let thresholdDistance: CLLocationDistance = 100.0
        
        return distance <= thresholdDistance
    }
    
    
    func filterRestaurantsByLocation(restaurants: [RestaurantCompleteData], currentLocation: CLLocationCoordinate2D) -> [RestaurantCompleteData] {
        return restaurants.filter { restaurant in
            if let latitude = restaurant.restaurant.Latitude, let longitude = restaurant.restaurant.Longitude {
                let restaurantLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                return areLocationsEqual(restaurantLocation: restaurantLocation, currentLocation: currentLocation)
            } else {
                // Handle case where Latitude or Longitude is nil
                return false
            }
        }
    }
    
    
    func fetchRestaurantData(completion: @escaping () -> Void) {
        // Replace "YOUR_API_ENDPOINT" with the actual API endpoint URL
        let apiUrlString = RestaurantsURL
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        fetchJSONData(from: apiUrl) { (result: Result<fetchRestaurantApiResponse, APIError>) in
            switch result {
            case .success(let apiResponse):
                
                
                if let records = apiResponse.records{
                    JsonDataArrays.restaurantModel = records
                    
                }else{
                    JsonDataArrays.restaurantModel = []
                    
                }
                JsonDataArrays.restaurantCompleteDataArray.removeAll()
                JsonDataArrays.restaurantCompleteDataArray.append(contentsOf: JsonDataArrays.restaurantModel.map { RestaurantCompleteData(restaurant: $0) })
                
                fetchUserRatingJsonData {
                    fetchrestaurantOffers {
                        fetchuserVisitedjsonData {
                            fetchuserRewardsjsonData {
                                // Update your UI or perform other actions with the data
                                completion() // Call the completion handler once all tasks are completed
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print("Error: \(error)")
                completion() // Call the completion handler in case of failure as well
            }
        }
    }
    
    
    @IBAction func LeftmenuButtonClicked(_ sender: UIBarButtonItem) {
        
        
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
        menuVC.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
        menuVC.userFavouriteItemIDArray = JsonDataArrays.FavouriteItemsIDArray
        menuVC.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
        menuVC.loginuserFavouriteItemArray = loginuserFavouriteItemArray
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
    
    
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(identifier: "NotificationViewController") as! NotificationViewController
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .popover
        self.present(controller, animated: true)
    }
    @IBAction func favritesButtonAction(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(identifier: ReuseIdentifierConstant.favoritesVCIdentifier) as! FavoritesVC
        controller.cellTitle = "My Favourites"
        controller.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
        controller.loginuserFavouriteItemArray = loginuserFavouriteItemArray
        self.present(controller, animated: true)
    }
    @objc func textFieldTapped(){
        let controller = storyboard?.instantiateViewController(identifier: ReuseIdentifierConstant.trendingThisWeekVCIdentifier) as! TrendingThisWeekVC
        //controller.restaurantModel = restaurantModel
        controller.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
    }
    @IBAction func squareButtonAction(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(identifier: ReuseIdentifierConstant.trendingThisWeekVCIdentifier) as! TrendingThisWeekVC
        // controller.restaurantModel = restaurantModel
        controller.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
    }
    @IBAction func threeDotsButtonAction(_ sender: UIButton) {
        hideForTable = true
        if hideForTable {
            rightMenuDismissBtn.isHidden = false
        }
        RightMenuTableView.isHidden = !RightMenuTableView.isHidden
    }
    
    // Function to fetch and display data
   
    @IBAction func viewAllButton1Action(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(identifier: ReuseIdentifierConstant.trendingThisWeekVCIdentifier) as! TrendingThisWeekVC
        controller.restaurantImages = self.restaurantImages
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        
        controller.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
        controller.selectedFor = "restaurants"
        self.present(controller, animated: true)
    }
    @IBAction func viewAllButton2Action(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "FeaturedCuisinesDetailVC") as! FeaturedCuisinesDetailVC
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        //controller.ItemsIDArray = self.ItemsIDArray
        controller.cuisineModel = cuisinesArrayfromItems
        self.present(controller, animated: true)
    }
    @IBAction func viewAllButton3Action(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "SignatureDishesDetailVC") as! SignatureDishesDetailVC
        
        // controller.FavouriteItemsIDArray = JsonDataArrays.FavouriteItemsIDArray
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        controller.signatureDishModel = JsonDataArrays.itemCompleteDataArray.filterSignatureItems()
        self.present(controller, animated: true)
    }
    @IBOutlet weak var searchTextfield: UITextField! {
        didSet{
            searchTextfield.tintColor = .lightGray
            searchTextfield.setIcon(UIImage(systemName: "magnifyingglass")!)
        }
    }
    func updatePlaceholder() {
        searchTextfield.placeholder = placeholders[placeholderIndex]
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updatePlaceholderWithTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updatePlaceholderWithTimer() {
        placeholderIndex = (placeholderIndex + 1) % placeholders.count
        updatePlaceholder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    deinit {
        // Remove observer to avoid memory leaks
        NotificationCenter.default.removeObserver(self)
    }
}

extension TipTapHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == RightMenuTableView {
            return threeDotsData.count
        } else if tableView == MostSalesTableView {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                SignatureDishViewHeightConstraint.constant = (195 * 3) + 70 // Set the height for iPad
            } else {
                SignatureDishViewHeightConstraint.constant = (195 * 3) + 50 // Set the height for iPhone
            }
            return min(JsonDataArrays.itemCompleteDataArray.filterSignatureItems().count, 3)
            // return JsonDataArrays.itemCompleteDataArray.filterSignatureItems().count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == RightMenuTableView {
            let cell = RightMenuTableView.dequeueReusableCell(withIdentifier: "RightMenuCell", for: indexPath)
            cell.textLabel?.text = threeDotsData[indexPath.row]
            cell.textLabel?.applyLabelStyle(for: .subTitleBlack)
            return cell
        } else if tableView == MostSalesTableView {
            let salesCell = MostSalesTableView.dequeueReusableCell(withIdentifier: "MostSalesTVC", for: indexPath) as! MostSalesTVC
            let signatureItems = JsonDataArrays.itemCompleteDataArray.filterSignatureItems()
            
            let dishcomplete = signatureItems[indexPath.row]
            if !loginuserFavouriteItemArray.isEmpty{
                if let ItemID = dishcomplete.Item.ItemID {
                    if loginuserFavouriteItemArray.contains(where: { $0.Item.ItemID == ItemID }){
                        salesCell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        salesCell.isFavorite = true
                    }else{
                        salesCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        salesCell.isFavorite = false
                    }
                }
            }  else{
                salesCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                salesCell.isFavorite = false
            }
            
            salesCell.configureItemComplete(with: dishcomplete)
            salesCell.reloadMostSalesTVAfterFavActionClosure = { [weak self] in
                fetchFavouriteItems{
                    SVProgressHUD.show()
                    self?.FilteruserFavItems{
                        DispatchQueue.main.async {
                            self?.MostSalesTableView.reloadRows(at: [indexPath], with: .automatic)
                            
                            self?.BadgeCorner(myLabel: self!.notibadgeLabel)
                            self?.BadgeCorner(myLabel:  self!.favbadgeLabel)
                            let indexPath = IndexPath(item: 2, section: 0)
                            self?.FoodGroupCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            }
            return salesCell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == RightMenuTableView {
            if indexPath.row == 0 {
                let controller = storyboard?.instantiateViewController(identifier: "FeedbackVC") as! FeedbackVC
                RightMenuTableView.isHidden = true
                
                //controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .coverVertical
                self.present(controller, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                let controller = storyboard?.instantiateViewController(identifier: "EnquiryVC") as! EnquiryVC
                RightMenuTableView.isHidden = true
                //controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .coverVertical
                self.present(controller, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                let controller = storyboard?.instantiateViewController(identifier: "ReportAnAppVC") as! ReportAnAppVC
                RightMenuTableView.isHidden = true
                //controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .coverVertical
                self.present(controller, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                let controller = storyboard?.instantiateViewController(identifier: "TermsAndConditionsVC") as! TermsAndConditionsVC
                RightMenuTableView.isHidden = true
                //controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .coverVertical
                self.present(controller, animated: true, completion: nil)
            } else if indexPath.row == 4 {
                let controller = storyboard?.instantiateViewController(identifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                RightMenuTableView.isHidden = true
                //controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .coverVertical
                self.present(controller, animated: true, completion: nil)
            } else if indexPath.row == 5 { // logout
                //                let controller = storyboard?.instantiateViewController(identifier: "TipTapViewController") as! TipTapViewController
                //                controller.modalPresentationStyle = .fullScreen
                //                controller.modalTransitionStyle = .coverVertical
                //                self.present(controller, animated: true, completion: nil)
                UserDefaults.standard.removeObject(forKey: "UserID")
                UserDefaults.standard.removeObject(forKey: "userEmail")
                UserDefaults.standard.removeObject(forKey: "FirstName")
                UserDefaults.standard.removeObject(forKey: "LastName")
                UserDefaults.standard.removeObject(forKey: "userProfilePicUrl")
                UserDefaults.standard.removeObject(forKey: "LastLoginDate")
                
                
                showLogoutORExitAler()
            }
        } else if tableView == MostSalesTableView {
            let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
            let dishes = JsonDataArrays.itemCompleteDataArray.filterSignatureItems()[indexPath.item]
            let selectedFoodName = dishes.Item.ItemTitle
            restarantHomeVC.selectedFor = "dishes"
            restarantHomeVC.selectedSignatureItem = [dishes]
            restarantHomeVC.ItemID = dishes.Item.ItemID
         //   restarantHomeVC.cusineImage = dishes.Item.itemImage!
            restarantHomeVC.modalPresentationStyle = .fullScreen
            restarantHomeVC.modalTransitionStyle = .coverVertical
            restarantHomeVC.restaurantName = selectedFoodName ?? ""
            self.present(restarantHomeVC, animated: true, completion: nil)
        }
        
        
        
        print("Selected row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == RightMenuTableView {
            RightMenuHeightConstraint.constant = (CGFloat(threeDotsData.count) * 40 ) + 10
            return 40
        } else if tableView == MostSalesTableView {
            // Check if the device is an iPad
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 195 // Set the height for iPad
            } else {
                return 195 // Set the height for iPhone
            }
        }
        return 0
    }
    
    func showLogoutORExitAler(){
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            // Perform Google Sign-In logout
            GIDSignIn.sharedInstance.signOut()
            
            // Optionally, navigate to your login view controller GoogleSignInVC
            let controller = self.storyboard?.instantiateViewController(identifier: "GoogleSignInVC") as! GoogleSignInVC
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .coverVertical
            self.present(controller, animated: true, completion: nil)
        }
        
        let exitAction = UIAlertAction(title: "Exit", style: .default) { _ in
            // Exit the application
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Check if the device is an iPad before configuring the popover presentation
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Set the source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Set the source rect
            popoverController.permittedArrowDirections = [] // Remove the arrow
        }
        alertController.addAction(logoutAction)
        alertController.addAction(exitAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case FoodGroupCollectionView:
            //        secondViewHeightConstraint.constant = 10 * 100
            return menus.count
        case discountCardCV:
            //        offerViewHeightConstraint.constant = CGFloat(image.count) * collectionView.frame.size.height
            
            return OfferViewModelDataArray.offers.count
        case TrandingthisweekCollectonView:
            
            if JsonDataArrays.restaurantCompleteDataArray.isEmpty{
                
                return 1
            }else{
                return  min(JsonDataArrays.restaurantCompleteDataArray.count, 10)
            }
        case popularCollectionView:
            if UIDevice.current.userInterfaceIdiom == .pad{
                mostPopularViewHeightConstraint.constant = 370 * 2
            }else{
                mostPopularViewHeightConstraint.constant = 311 * 2
            }
            
            if cuisinesArrayfromItems.count == 0{
                return 1
            }else{
                return min(cuisinesArrayfromItems.count, 4)
            }
            
        default:
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == FoodGroupCollectionView{
            
            let foodgrpCVC = FoodGroupCollectionView.dequeueReusableCell(withReuseIdentifier: "FoodGroupCVC", for: indexPath) as! FoodGroupCVC
            foodgrpCVC.foodGroupName.text = menus[indexPath.row].titles
            foodgrpCVC.foodgroupImg.image = menus[indexPath.row].icons
            foodgrpCVC.foodgroupImg?.tintColor = .black
            
            
            foodgrpCVC.badgeLabel.layer.cornerRadius = 10
            foodgrpCVC.badgeLabel.backgroundColor = UIColor(red: 102/245, green: 150/245, blue: 0/245, alpha: 1)
            foodgrpCVC.badgeLabel.clipsToBounds = true
            
            if indexPath.row == 0{
              
                if transactionHistory.count == 0{
                    foodgrpCVC.badgeLabel.text = nil
                    foodgrpCVC.badgeLabel.backgroundColor = nil
                }
                foodgrpCVC.badgeLabel.text = "\(transactionHistory.count)"
                //Feedback
//                if JsonDataArrays.feedbackArray.count == 0{
//                    foodgrpCVC.badgeLabel.text = nil
//                    foodgrpCVC.badgeLabel.backgroundColor = nil
//                    
//                }else{
//                    foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.feedbackArray.count)"
//                    
//                    print("feedbackArray foodgrpCVC.badgeLabel.text = \(JsonDataArrays.feedbackArray.count)")
//                }
                //                foodgrpCVC.badgeLabel.clipsToBounds = true
            }else if indexPath.row == 1{
                
                if JsonDataArrays.userVisitedArray.count == 0{
                    foodgrpCVC.badgeLabel.text = nil
                    foodgrpCVC.badgeLabel.backgroundColor = nil
                }else{
                    foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.userVisitedArray.count)"
                    
                }
                
                
                //My Rating
//                if JsonDataArrays.userRatingsDataArray.count == 0 && JsonDataArrays.LoginUserItemRatingDataArray.count == 0 && JsonDataArrays.LoginUserWaiterRatingDataArray.count == 0{
//                    foodgrpCVC.badgeLabel.text = nil
//                    foodgrpCVC.badgeLabel.backgroundColor = nil
//                }else{
//                    foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.userRatingsDataArray.count + JsonDataArrays.LoginUserItemRatingDataArray.count + JsonDataArrays.LoginUserWaiterRatingDataArray.count)"
//                    print("userRatingsDataArray foodgrpCVC.badgeLabel.text = \(JsonDataArrays.userRatingsDataArray.count)")
//                    foodgrpCVC.badgeLabel.backgroundColor = UIColor(red: 102/245, green: 150/245, blue: 0/245, alpha: 1)
//                }
                //                foodgrpCVC.badgeLabel.clipsToBounds = true
            }else if indexPath.row == 2{
                var count = 0
                                count = loginuserFavouriteItemArray.count + loginuserFavouriteRestaurantArray.count
                
                                if count == 0{
                                    foodgrpCVC.badgeLabel.text = nil
                                    foodgrpCVC.badgeLabel.backgroundColor = nil
                                }else{
                                    foodgrpCVC.badgeLabel.text = "\(count)"
                
                                    foodgrpCVC.badgeLabel.backgroundColor = UIColor(red: 102/245, green: 150/245, blue: 0/245, alpha: 1)
                                    //                foodgrpCVC.badgeLabel.clipsToBounds = true
                                }
                
                
                //Profile
               // foodgrpCVC.badgeLabel.text = nil
               // foodgrpCVC.badgeLabel.backgroundColor = nil
            }else if indexPath.row == 3{
                if JsonDataArrays.userRatingsDataArray.count == 0 && JsonDataArrays.LoginUserItemRatingDataArray.count == 0 && JsonDataArrays.LoginUserWaiterRatingDataArray.count == 0{
                    foodgrpCVC.badgeLabel.text = nil
                    foodgrpCVC.badgeLabel.backgroundColor = nil
                }else{
                    foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.userRatingsDataArray.count + JsonDataArrays.LoginUserItemRatingDataArray.count + JsonDataArrays.LoginUserWaiterRatingDataArray.count)"
                    print("userRatingsDataArray foodgrpCVC.badgeLabel.text = \(JsonDataArrays.userRatingsDataArray.count)")
                    foodgrpCVC.badgeLabel.backgroundColor = UIColor(red: 102/245, green: 150/245, blue: 0/245, alpha: 1)
                }
                
                
                
                
                //Favourite
//                var count = 0
//                count = loginuserFavouriteItemArray.count + loginuserFavouriteRestaurantArray.count
//                
//                if count == 0{
//                    foodgrpCVC.badgeLabel.text = nil
//                    foodgrpCVC.badgeLabel.backgroundColor = nil
//                }else{
//                    foodgrpCVC.badgeLabel.text = "\(count)"
//                    
//                    foodgrpCVC.badgeLabel.backgroundColor = UIColor(red: 102/245, green: 150/245, blue: 0/245, alpha: 1)
//                    //                foodgrpCVC.badgeLabel.clipsToBounds = true
//                }
            }else if indexPath.row == 4{
                if JsonDataArrays.userRewardsArray.count == 0{
                    foodgrpCVC.badgeLabel.text = nil
                                   foodgrpCVC.badgeLabel.backgroundColor = nil
                               }else{
                                   foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.userRewardsArray.count)"
                               }
                
                
                //Visited
//                if JsonDataArrays.userVisitedArray.count == 0{
//                    foodgrpCVC.badgeLabel.text = nil
//                    foodgrpCVC.badgeLabel.backgroundColor = nil
//                }else{
//                    foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.userVisitedArray.count)"
//                }
                //                foodgrpCVC.badgeLabel.clipsToBounds = true
            }else if indexPath.row == 5{
//                //Rewards
//                if JsonDataArrays.userRewardsArray.count == 0{
//                    foodgrpCVC.badgeLabel.text = nil
//                    foodgrpCVC.badgeLabel.backgroundColor = nil
//                }else{
//                    foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.userRewardsArray.count)"
//                }
//                //                foodgrpCVC.badgeLabel.clipsToBounds = true
                if JsonDataArrays.feedbackArray.count == 0{
                    foodgrpCVC.badgeLabel.text = nil
                    foodgrpCVC.badgeLabel.backgroundColor = nil
                    
                }else{
                    foodgrpCVC.badgeLabel.text = "\(JsonDataArrays.feedbackArray.count)"
                    
                    print("feedbackArray foodgrpCVC.badgeLabel.text = \(JsonDataArrays.feedbackArray.count)")
                }
            }
            return foodgrpCVC
        }
        else if collectionView == discountCardCV
                    
        {
            let discountCardCell = discountCardCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! DiscountCardCVC
            let offer = OfferViewModelDataArray.offers[indexPath.row]
            if let restaurant = OfferViewModelDataArray.restaurants.first(where: { $0.restaurantID == offer.restaurantID }) {
                
                //  loadImage(from: restaurant.restaurantImage, into: discountCardCell.image)
                discountCardCell.nameLabel.text = restaurant.restaurantTitle
                
            }
            discountCardCell.image.loadImage(from: offer.offerImage)
            discountCardCell.offerNameLabel.text = offer.offerTitle
            discountCardCell.discountLabel.text = "\(offer.discount)"
            
            //viewModel.offers.count
           
            return discountCardCell
        }else if collectionView == TrandingthisweekCollectonView{
            
            if JsonDataArrays.restaurantCompleteDataArray.isEmpty{
                //Call Emptycell for No Restaurant
                let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? EmptyCell ?? EmptyCell()
                emptyCell.textLabel.text = "No restaurants found."
                emptyCell.textLabel.textAlignment = .center
                return emptyCell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendigCell", for: indexPath) as! TrendingCell
                let restaurant = JsonDataArrays.restaurantCompleteDataArray[indexPath.item]
                
                if !loginuserFavouriteRestaurantArray.isEmpty {
                    if let restaurantID = restaurant.restaurant.RestaurantID {
                        
                        if loginuserFavouriteRestaurantArray.contains(where: { $0.restaurant.RestaurantID == restaurantID }){
                            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            cell.isFavorite = true
                        } else {
                            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                            cell.isFavorite = false
                        }
                    }
                }
                else{
                    cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.isFavorite = false
                }
                
                cell.configure(with: restaurant)
                cell.reloadTrendingCVAfterFavActionClosure = { [weak self] in
                    SVProgressHUD.show()
                    fetchFavioureRestaurant {
                        self?.FilteruserFavResturant {
                            DispatchQueue.main.async {
                                
                                self?.TrandingthisweekCollectonView.reloadItems(at: [indexPath])
                                self?.BadgeCorner(myLabel: self!.notibadgeLabel)
                                self?.BadgeCorner(myLabel:  self!.favbadgeLabel)
                                let indexPath = IndexPath(item: 2, section: 0)
                                self?.FoodGroupCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                    SVProgressHUD.dismiss()
                }
                return cell
            }
        }else if collectionView == popularCollectionView{
            
//            if cuisinesArrayfromItems.count == 0{
//                let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? EmptyCell ?? EmptyCell()
//                emptyCell.textLabel.text = "No cuisine found."
//                emptyCell.textLabel.textAlignment = .center
//                return emptyCell
//            }else{
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCollectionViewCell
//                let cuisineIndex = indexPath.row
//                
//                
//                if let item = cuisinesArrayfromItems[cuisineIndex].first {
//                    //  let itemOffer = getItemOffer(item: item)
//                    if !loginuserFavouriteItemArray.isEmpty{
//                        if loginuserFavouriteItemArray.contains(where: {$0.Item.ItemID == item.Item.ItemID && $0.Item.RestaurantID == item.Item.RestaurantID}){
//                            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                            cell.heartBtn.tintColor = .systemRed
//                        }else{
//                            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//                        }
//                    }
//                    
//                    cell.configure2(with: item)
//                } else {
//                    // Handle the case where there are no items in the cuisine
//                }
//                  //         let cuisine = cuisineModel[indexPath.item]
//                //
//                  //          cell.configure(with: cuisine)
//                
//                return cell
//            }
            //MadamImplementCode
            if cuisinesArrayfromItems.count == 0{
                let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? EmptyCell ?? EmptyCell()
                emptyCell.textLabel.text = "No cuisine found."
                emptyCell.textLabel.textAlignment = .center
                return emptyCell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCollectionViewCell
                let cuisineIndex = indexPath.row
                
                
                if let item = cuisinesArrayfromItems[cuisineIndex].first {
                    //  let itemOffer = getItemOffer(item: item)
                    if !loginuserFavouriteItemArray.isEmpty{
                        if loginuserFavouriteItemArray.contains(where: {$0.Item.ItemID == item.Item.ItemID && $0.Item.RestaurantID == item.Item.RestaurantID}){
                            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            cell.heartBtn.tintColor = .systemRed
                            cell.isFavorite = true
                        }else{
                            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                            cell.isFavorite = false
                        }
                    }else{
                        cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        cell.isFavorite = false
                    }
                    
                    cell.configure2(with: item)
                    
                    cell.reloadCuisineCollectionViewAfterFavActionClosure = { [weak self] in
                        fetchFavouriteItems{
                            SVProgressHUD.show()
                            self?.FilteruserFavItems{
                                DispatchQueue.main.async {
                                    self?.popularCollectionView.reloadItems(at:  [indexPath])
                                    
                                    self?.BadgeCorner(myLabel: self!.notibadgeLabel)
                                    self?.BadgeCorner(myLabel:  self!.favbadgeLabel)
                                    let indexPath = IndexPath(item: 2, section: 0)
                                    self?.FoodGroupCollectionView.reloadItems(at: [indexPath])
                                }
                            }
                            SVProgressHUD.dismiss()
                        }
                    }
                } else {
                    // Handle the case where there are no items in the cuisine
                }
                //            let cuisine = cuisineModel[indexPath.item]
                //
                //            cell.configure(with: cuisine)
                
                return cell
            }
            
            
            
        } else{
            return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        }
        
    }
    
    
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            if collectionView == TrandingthisweekCollectonView{
//                if !JsonDataArrays.restaurantCompleteDataArray.isEmpty{
//                    let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
//                
//                    getRestarantImage.removeAll()
//                    let selectedRestaurant = JsonDataArrays.restaurantCompleteDataArray[indexPath.row]
//                    let selectedId = selectedRestaurant.restaurant.RestaurantID
//                     let getRestarantImages = self.restaurantImages.filter({ $0.RestaurantID == selectedId })
//                    
//                    getRestarantImage.append(contentsOf: getRestarantImages)
//                    if getRestarantImage.isEmpty {
//                        restarantHomeVC.gettingSingleImage1 = JsonDataArrays.restaurantCompleteDataArray[indexPath.item].restaurant.RestaurantImage ?? ""
//                    }else {
//                        // Assign getRestarantImage to restarantHomeVC.getRestarantImage
//                        restarantHomeVC.getRestarantImage = getRestarantImage
//     
//                        // Append image URLs from getRestarantImage to getImageArray
//                        if let firstRestaurantImage = getRestarantImage.first {
//                            let image1 = firstRestaurantImage.ImageOne
//                            let image2 = firstRestaurantImage.ImageTwo
//                            let image3 = firstRestaurantImage.ImageThree
//                            getImageArray.removeAll()
//                            getImageArray.append(image1)
//                            getImageArray.append(image2)
//                            getImageArray.append(image3)
//                        }
//     
//                        // Accessing getImageArray
//                        for imageUrl in getImageArray {
//                            print("Image URL: \(imageUrl)")
//                        }
//     
//                    }
//                   print("Images---->",getRestarantImage)
//                    
//                    
//                    restarantHomeVC.selectedFor = "restaurant"
//                    restarantHomeVC.modalPresentationStyle = .fullScreen
//                    restarantHomeVC.modalTransitionStyle = .coverVertical
//                    //restarantHomeVC.restaurantName = selectedFoodName
//                    
//                    restarantHomeVC.selectedRestaurantData = [selectedRestaurant]
//                    self.present(restarantHomeVC, animated: true, completion: nil)
//                }
//            }
        
        //        if collectionView == popularCollectionView {
        //            let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
        //            let selectedFoodName = cuisinesArrayfromItems[indexPath.item].first?.CusineTitle
        //            restarantHomeVC.selectedFor = "cuisines"
        //            restarantHomeVC.modalPresentationStyle = .fullScreen
        //            restarantHomeVC.modalTransitionStyle = .coverVertical
        //            restarantHomeVC.restaurantName = selectedFoodName ?? ""
        //            self.present(restarantHomeVC, animated: true, completion: nil)
        //        }
//        if collectionView == popularCollectionView {
//            if !cuisinesArrayfromItems.isEmpty{
//                let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
//                restarantHomeVC.selectedFor = "cuisines"
//                
//                let selectedCuisine = cuisinesArrayfromItems[indexPath.row]
//                restarantHomeVC.cusineImage = (selectedCuisine.first?.Item.itemImage)!
//                restarantHomeVC.restaurantName = selectedCuisine.first?.Item.CusineTitle ?? ""
//                if let firstItem = selectedCuisine.first {
//                    // Find restaurant IDs matching the selected cuisine
//                    let matchingRestaurantIDs = JsonDataArrays.itemModel.filter { $0.CusineTitle == firstItem.Item.CusineTitle }.compactMap { $0.RestaurantID }
//                    restarantHomeVC.matchingRestaurant_ID = matchingRestaurantIDs
//                    restarantHomeVC.selectedCuisine = selectedCuisine
//                    restarantHomeVC.modalPresentationStyle = .fullScreen
//                    self.present(restarantHomeVC, animated: true, completion: nil)
//                    //  print("Matching Restaurant IDs: \(restarantHomeVC.matchingRestaurant_ID)")
//                }
//                
//            }
//        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == TrandingthisweekCollectonView{
                if !JsonDataArrays.restaurantCompleteDataArray.isEmpty{
                    let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
                    let selectedRestaurant = JsonDataArrays.restaurantCompleteDataArray[indexPath.row]
                    let selectedId = selectedRestaurant.restaurant.RestaurantID
                    if   let userID = loginUserID {
                        
                        getRestarantImage.removeAll()
                        
                        let commentedUser = selectedRestaurant.restaurantRatings.filter { $0.RestaurantId == selectedId && $0.UserId == userID }
                        
                        print("CommentedID--->", commentedUser)
                        if !commentedUser.isEmpty {
                          //  commandForChecking = true
                        }
                    }else{
                       //commandForChecking = false
                    }
                     let getRestarantImages = self.restaurantImages.filter({ $0.RestaurantID == selectedId })
                    
                    getRestarantImage.append(contentsOf: getRestarantImages)
                    if getRestarantImage.isEmpty {
                        getImageArray = [selectedRestaurant.restaurant.RestaurantImage ?? ""]
                       
                    }else {
                       
                        if let firstRestaurantImage = getRestarantImage.first {
                            let image1 = firstRestaurantImage.ImageOne
                            let image2 = firstRestaurantImage.ImageTwo
                            let image3 = firstRestaurantImage.ImageThree
                            getImageArray.removeAll()
                            getImageArray.append(image1)
                            getImageArray.append(image2)
                            getImageArray.append(image3)
                        }
     
                        // Accessing getImageArray
                        for imageUrl in getImageArray {
                            print("Image URL: \(imageUrl)")
                        }
                        
                    }
             //   print("Images---->",getRestarantImage)
                    restarantHomeVC.getImageArray = self.getImageArray
                    restarantHomeVC.selectedFor = "restaurant"
                    restarantHomeVC.modalPresentationStyle = .fullScreen
                    restarantHomeVC.modalTransitionStyle = .coverVertical
                    //restarantHomeVC.restaurantName = selectedFoodName
                    
                    restarantHomeVC.selectedRestaurantData = [selectedRestaurant]
                    self.present(restarantHomeVC, animated: true, completion: nil)
                }
                
            }
            
            if collectionView == popularCollectionView {
                if !cuisinesArrayfromItems.isEmpty{
                    let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
                    restarantHomeVC.selectedFor = "cuisines"
                    
                    let selectedCuisine = cuisinesArrayfromItems[indexPath.row]
                    restarantHomeVC.selectedImageFoRCusines = selectedCuisine.first?.Item.itemImage ?? ""
                    restarantHomeVC.restaurantName = selectedCuisine.first?.Item.CusineTitle ?? ""
                    if let firstItem = selectedCuisine.first {
                        // Find restaurant IDs matching the selected cuisine
                        let matchingRestaurantIDs = JsonDataArrays.itemModel.filter { $0.CusineTitle == firstItem.Item.CusineTitle }.compactMap { $0.RestaurantID }
                        restarantHomeVC.matchingRestaurant_ID = matchingRestaurantIDs
                        restarantHomeVC.selectedCuisine = selectedCuisine
                        restarantHomeVC.modalPresentationStyle = .fullScreen
                        self.present(restarantHomeVC, animated: true, completion: nil)
                        
                    }
                    
                }
            }
        if collectionView == FoodGroupCollectionView{
            if indexPath.row == 0 {
                let controller = storyboard?.instantiateViewController(identifier: "TipsViewController") as! TipsViewController
                controller.transactionHistory = transactionHistory.self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
                
                
//                let controller = storyboard?.instantiateViewController(identifier: "FeedBackViewControllerVC") as! FeedBackViewControllerVC
               
            } else if indexPath.row == 1 {
                
                let controller = storyboard?.instantiateViewController(identifier: "VisitedVC") as! VisitedVC
                controller.cellTitle = menus[indexPath.row].titles
                self.present(controller, animated: true)
//                let controller = storyboard?.instantiateViewController(identifier: "RatingsViewControllerVC") as! RatingsViewControllerVC
                
            }else if indexPath.row == 2 {
                let controller = storyboard?.instantiateViewController(identifier: "FavoritesVC") as! FavoritesVC
                controller.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
                controller.loginuserFavouriteItemArray = loginuserFavouriteItemArray
                controller.cellTitle = menus[indexPath.row].titles
//                let controller = storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
//                controller.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
//                controller.loginuserFavouriteItemArray = self.loginuserFavouriteItemArray
//                controller.modalTransitionStyle = .coverVertical
//                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
            //            else if indexPath.row == 3 {
            //                let controller = storyboard?.instantiateViewController(identifier: "SectionViewController") as! SectionViewController
            //                self.present(controller, animated: true)
            //            }
            else if indexPath.row == 3 {  let controller = storyboard?.instantiateViewController(identifier: "RatingsViewControllerVC") as! RatingsViewControllerVC
                
//                let controller = storyboard?.instantiateViewController(identifier: "FavoritesVC") as! FavoritesVC
//                controller.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
//                controller.loginuserFavouriteItemArray = self.loginuserFavouriteItemArray
//                controller.cellTitle = menus[indexPath.row].titles
                self.present(controller, animated: true)
            } else if indexPath.row == 4 {
                let controller = storyboard?.instantiateViewController(identifier: "RewardsVC") as! RewardsVC
                self.present(controller, animated: true)
                
                
//                let controller = storyboard?.instantiateViewController(identifier: "VisitedVC") as! VisitedVC
//                controller.cellTitle = menus[indexPath.row].titles
//                self.present(controller, animated: true)
            } else if indexPath.row == 5 {
                let controller = storyboard?.instantiateViewController(identifier: "FeedBackViewControllerVC") as! FeedBackViewControllerVC
                  self.present(controller, animated: true)
            } else{
                
                let controller = storyboard?.instantiateViewController(withIdentifier: "FoodGroupPopupViewController") as! FoodGroupPopupViewController
                controller.LabelText = menus[indexPath.row].titles
                self.present(controller, animated: true)
            }
        }
        
        if collectionView == discountCardCV{
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if it's different
                   guard let controller = storyboard.instantiateViewController(withIdentifier: "OffersPopupViewController") as? OffersPopupViewController else {
                       return
                   }
                   
                   let offer = OfferViewModelDataArray.offers[indexPath.row]
            if let restaurant = OfferViewModelDataArray.restaurants.first(where: { $0.restaurantID == offer.restaurantID }) {
                
                //  loadImage(from: restaurant.restaurantImage, into: discountCardCell.image)
                controller.OfferrestaurantName = restaurant.restaurantTitle
                
            }
            controller.offerDescription = offer.description
            controller.offerDiscount = "\(offer.discount)"
            controller.startDate = offer.startDate
            controller.endDate = offer.endDate
            controller.ooferTitle = offer.offerTitle
            controller.imageString = offer.offerImage
            self.present(controller, animated: true)
        }
    }
    /*
     var OfferrestaurantName: String?
     var offerDescription : String?
     var offerDiscount : String?
     var startDate: Int?
     var endDate : Int?
     var ooferTitle:String?
     
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the desired size for the cell at the specified indexPath
        
        if collectionView == FoodGroupCollectionView{
            return CGSize(width: 100, height: 110)
        }else if collectionView == discountCardCV{
            //let cellWidth = collectionView.frame.size.width / 3
            //let cellHeight = collectionView.frame.size.height
            return CGSize(width: 220, height: 200)
        }else if collectionView == TrandingthisweekCollectonView{
            // let size = self.view.frame.size.width - 40
            
            return CGSize(width: 330, height: 370)
        }
        
        else if collectionView == popularCollectionView{
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                let cellWidth = (collectionView.bounds.width - 30 )/2
                return CGSize(width: cellWidth, height: 355)
            }else{
                let cellWidth = (collectionView.bounds.width - 30 )/2
                return CGSize(width: cellWidth, height: 300)
            }
        }
        
        else{
            return CGSize(width: 0, height: 0)
        }
    }
    func BadgeCorner(myLabel:UILabel){
        
        
        if myLabel == notibadgeLabel{
            
            myLabel.text = "3"
        }else{
            let itemcount = (loginuserFavouriteItemArray.count + loginuserFavouriteRestaurantArray.count)
            //            if itemcount > 12{
            //                myLabel.text = "12+"
            //            }else{
            myLabel.text = "\(itemcount)"
            //            }
        }
        myLabel.layer.cornerRadius = 10
        myLabel.clipsToBounds = true
    }

}

extension TipTapHomeVC{
    func setCustomProgressBar(withDelay delay: TimeInterval, onView view: String, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.setCustomProgressBar(onView: view) {
                completion()
            }
        }
    }
    func setCustomProgressBar(onView view: String, completion: @escaping () -> Void) {
        progressView.isHidden = false
        completionBlock = completion
        progressView.progress = 0.0
        progressView.tintColor = UIColor.blue
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.layer.borderWidth = 0.5
        progressView.layer.borderColor = UIColor.white.cgColor
        progressView.layer.cornerRadius = 2
        
        switch view {
        case "Restaurants":
            TrandingthisweekCollectonView.alpha = 0.2
            featuredRestaurantsView.addSubview(progressView)
            setupProgressBarConstraints(for: progressView, in: featuredRestaurantsView)
        case "Cuisines":
            popularCollectionView.alpha = 0.2
            featuredCuisinesView.addSubview(progressView)
            setupProgressBarConstraints(for: progressView, in: featuredCuisinesView)
        case "Dishes":
            MostSalesTableView.alpha = 0.2
            signatureDishesView.addSubview(progressView)
            setupProgressBarConstraints(for: progressView, in: signatureDishesView)
        default:
            break
        }
        startProgressAnimation {
            completion()
        }
    }
    
    func setupProgressBarConstraints(for progressBar: UIProgressView, in view: UIView) {
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressBar.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            progressBar.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    func startProgressAnimation(completion: @escaping () -> Void) {
        //        progressBarTimer = Timer.scheduledTimer(
        //            timeInterval: 0.2,
        //            target: self,
        //            selector: #selector(updateProgressView),
        //            userInfo: ["completion": completion],
        //            repeats: true
        //        )
        
        if !isRunning {
            progressView.progressTintColor = UIColor.blue
            progressView.progressViewStyle = .default
        }
        isRunning = true
    }
    
    @objc func updateProgressView() {
        // DispatchQueue.main.async{ [self] in
        progressView.progress += 0.2
        progressView.setProgress(progressView.progress, animated: true)
        
        // if progressView.progress == 1.0 {
        //  progressBarTimer.invalidate()
        isRunning = false
        
        var viewToFadeIn: String?
        
        switch progressView.superview {
        case featuredRestaurantsView:
            viewToFadeIn = "featuredRestaurantsView"
        case featuredCuisinesView:
            viewToFadeIn = "featuredCuisinesView"
        case signatureDishesView:
            viewToFadeIn = "signatureDishesView"
        default:
            break
        }
        
        if let view = viewToFadeIn {
            fadeCollectionViewIn(forView: view)
        }
        progressView.isHidden = true
        
        // Access the completion block directly
        completionBlock?() // Call the completion handler when the animation completes
        //}
        //  }
    }
    
    func fadeCollectionViewIn(forView : String) {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2) {
                switch forView {
                case "featuredRestaurantsView":
                    self.TrandingthisweekCollectonView.alpha = 1.0
                case "featuredCuisinesView":
                    self.popularCollectionView.alpha = 1.0
                case "signatureDishesView":
                    self.MostSalesTableView.alpha = 1.0
                default:
                    break
                }
            }
        }
    }
}
extension TipTapHomeVC:  ReviewPostingDelegate{
    func didPostReviewSuccessfully(for type: ReviewType) {
        switch type {
        case .restaurant:
            fetchRestaurantData {
                print("Restaurant data fetching completed!")
            }
        case .item:
            fetchItemData {
                print("Item data fetching completed!")
            }
        case .waiter:
            //            fetchWaiterData {
            //                fetchWaiterRatingsData {
            //                    print("Waiter ratings data fetching completed!")
            //                }
            //            }
            fetchWaiterData()
        }
        
        
    }
    //    func didPostReviewSuccessfully() {
    //
    //        fetchRestaurantData {
    //            self.fetchItemData {
    //                fetchWaiterData{
    //                    fetchWaiterRatingsData{
    //                        print("Waiter data fetching completed!, waiter ")
    //                    }
    //                }
    //
    //            }
    //
    //        }
    //    }
    
    
    
}

public class ReachabilityTipTapHomeVC {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return isReachable && !needsConnection
    }
}

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return
        }
        
        // Clear the current image
        self.image = nil
        
        // Start a background task to download the image
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to download image: \(error)")
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("No data or failed to convert data to image.")
                return
            }
            
            // Update the image view on the main thread
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}

