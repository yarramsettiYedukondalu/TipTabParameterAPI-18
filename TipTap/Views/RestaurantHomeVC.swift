
import UIKit
import SVProgressHUD
struct ItemsWithCategory{
    var  CategoryTitle : String
    var item : [ItemCompleteData]
}

struct getImageArrays : Codable {
    let images : String
}

var commandForChecking : Bool = false
class RestaurantHomeVC: UIViewController, UITextFieldDelegate {
    let fontName = "HelveticaNeue"
    var givenRating = 0
    var restaurantImages = [RestaurantImage]()
    var getImageArray = [String]()
    var selectedImageFoRCusines  = ""
    var getRestarantImage = [RestaurantImage]()
    var gettingSingleImage1: String = ""
    var getRatingAfterDelate : Double?
    @IBOutlet weak var openAtTopViewHeightConstrn: NSLayoutConstraint!
    var cusineImage : String = ""
    
    @IBOutlet weak var openAtViewHeightConstrn: NSLayoutConstraint!
    
    @IBOutlet weak var openAttimeViewHeightConstrn: NSLayoutConstraint!
    
    @IBOutlet weak var contactViewHeightConstrn: NSLayoutConstraint!
    @IBOutlet weak var contactVieTopViewHeightConstrn: NSLayoutConstraint!
    
    @IBOutlet weak var contactViewBottomViewHeightConstrn: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var internetCheckTimer: Timer?
    var  ReviewDelegate : ReviewPostingDelegate?
    
    @IBOutlet weak var seeAllReviewsButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    var matchingRestaurant_ID : [ String ] = []
    //var AllRestaurant_data : [Any] = []
    var matchingRestaurants: [RestaurantCompleteData] = []
    var filterRestaurantsForSearch :  [RestaurantCompleteData] = []
    var restaurantRatingsDataArray = [RestaurantRatingData]()
    //  var DeletedRatingCount = 0
    @IBOutlet weak var ratingView: CosmosView!
    var restaurantID = String()
    var restarentTitle = ""
    var reviewModel = [ReviewModel]()
    var waiterModel = [Waiters]()
    var waitersForSelectedRestaurant = [WaiterCompleteData]()
    var waiterModelForSearch = [WaiterCompleteData]()
    var waiterRatingsArray = [waiterRating]()
    var ItemRatingReviewDataArray = [ItemRatingReviewData]()
    let imageArray = ["1", "2", "3", "1","1", "2", "3", "4"]
    let dishesArray = ["interior1","interior2","interior3","interior4","interior5"]
    
    var FoodImages: [String] = ["1", "2", "3", "1","1", "2", "3", "4"]//cuisines
    
    var CuisineImages: [String] = ["1", "2", "3", "1","1", "2", "3", "4"]
    
    
    var currentIndex = 0
    var totalItems = 0
    var scrollTimer: Timer?
    var isScrolling = false
    var restaurantName : String = ""
    var ItemID : String?
    var selectedRestaurantData = [RestaurantCompleteData]()
    
    
    var selectedFor : String = ""
    var restaurantMenuItemCategoryData = [ItemCategory]()
    var itemsGroupedByCategory : [ItemsWithCategory] = []
    //  var itemsGroupedByCategoryForSearch : [[ItemCompleteData]] = []
    var itemsGroupedByCategoryForSearch : [ItemsWithCategory] = []
    
    var  SingaleRestaurantRatingArray = [userRatings]()
    var selectedSignatureItem = [ItemCompleteData]()
    var selectedCuisine : [ItemCompleteData] = []
    var userRating: Int = 0
    var previousRestaurantRatingByLoginUser :[RestaurantRatingData] = []
    var previousItemRatingByLoginUser : [ItemRatingReviewData] = []
    
    
    var loginuserFavouriteRestaurantArray = [String]() // For store Fav Restaurant
    var loginuserFavouriteItemArray =  [UserFavItemIDs]()
    @IBOutlet weak var searchTF: UITextField!{
        didSet{
            searchTF.tintColor = .lightGray
            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
            searchTF.applyCustomPlaceholderStyle(size: "large")
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBOutlet weak var reviewTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var waiterListButton: UIButton!
    @IBOutlet weak var ratingViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var ratingsAndReviewHeadingLAbel: UILabel!
    @IBOutlet weak var ratedOutofLabel: UILabel!
    @IBOutlet weak var rateThisPlaceLabel: UILabel!
    
    @IBOutlet var ratingStarCollection: [UILabel]!
    
    @IBOutlet var ratingPercentLabelCollection: [UILabel]!
    
    @IBOutlet weak var allRatingaAndReviewHeadingLabel: UILabel!
    @IBOutlet weak var rateAndReviewButton: UIButton!
    @IBOutlet weak var submitCommentButton: UIButton!
    @IBOutlet weak var yourCommentLabel: UILabel!
    @IBOutlet weak var leaveaCommentTitleLAbel: UILabel!
    @IBOutlet weak var rateThePlaceCommentLabel: UILabel!
    
    @IBOutlet weak var resstaurantCategoryName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var restaurantDescriptionLabel: UILabel!
    @IBOutlet weak var restaurantReviewCountIntro: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var openAtLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var restaurantnameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contactLAbel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var viewAllButton2: UIButton!
    @IBOutlet weak var viewAllButton1: UIButton!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var rateThisPlaceView: UIView!
    @IBOutlet weak var menuTableviewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var allRatingdAndReviewsView: UIView!
    @IBOutlet weak var leaveYourCommentView: UIView!
    @IBOutlet weak var ratingsAndreviewsView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var fifthStarProgressView: UIProgressView!
    @IBOutlet weak var fourthStarProgressView: UIProgressView!
    @IBOutlet weak var threeStarProgressView: UIProgressView!
    @IBOutlet weak var twoStarProgressView: UIProgressView!
    @IBOutlet weak var oneStarProgressView: UIProgressView!
    
    @IBOutlet weak var leaveCommentTF: UITextField!
    
    @IBOutlet weak var rateThisPlaceUserAction: CosmosView!
    
    @IBOutlet weak var userEnteredRating: CosmosView!
    override func viewDidLoad() {
        
        SVProgressHUD.show()
        
        DispatchQueue.main.async {
            super.viewDidLoad()
            
            
            self.indicator.hidesWhenStopped = true
            self.internetCheckTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkInternet), userInfo: nil, repeats: true)
            self.internetCheckTimer?.tolerance = 2.0
            self.updatingprogress()
            
            self.restaurantRatingsDataArray.removeAll()
            
            self.rateThisPlaceUserAction.rating = 0
            self.rateThisPlaceUserAction.text = ""
            self.userEnteredRating.rating = 0
            self.userEnteredRating.text = ""
            
            self.MenuTableView.delegate = self
            self.MenuTableView.dataSource = self
            self.reviewTableView.delegate = self
            self.reviewTableView.dataSource = self
            self.introCollectionView.dataSource = self
            self.introCollectionView.delegate = self
            
            self.totalItems = self.dishesArray.count
            //   self.startAutoScroll()
            self.setUI()
            self.searchTF.delegate = self
            
            self.leaveCommentTF.delegate = self
            
            // Set any additional properties if needed
            self.rateThisPlaceUserAction.settings.fillMode = .full
            self.rateThisPlaceUserAction.settings.updateOnTouch = true
            
            // Add the closure to handle user interaction
            self.rateThisPlaceUserAction.didTouchCosmos = { rating in
                print("User rated \(rating) stars")
                self.userRating = Int(rating)
                self.userEnteredRating.rating = rating
                self.userEnteredRating.text = "\(rating)"
                self.rateThisPlaceUserAction.rating = rating
                self.rateThisPlaceUserAction.text = "\(rating)"
            }
            self.userEnteredRating.settings.fillMode = .full
            self.userEnteredRating.settings.updateOnTouch = true
            self.userEnteredRating.didTouchCosmos = { rating in
                print("User rated \(rating) stars")
                self.userRating = Int(rating)
                self.userEnteredRating.rating = rating
                self.userEnteredRating.text = "\(rating)"
                self.rateThisPlaceUserAction.rating = rating
                self.rateThisPlaceUserAction.text = "\(rating)"
                
            }
            let tipTapHomeVC = TipTapHomeVC()
            self.ReviewDelegate = tipTapHomeVC
        }
        DispatchQueue.main.async {
            self.leaveCommentTF.delegate = self
        }
        getRatingAfterDelate = 0.0
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func updatingprogress() {
        self.fetchUserData { result in
            switch result {
            case .success:
                print("Fetch user data successful")
                if self.selectedFor == "restaurant"{
                    self.setImagesInCollectionView(selectedFor:"restaurant")
                    self.filterRestaurantRatingReview()
                }else if self.selectedFor == "cuisines"{
                    
                    self.setImagesInCollectionView(selectedFor:"cuisines")
                    
                    self.fetchItemRatingJsonData(Item: self.selectedCuisine[0])
                    DispatchQueue.main.async{
                        self.restaurantReviewCountIntro.text = "(\(self.selectedCuisine[0].ItemRatings.count))"
                        
                        
                    }
                }else{
                    self.fetchItemRatingJsonData(Item: self.selectedSignatureItem[0])
                    DispatchQueue.main.async{
                        self.setImagesInCollectionView(selectedFor:"")
                        self.restaurantReviewCountIntro.text = "(\(self.selectedSignatureItem[0].ItemRatings.count))"
                        //  self.starsView.rating = self.selectedSignatureItem[0].itemAverageRating ?? 0.0
                        //  self.starsView.text = "\(self.selectedSignatureItem[0].itemAverageRating ?? 0.0)"
                        
                        self.reviewTableView.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
                // Handle error
            }
        }
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedFor == "restaurant"{
            //  filterRestaurantRatingReview()
            
            filterItemBasedOnRestaurant{
                
                print("filterItemBasedOnRestaurant successfull")
            }
        }
    }
    
    @IBAction func contactButtonAction(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(identifier: "RestaurnatContactViewController")as! RestaurnatContactViewController
        controller.selectedFor = selectedFor
        controller.selectedRestaurantData = selectedRestaurantData
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        introCollectionView.reloadData()
        if selectedFor == "restaurant"{
            if itemsGroupedByCategoryForSearch.isEmpty{
                //  menuView.isHidden = true
                menuLabel.isHidden = true
            }else{
                menuLabel.isHidden = false
            }
            
            if itemsGroupedByCategoryForSearch.isEmpty && waiterModelForSearch.isEmpty{
                menuView.isHidden = true
                menuTableviewHeight.constant = 0
            }
            
            restaurantnameLabel.text = selectedRestaurantData[0].restaurant.RestaurantTitle
            restaurantDescriptionLabel.text = selectedRestaurantData[0].restaurant.RestaurantCategory
            openAtLabel.text = "Opening Hours: "
            //restaurantCategory
            //restaurantDescrption
            openTimeLabel.text = selectedRestaurantData[0].restaurant.OpeningHours
            resstaurantCategoryName.text = selectedRestaurantData[0].restaurant.Description
            
            
        }else if selectedFor == "cuisines"{
            headerView.isHidden = true
            contactViewHeightConstrn.constant = 0
            openAtTopViewHeightConstrn.constant = 0
            openAttimeViewHeightConstrn.constant = 0
            openAtViewHeightConstrn.constant = 0
            contactVieTopViewHeightConstrn.constant = 0
            contactViewBottomViewHeightConstrn.constant = 0
            
            if filterRestaurantsForSearch.count == 0{
                menuView.isHidden = true
            }
            restaurantnameLabel.text = selectedCuisine[0].Item.CusineTitle
            //   fetchItemRatingJsonData(ItemID: self.ItemID ?? "" )
            restaurantDescriptionLabel.text = selectedCuisine[0].Item.ItemTitle
            openAtLabel.text = "Item Description:  "
            resstaurantCategoryName.text = selectedCuisine[0].Item.Description
            
            
        }
        else{
            headerView.isHidden = true
            contactViewHeightConstrn.constant = 0
            openAtTopViewHeightConstrn.constant = 0
            openAttimeViewHeightConstrn.constant = 0
            openAtViewHeightConstrn.constant = 0
            contactVieTopViewHeightConstrn.constant = 0
            contactViewBottomViewHeightConstrn.constant = 0
            
            if filterRestaurantsForSearch.count == 0{
                menuView.isHidden = true
            }
            restaurantnameLabel.text = selectedSignatureItem.first?.Item.ItemTitle
            // fetchItemRatingJsonData(ItemID: self.ItemID ?? "" )
            restaurantDescriptionLabel.text = selectedSignatureItem.first?.Item.CusineTitle
            openAtLabel.text = "Description: "
            resstaurantCategoryName.text = selectedSignatureItem.first?.Item.Description
            
            
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    func showActivityIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
        
    }
    
    // Function to hide the activity indicator
    func hideActivityIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    @objc func checkInternet() {
        if !Reachability.isConnectedToNetwork() {
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
    @IBAction func searchTextFieldChanged(_ sender: UITextField) {
        
        if selectedFor == "restaurant"{
            if let searchText = searchTF.text, !searchText.isEmpty {
                
                filterWaitersAndItems(with: searchText)
            }else{
                waiterModelForSearch.removeAll()
                //  waiterModelForSearch = JsonDataArrays.WaiterCompleteDataArray
                self.waiterModelForSearch = waitersForSelectedRestaurant
                itemsGroupedByCategoryForSearch = itemsGroupedByCategory
                calculateTableViewHeight()
                MenuTableView.reloadData()
            }
        }else{
            if let searchText = searchTF.text, !searchText.isEmpty {
                filterRestaurants(with: searchText)
            }else{
                filterRestaurantsForSearch = matchingRestaurants
                calculateTableViewHeight()
                MenuTableView.reloadData()
            }
            
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Scroll to the bottom of the scrollView
        let bottomOffset = CGPoint(x: 0, y: (scrollView.contentSize.height  - menuTableviewHeight.constant - 50))
        scrollView.setContentOffset(bottomOffset, animated: true)
        
        return true
    }
    func filterWaitersAndItems(with searchText: String) {
        // Filter waiters
        waiterModelForSearch = waitersForSelectedRestaurant.filter {
            if let firstName = $0.waiter.firstName, let lastName = $0.waiter.lastName {
                return firstName.lowercased().contains(searchText.lowercased()) || lastName.lowercased().contains(searchText.lowercased())
            } else {
                return false // Handle the case where either firstName or lastName is nil
            }
        }
        
        // Filter items
        itemsGroupedByCategoryForSearch = itemsGroupedByCategory.map { category in
            let filteredItems = category.item.filter {
                if let itemTitle = $0.Item.ItemTitle {
                    return itemTitle.lowercased().contains(searchText.lowercased())
                } else {
                    return false // Handle the case where ItemTitle is nil
                }
            }
            return ItemsWithCategory(CategoryTitle: category.CategoryTitle, item: filteredItems)
        }
        
        // Update itemsGroupedByCategoryForSearch with non-empty categories
        //  itemsGroupedByCategoryForSearch = itemsGroupedByCategoryForSearch.filter { !$0.item.isEmpty }
        
        print("Complete Item after Search count", itemsGroupedByCategoryForSearch.count)
        calculateTableViewHeight()
        MenuTableView.reloadData()
        reviewTableView.reloadData()
    }
    
    func filterRestaurants(with searchText: String) {
        filterRestaurantsForSearch = matchingRestaurants.filter {
            if let restaurantTitle = $0.restaurant.RestaurantTitle {
                return restaurantTitle.lowercased().contains(searchText.lowercased())
            } else {
                return false // Handle the case where RestaurantTitle is nil
            }
        }
        calculateTableViewHeight()
        MenuTableView.reloadData()
    }
    
    func filterItemBasedOnRestaurant(completion: @escaping () -> Void) {
        
        let items = JsonDataArrays.itemCompleteDataArray.filter {
            $0.Item.RestaurantID == selectedRestaurantData[0].restaurant.RestaurantID
        }
        
        let CategoryTitle = Set(items.compactMap({ $0.ItemCategory?.categoryTitle }))
        
        for cTitle in CategoryTitle {
            let filterItems = items.filter { $0.ItemCategory?.categoryTitle == cTitle }
            
            let itemsWithCategory = ItemsWithCategory(CategoryTitle: cTitle, item: filterItems)
            itemsGroupedByCategory.append(itemsWithCategory)
            
            itemsGroupedByCategoryForSearch = itemsGroupedByCategory
        }
        
        print("-> itemsGroupedByCategoryForSearch.count", itemsGroupedByCategoryForSearch.count)
        calculateTableViewHeight()
        self.MenuTableView.reloadData()
        completion()
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
    @IBAction func backBtnAction(_ sender: UIButton) {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    func setUI(){
        
        
        ratingView.settings.fillMode = .precise
        starsView.settings.fillMode = .precise
        viewAllButton1.isHidden = true
        viewAllButton2.isHidden = true
        //backButton.backButtonStyle()
        restaurantnameLabel.applyLabelStyle(for: .headingBlack)
        restaurantDescriptionLabel.applyLabelStyle(for: .subTitleLightGray)
        restaurantReviewCountIntro.applyLabelStyle(for: .descriptionLightGray)
        openAtLabel.applyLabelStyle(for: .descriptionLightGray)
        openTimeLabel.applyLabelStyle(for: .descriptionLightGray)
        contactLAbel.applyLabelStyle(for: .OfferWhite)
        menuLabel.applyLabelStyle(for: .headingBlack)
        viewAllButton1.viewAllButtonStyle(title: "view all", systemImageName: "chevron.right.2")
        viewAllButton2.viewAllButtonStyle(title: "Top rated", systemImageName: "")
        rateThisPlaceLabel.applyLabelStyle(for: .headingBlack)
        ratingsAndReviewHeadingLAbel.applyLabelStyle(for: .headingBlack)
        
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
        contactLAbel.layer.borderColor = UIColor.white.cgColor
        contactLAbel.layer.borderWidth = 1
        
        // Call the function for each view that needs shadows
        addShadow(to: rateThisPlaceView)
        addShadow(to: ratingsAndreviewsView)
        addShadow(to: leaveYourCommentView)
        addShadow(to: allRatingdAndReviewsView)
        if selectedFor != "restaurant"{
            menuLabel.isHidden = true
            switch selectedFor {
            case "cuisines":
                waiterListButton.isHidden = true
                
                MatchingIDs()
            case "dishes":
                waiterListButton.isHidden = true
                
                fetchSignatureItemAvailableRestaurants()
            default:
                
                break
            }
            
        }else{
            fetchWaiterDataForSelectedRestaurant{
                SVProgressHUD.show()
                
            }
            // fetchWaiterRatingsData()
            // fetchItemCategoryData(restaurantID: selectedRestaurantData[0].restaurant.RestaurantID)
            //itemsGroupedByCategory = fetchRestaurantMenuItemData(restaurantID: selectedRestaurantData[0].restaurant.RestaurantID)
            //itemsGroupedByCategoryForSearch.removeAll()
            // itemsGroupedByCategoryForSearch = itemsGroupedByCategory
            
            // print("Complete Item after Search", itemsGroupedByCategoryForSearch)
        }
        SVProgressHUD.dismiss()
    }
    
    func fetchSignatureItemAvailableRestaurants(){
        let matching = JsonDataArrays.restaurantCompleteDataArray.filter { $0.restaurant.RestaurantID == self.selectedSignatureItem[0].Item.RestaurantID }
        
        for restaurant in matching {
            // Check if the restaurant with the same ID is not already in the array before appending
            if !matchingRestaurants.contains(where: { $0.restaurant.RestaurantID == restaurant.restaurant.RestaurantID }) {
                matchingRestaurants.append(restaurant)
            }
        }
        filterRestaurantsForSearch =  matchingRestaurants
    }
    
    func filterRestaurantRatingReview() {
        DispatchQueue.main.async {
            self.restaurantnameLabel.text = self.selectedRestaurantData[0].restaurant.RestaurantTitle
            self.restaurantnameLabel.text = self.selectedRestaurantData[0].restaurant.RestaurantImage
        }
        
        
        self.restaurantRatingsDataArray.removeAll()
        self.SingaleRestaurantRatingArray = self.selectedRestaurantData[0].restaurantRatings
        
        for i in SingaleRestaurantRatingArray {
            if let matchingUser = JsonDataArrays.userDataArray.first(where: { $0.UserID == i.UserId }) {
                let userRatingData = RestaurantRatingData(RestaurantratingID: i.RestaurantRateId ?? "", RestaurantID: i.RestaurantId, UserID: matchingUser.UserID, UserTitle: (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? ""), UserImage: matchingUser.Userimage, Rating: i.Rating, Review: i.Review, RatingDate: i.RatingDate)
                self.restaurantRatingsDataArray.append(userRatingData)
                self.restaurantRatingsDataArray.reverse()
            }
        }
        
        //cccccccccccccccccccccc
        DispatchQueue.main.async {
            self.reviewTableView.reloadData()
            self.seeAllReviewsButton.isHidden = self.restaurantRatingsDataArray.count <= 3
        }
        
        
        
        // Calculate Average Rating
        let totalRating = selectedRestaurantData[0].restaurantRatings.reduce(0) { total, ratingData in
            if let rating = ratingData.Rating {
                return total + rating
            } else {
                return total
            }
        }
        
        let numberOfRatings = selectedRestaurantData[0].restaurantRatings.count
        
        guard numberOfRatings > 0 else {
            DispatchQueue.main.async {
                self.ratingView.rating = 0 // To avoid division by zero
                self.ratingView.text = "0.0"
                self.restaurantReviewCountIntro.text = "(0)"
                self.starsView.rating = 0
                self.starsView.text = "0.00"
                self.reviewTableView.reloadData()
                self.ratingViewHeightConstarints.constant = 0
                self.ratingsAndreviewsView.isHidden = true
                self.rateAndReviewButton.isHidden = true
                
            }
            return
        }
        
        DispatchQueue.main.async {
            self.restaurantReviewCountIntro.text = "(\(numberOfRatings))"
            self.starsView.rating = self.selectedRestaurantData[0].restaurantAverageRating ?? 0.0
            self.starsView.text = "\(self.selectedRestaurantData[0].restaurantAverageRating ?? 0.0)"
            self.reviewTableView.reloadData()
            
            if self.restaurantRatingsDataArray.isEmpty {
                self.ratingViewHeightConstarints.constant = 0
                self.allRatingdAndReviewsView.isHidden = true
                self.ratingsAndreviewsView.isHidden = true
                self.rateAndReviewButton.isHidden = true
            } else {
                self.setRatingOnView()
                self.ratingsAndreviewsView.isHidden = false
                self.rateAndReviewButton.isHidden = false
                self.allRatingdAndReviewsView.isHidden = false
                self.ratingViewHeightConstarints.constant = 280
            }
        }
    }
    
    func MatchingIDs() {
        
        for id in matchingRestaurant_ID {
            let matching = JsonDataArrays.restaurantCompleteDataArray.filter { $0.restaurant.RestaurantID == id }
            
            for restaurant in matching {
                // Check if the restaurant with the same ID is not already in the array before appending
                if !matchingRestaurants.contains(where: { $0.restaurant.RestaurantID == restaurant.restaurant.RestaurantID }) {
                    matchingRestaurants.append(restaurant)
                }
            }
        }
        filterRestaurantsForSearch =  matchingRestaurants
        
    }
    
    func fetchUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        let apiUrlString = userURL
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            completion(.failure(APIError.invalidURL))
            return
        }
        
        fetchJSONData(from: apiUrl) { (result: Result<fetchUserApiResponse, APIError>) in
            switch result {
            case .success(let jsonData):
                
                if let records = jsonData.records {
                    JsonDataArrays.userDataArray = records
                }
                completion(.success(()))
                
            case .failure(let error):
                print("Error in fetchUserData: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    @IBAction func waiterListButtonAction(_ sender: UIButton) {
        self.showHUD()
        if !waiterModelForSearch.isEmpty {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let controller = self.storyboard?.instantiateViewController(identifier: "waiterListViewController") as! waiterListViewController
                controller.modalTransitionStyle = .coverVertical
                controller.waiterModelForSearch = self.waiterModelForSearch
                self.present(controller, animated: true)
                self.hideHUD()
            }
            
            
        }else{
            waiterListButton.isHidden = true
            
            hideHUD()
        }
        
    }
    
    
    
    
    
    
    func setRatingOnView() {
        
        var ratingCounts: [Int: Int] = [:]
        var totalRatings: Int = 0
        
        if self.selectedFor == "restaurant" {
            // Grouping and counting ratings for restaurant
            ratingCounts = Dictionary(grouping: self.restaurantRatingsDataArray, by: { ratingData in
                return ratingData.Rating ?? 0
            }).mapValues { $0.count }
            
            totalRatings = self.restaurantRatingsDataArray.count
            
            self.previousRestaurantRatingByLoginUser = self.restaurantRatingsDataArray.filter {
                $0.UserID == loginUserID
            }
            let previousReviewCount = self.previousRestaurantRatingByLoginUser.count
            
            self.yourCommentLabel.text = previousReviewCount > 0 ? "Your Previous Review" : "New Review"
            if previousReviewCount > 0, let previousRating = self.previousRestaurantRatingByLoginUser[0].Rating {
                self.rateThisPlaceUserAction.text = "\(previousRating)"
                self.rateThisPlaceUserAction.rating = Double(previousRating)
                self.userEnteredRating.text = "\(previousRating)"
                self.userEnteredRating.rating = Double(previousRating)
                self.userRating = previousRating
            } else {
                self.rateThisPlaceUserAction.text = "0.0"
                self.rateThisPlaceUserAction.rating = 0.0
                self.userEnteredRating.text = "0.0"
                self.userEnteredRating.rating = 0.0
                self.userRating = 0
            }
            
            if let averageRating = selectedRestaurantData.first?.restaurantAverageRating {
                if getRatingAfterDelate == 0.0 {
                    
                    self.ratedOutofLabel.text = "Rated \(averageRating) out of 5"
                }else{
                    
                    self.ratedOutofLabel.text = "Rated \(getRatingAfterDelate?.rounded(toPlaces: 1) ?? 0) out of 5"
                }
                self.ratingView.rating = averageRating
                self.ratingView.text = String(averageRating)
            } else {
                self.ratedOutofLabel.text = "Rated 0.0 out of 5"
                self.ratingView.rating = 0
            }
            
        } else  {
            // Grouping and counting ratings for items
            ratingCounts = Dictionary(grouping: self.ItemRatingReviewDataArray, by: { ratingData in
                return ratingData.Rating ?? 0
            }).mapValues { $0.count }
            
            totalRatings = self.ItemRatingReviewDataArray.count
            
            self.previousItemRatingByLoginUser = self.ItemRatingReviewDataArray.filter {
                $0.UserID == loginUserID
            }
            let previousReviewCount = self.previousItemRatingByLoginUser.count
            
            self.yourCommentLabel.text = previousReviewCount > 0 ? "Your Previous Review" : "New Review"
            if previousReviewCount > 0, let previousRating = self.previousItemRatingByLoginUser[0].Rating {
                self.rateThisPlaceUserAction.text = "\(previousRating)"
                self.rateThisPlaceUserAction.rating = Double(previousRating)
                self.userEnteredRating.text = "\(previousRating)"
                self.userEnteredRating.rating = Double(previousRating)
                self.userRating = previousRating
            } else {
                self.rateThisPlaceUserAction.text = "0.0"
                self.rateThisPlaceUserAction.rating = 0.0
                self.userEnteredRating.text = "0.0"
                self.userEnteredRating.rating = 0.0
                self.userRating = 0
            }
            if  getRatingAfterDelate == 0.0 {
                let averageRating: Double
                if let signatureItemRating = selectedSignatureItem.first?.itemAverageRating {
                    averageRating = signatureItemRating
                    self.ratingView.rating = averageRating
                    self.ratingView.text = "\(averageRating.rounded(toPlaces: 2))"
                    self.starsView.rating = averageRating
                    self.starsView.text = "\(averageRating.rounded(toPlaces: 2))"
                    self.ratedOutofLabel.text = "Rated \(averageRating.rounded(toPlaces: 2)) out of 5"
                    self.ratingView.rating = averageRating
                    self.ratingView.text = "\(averageRating.rounded(toPlaces: 2))"
                } else if let cuisineItemRating = selectedCuisine.first?.itemAverageRating {
                    averageRating = cuisineItemRating
                    self.ratingView.rating = averageRating
                    self.ratingView.text = "\(averageRating.rounded(toPlaces: 2))"
                    self.starsView.rating = averageRating
                    self.starsView.text = "\(averageRating.rounded(toPlaces: 2))"
                    self.ratedOutofLabel.text = "Rated \(averageRating.rounded(toPlaces: 2)) out of 5"
                }
                
            }else{
                
                self.ratingView.rating = getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                self.ratingView.text = "\( getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0)"
                self.starsView.rating = getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                
                self.starsView.text = "\(getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0)"
                self.ratedOutofLabel.text = "Rated \(getRatingAfterDelate?.rounded(toPlaces: 1) ?? 0) out of 5"
            }
        }
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
        
        if self.selectedFor == "restaurant" {
            let sumOfRatings = self.restaurantRatingsDataArray.reduce(0) { total, ratingData in
                return total + (ratingData.Rating ?? 0)
            }
            if totalRatings > 0 {
                let averageRating = Double(sumOfRatings) / Double(totalRatings)
                self.ratingView.rating = averageRating
                self.ratingView.text = "\(averageRating.rounded(toPlaces: 2))"
                self.starsView.rating = averageRating
                self.starsView.text = "\(averageRating.rounded(toPlaces: 2))"
                self.ratedOutofLabel.text = "Rated \(averageRating.rounded(toPlaces: 2)) out of 5"
                
            } else {
                self.ratingView.rating = 0
                self.ratingView.text = ""
                self.ratedOutofLabel.text = "Rated 0.0 out of 5"
            }
        } else if  self.selectedFor == "cuisines"{
            
            let sumOfRatings = self.ItemRatingReviewDataArray.reduce(0) { total, ratingData in
                return total + (ratingData.Rating ?? 0)
            }
            if totalRatings > 0 {
                let averageRating = Double(sumOfRatings) / Double(totalRatings)
                self.ratingView.rating = averageRating
                self.ratingView.text = "\(averageRating.rounded(toPlaces: 2))"
                self.starsView.rating = averageRating
                self.starsView.text = "\(averageRating.rounded(toPlaces: 2))"
                self.ratedOutofLabel.text = "Rated \(averageRating.rounded(toPlaces: 2)) out of 5"
                
            } else {
                self.ratingView.rating = 0
                self.ratingView.text = ""
                self.ratedOutofLabel.text = "Rated 0.0 out of 5"
            }
        }
        if  previousRestaurantRatingByLoginUser.isEmpty  {
            userEnteredRating.isUserInteractionEnabled = true
        }else{
            userEnteredRating.isUserInteractionEnabled = false
        }
        if  previousItemRatingByLoginUser.isEmpty  {
            userEnteredRating.isUserInteractionEnabled = true
        }else{
            userEnteredRating.isUserInteractionEnabled = false
        }
    }
    
    func fetchItemRatingJsonData(Item: ItemCompleteData) {
        // Clear the existing data
        self.ItemRatingReviewDataArray.removeAll()
        
        let ItemRatingReviewArray = Item.ItemRatings
        
        // Process each item rating review
        for itemRatingReview in ItemRatingReviewArray {
            // Find the matching user
            if let matchingUser = JsonDataArrays.userDataArray.first(where: { $0.UserID == itemRatingReview.userID }) {
                let userName = (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? "")
                let userRatingItemData = ItemRatingReviewData(
                    RowKey: itemRatingReview.RowKey,
                    ItemRatingId: itemRatingReview.itemRatingId,
                    RestaurantID: itemRatingReview.restaurantID,
                    UserID: itemRatingReview.userID,
                    UserTitle: userName,
                    UserImage: matchingUser.Userimage,
                    Rating: itemRatingReview.rating,
                    Review: itemRatingReview.review,
                    RateDate: itemRatingReview.RateDate
                )
                self.ItemRatingReviewDataArray.append(userRatingItemData)
            }
        }
        
        // Reverse the array to maintain order
        self.ItemRatingReviewDataArray.reverse()
        
        // Filter the ratings by the logged-in user
        self.previousItemRatingByLoginUser = self.ItemRatingReviewDataArray.filter { $0.UserID == loginUserID }
        
        // Update the UI on the main thread
        DispatchQueue.main.async {
            self.reviewTableView.reloadData()
            self.seeAllReviewsButton.isHidden = self.ItemRatingReviewDataArray.count <= 3
            
            // Calculate average rating
            let totalRating = ItemRatingReviewArray.reduce(0) { total, ratingData in
                return total + (ratingData.rating ?? 0)
            }
            
            let numberOfRatings = ItemRatingReviewArray.count
            
            guard numberOfRatings > 0 else {
                // No ratings
                self.ratingView.rating = 0
                self.restaurantReviewCountIntro.text = "(0)"
                //  self.starsView.rating = 0
                //  self.starsView.text = "0.00"
                self.reviewTableView.reloadData()
                self.ratingViewHeightConstarints.constant = 0
                self.ratingsAndreviewsView.isHidden = true
                self.rateAndReviewButton.isHidden = true
                self.allRatingdAndReviewsView.isHidden = true
                return
            }
            
            let averageRating = Double(totalRating) / Double(numberOfRatings)
            
            // Update average rating UI
            self.restaurantReviewCountIntro.text = "(\(numberOfRatings))"
            self.starsView.rating = averageRating.rounded(toPlaces: 2)
            self.starsView.text = "\(averageRating.rounded(toPlaces: 2))"
            self.ratingView.rating = averageRating.rounded(toPlaces: 2)
            self.ratingView.text = "\(averageRating.rounded(toPlaces: 2))"
            self.ratedOutofLabel.text = "Rated \(averageRating.rounded(toPlaces: 2))  out of 5"
            if self.ItemRatingReviewDataArray.isEmpty {
                self.ratingViewHeightConstarints.constant = 0
                self.allRatingdAndReviewsView.isHidden = true
                self.ratingsAndreviewsView.isHidden = true
                self.rateAndReviewButton.isHidden = true
            } else {
                self.setRatingOnView()
                self.ratingsAndreviewsView.isHidden = false
                self.rateAndReviewButton.isHidden = false
                self.allRatingdAndReviewsView.isHidden = false
                self.ratingViewHeightConstarints.constant = 280
            }
        }
    }
    func addShadow(to view: UIView) {
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
    }
    
    @IBAction func SubmitCommentBtnAction(_ sender: UIButton) {
        
        if selectedFor == "restaurant"{
            
            guard let review = leaveCommentTF.text, review != "",userRating > 0 else {
                showAlert(title: "Error", message: "Review and Star Rating is required")
                
                return
            }
            
            showActivityIndicator()
            if previousRestaurantRatingByLoginUser.count > 0{
                updateRestaurantReview(review: review)
            }
            else{
                postCommentToRestaurantRating(review: review)
                
            }
            
            
            hideActivityIndicator()
        }
        else if selectedFor == "cuisines"{
            guard let review = leaveCommentTF.text, review != "",userRating > 0 else {
                showAlert(title: "Error", message: "Review and Star Rating is required")
                return
            }
            if previousItemRatingByLoginUser.count > 0{
                updateItemReview(review: review, reviewType: "cuisines")
            }
            else{
                postCommentToItemRating(review: review, reviewType: "cuisines")
            }
            hideActivityIndicator()
        }else{
            guard let review = leaveCommentTF.text, review != "",userRating > 0 else {
                showAlert(title: "Error", message: "Review and Star Rating is required")
                return
            }
            if previousItemRatingByLoginUser.count > 0{
                updateItemReview(review: review, reviewType: "dishes")
            }
            else{
                postCommentToItemRating(review: review, reviewType: "dishes")
            }
            
            hideActivityIndicator()
        }
        
        leaveCommentTF.text = ""
    }
    
    
    
    func postCommentToItemRating(review: String, reviewType: String) {
        
        let urlString = ItemRatingURL
        var requestBody: [String: Any] = [:]
        guard let loginUserID = loginUserID, loginUserID != "" else{return}
        guard selectedCuisine.count > 0 || selectedSignatureItem.count > 0 else{return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        switch reviewType{
        case "cuisines":
            
            requestBody =  [
                "ItemID": selectedCuisine[0].Item.ItemID ?? "",
                "RestaurantID": selectedCuisine[0].Item.RestaurantID ?? "",
                "Rating": userRating,
                "Review": review,
                "UserID": loginUserID,
                "RateDate" : currentDate,
                "Disable": false
            ]
            
        case "dishes":
            requestBody =  [
                "ItemID": selectedSignatureItem[0].Item.ItemID ?? "",
                "RestaurantID": selectedSignatureItem[0].Item.RestaurantID ?? "",
                "Rating": userRating,
                "Review": review,
                "UserID": loginUserID,
                "RateDate" : currentDate,
                "Disable": false
            ]
        default:
            break
        }
        
        guard let apiUrl = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
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
                    
                    print("item Ratings updated successfully")
                    SVProgressHUD.show()
                    DispatchQueue.main.async {
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    if let record = json["record"] as? [String: Any] {
                                        if let ItemRatingId = record["RowKey"] as? String {
                                            print("Review: \(record["Review"] ?? "No Review")")
                                            
                                            
                                            self.fetchUpdatedItemReview(UpdatedItemRatingID: ItemRatingId){
                                                self.viewDidLoad()
                                                SVProgressHUD.dismiss()
                                                
                                            }
                                        }
                                    }
                                }
                            } catch {
                                print("Error decoding response data: \(error)")
                            }
                        }
                        
                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                        controller.modalPresentationStyle = .fullScreen
                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .item)
                        controller.message = "Item ratings submited successfully"
                        self.present(controller, animated: true)
                        //  print("Restaurant ratings updated successfully")
                        
                    }
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
        hideActivityIndicator()
    }
    
    
    
    func updateItemReview(review: String, reviewType: String) {
        
        guard let updateURL = URL(string: ItemRatingURL) else {
            print("Invalid API URL")
            return
        }
        print("Update URL: \(updateURL)")
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let previousItemRatingID = previousItemRatingByLoginUser.first?.RowKey else {
            showAlert(title: "Error", message: "Previous item rating ID not found")
            return
        }
        print("Previous Item Rating ID: \(previousItemRatingID)")
        
        var updatedDetails: [String: Any] = [:]
        guard let loginUserID = loginUserID, !loginUserID.isEmpty else { return }
        guard selectedCuisine.count > 0 || selectedSignatureItem.count > 0 else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let currentDate = dateFormatter.string(from: Date())
        
        switch reviewType {
        case "cuisines":
            updatedDetails = [
                
                "PartitionKey": "ItemRating",
                "RowKey": previousItemRatingID,
                "ItemID": selectedCuisine[0].Item.ItemID ?? "",
                "RestaurantID": selectedCuisine[0].Item.RestaurantID ?? "",
                "Rating": userRating,
                "RateDate": currentDate,
                "UserID": loginUserID,
                "Review": review
            ]
        case "dishes":
            updatedDetails = [
                "PartitionKey": "ItemRating",
                "RowKey": previousItemRatingID,
                "ItemID": selectedSignatureItem[0].Item.ItemID ?? "",
                "RestaurantID": selectedSignatureItem[0].Item.RestaurantID ?? "",
                "Rating": userRating,
                "RateDate": currentDate,
                "Review": review,
                "UserID": loginUserID
            ]
            
        default:
            break
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updatedDetails)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON data sent to server: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error updating item details: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Update Failed", message: "Failed to update item ratings. Please try again.")
                }
            } else if let response = response as? HTTPURLResponse {
                if (200..<300).contains(response.statusCode) {
                    if let data = data {
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("Full Response Data: \(jsonResponse)") // Inspect the full response
                                
                                // Accessing the 'record' dictionary
                                if let recordData = jsonResponse["record"] as? [String: Any],
                                   let updatedRating = recordData["Rating"] as? Int {
                                    print("Updated Rating: \(updatedRating)")
                                    DispatchQueue.main.async {
                                        self.updateAverageRatingCusines(with: updatedRating)
                                    }
                                } else {
                                    print("Rating not found in 'record' response")
                                }
                            } else {
                                print("Failed to cast JSON response as [String: Any]")
                            }
                        } catch {
                            print("Error parsing JSON: \(error.localizedDescription)")
                        }
                        
                        
                        
                    }
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.fetchUpdatedItemReview(UpdatedItemRatingID: previousItemRatingID) {
                            self.updatingprogress()
                            // self.viewDidLoad()
                            // Reload table/collection view data to reflect changes
                            // or self.collectionView.reloadData()
                        }
                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                        controller.modalPresentationStyle = .fullScreen
                        controller.message = "Item ratings updated successfully"
                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .item)
                        self.present(controller, animated: true)
                    }
                } else {
                    print("Server returned an error: \(response.statusCode)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Update Failed", message: "Failed to update item ratings. Please try again.")
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    func fetchUpdatedItemReview(UpdatedItemRatingID: String, completion: @escaping () -> Void) {
        var updatedReviewData: ItemRatings?
        var selectedItem: ItemCompleteData?
        if selectedSignatureItem.isEmpty{
            selectedItem = selectedCuisine[0]
        }else{
            selectedItem = selectedSignatureItem[0]
        }
        let apiUrlString = ItemRatingURL + "?RowKey=\(UpdatedItemRatingID)"
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        fetchJSONData(from: apiUrl) { (result: Result<fetchItemRatingsApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                if let records = jsondata.record{
                    updatedReviewData = records
                    
                    if let IndexOfRatingInSelectedItem = selectedItem?.ItemRatings.firstIndex(where: {$0.RowKey == UpdatedItemRatingID}){
                        selectedItem?.ItemRatings[IndexOfRatingInSelectedItem] = updatedReviewData!
                    }else{
                        selectedItem?.ItemRatings.append(updatedReviewData!)
                        
                    }
                    
                    
                    
                    // Find the index of the item in the array
                    if let index = JsonDataArrays.itemCompleteDataArray.firstIndex(where: { $0.Item.ItemID == selectedItem?.Item.ItemID }) {
                        // Make sure ItemRatings property is accessible
                        if let rating = selectedItem?.ItemRatings {
                            JsonDataArrays.itemCompleteDataArray[index].ItemRatings = rating
                        }
                        var updatedItemCompleteData = JsonDataArrays.itemCompleteDataArray[index]
                        
                        // Update the ItemRatings array in the found item
                        if updatedItemCompleteData.ItemRatings.count > 0{
                            updatedItemCompleteData.ItemRatings = updatedItemCompleteData.ItemRatings.map { itemRating in
                                var updatedItemRating = itemRating
                                
                                
                                if itemRating.RowKey == UpdatedItemRatingID {
                                    // Update the properties of the ItemRating based on your logic
                                    updatedItemRating = updatedReviewData!
                                }
                                let averageRating = averageRating(forItemID: (updatedItemCompleteData.Item.ItemID)!)
                                updatedItemCompleteData.itemAverageRating = averageRating
                                
                                return updatedItemRating
                            }
                            
                        }else{
                            if let data = updatedReviewData{
                                updatedItemCompleteData.ItemRatings.append(data)
                            }
                        }
                        
                        
                        
                        JsonDataArrays.itemCompleteDataArray[index] = updatedItemCompleteData
                        
                        if self.selectedFor == "cuisines"{
                            self.selectedCuisine[0] = updatedItemCompleteData
                            self.fetchItemRatingJsonData(Item: self.selectedCuisine[0])
                        }else{
                            self.selectedSignatureItem[0] = updatedItemCompleteData
                            self.fetchItemRatingJsonData(Item: self.selectedSignatureItem[0])
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.reviewTableView.reloadData()
                        }
                        
                    }
                }
                completion()
            case .failure(let error):
                print("Error on fetchItemRatingJsonData: \(error)")
            }
        }
    }
    
    func postCommentToRestaurantRating(review: String) {
        showActivityIndicator()
        let urlString = restaurantRatingURL
        
        guard let apiUrl = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            
            return
        }
        guard let loginUserID = loginUserID, loginUserID != "" else{return}
        print("Request URL: \(apiUrl)")
        
        // Create the URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        
        // Create the request body
        let requestBody: [String: Any] =  [
            "RestaurantID": selectedRestaurantData.first?.restaurant.RestaurantID ?? "",
            "UserID": loginUserID,
            "Rating": userRating,
            "Review": review,
            "RatingDate": currentDate
        ]
        
        // Convert the request body to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                
                // Handle the error, e.g., show an alert to the user
                return
            }
            
            // Handle the response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    
                    DispatchQueue.main.async {
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    if let record = json["record"] as? [String: Any] {
                                        if let RestaurantRateId = record["RestaurantRateId"] as? String {
                                            print("Review: \(review), Rating: \(self.userRating)")
                                            
                                            self.fetchUpdatedRestaurantReview(UpdatedRestaurantRatingID: RestaurantRateId){
                                                
                                                
                                                self.viewDidLoad()
                                                
                                            }
                                        }
                                    }
                                }
                            } catch {
                                print("Error decoding response data: \(error)")
                            }
                        }
                        
                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                        controller.modalPresentationStyle = .fullScreen
                        
                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .restaurant)
                        controller.message = "Restaurant ratings updated successfully"
                        self.leaveCommentTF.text = ""
                        self.present(controller, animated: true)
                        //  print("Restaurant ratings updated successfully")
                        
                        
                    }
                    
                    //self.showAlert(title: "successful", message: "Restaurant ratings updated successfully")
                    // You may want to perform additional actions here if needed
                } else {
                    
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    // Handle other status codes if needed
                }
            }
            
        }.resume()
    }
    
    func updateRestaurantReview(review: String) {
        guard let updateURL = URL(string: restaurantRatingURL) else {
            print("Invalid API URL")
            return
        }
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let previuosRestaurantRatingID = previousRestaurantRatingByLoginUser.first?.RestaurantratingID else {
            print("restaurant ID not found")
            return
        }
        guard let loginUserID = loginUserID, !loginUserID.isEmpty else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        let updatedDetails: [String: Any] = [
            "RowKey": previuosRestaurantRatingID,
            "PartitionKey": "RestaurantRating",
            "RestaurantRateId": previuosRestaurantRatingID,
            "RestaurantID": selectedRestaurantData.first?.restaurant.RestaurantID ?? "",
            "UserID": loginUserID,
            "Rating": userRating,
            "Review": review,
            "RatingDate": currentDate
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updatedDetails)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON data sent to server: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error updating restaurant review: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Update Failed", message: "Failed to update restaurant ratings. Please try again.")
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                print("Server returned an error")
                DispatchQueue.main.async {
                    self.showAlert(title: "Update Failed", message: "Failed to update restaurant ratings. Please try again.")
                }
                return
            }
            
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let responseData = jsonResponse as? [String: Any],
                       let updatedRating = responseData["Rating"] as? Int {
                        print("Updated Rating: \(updatedRating)")
                        self.updateAverageRating(with: updatedRating)
                    } else {
                        print("Unexpected response data: \(jsonResponse)")
                    }
                } catch {
                    print("Error decoding JSON response: \(error.localizedDescription)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("Server response: \(responseString ?? "")")
            }
            
            print("Restaurant review updated successfully")
            
            DispatchQueue.main.async {
                self.fetchUpdatedRestaurantReview(UpdatedRestaurantRatingID: previuosRestaurantRatingID) {
                    self.viewDidLoad()
                }
                let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                controller.modalPresentationStyle = .fullScreen
                controller.message = "Restaurant review updated successfully"
                self.ReviewDelegate?.didPostReviewSuccessfully(for: .restaurant)
                SVProgressHUD.dismiss()
                self.present(controller, animated: true)
            }
        }
        task.resume()
    }
    
    func updateAverageRating(with updatedRating: Int) {
        if let restaurantRatings = self.restaurantRatingsDataArray as? [RestaurantRatingData] {
            let count = restaurantRatings.filter { $0.Rating != nil }.count
            let totalRating = restaurantRatings.reduce(0) { $0 + ($1.Rating ?? 0) }
            let plusValue = totalRating + updatedRating
            let averageRating: Double = count > 0 ? Double(plusValue) / Double(count) : 0
            
            self.getRatingAfterDelate = averageRating.rounded(toPlaces: 1)
            DispatchQueue.main.async { [self] in
                self.ratingView.rating = getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                self.ratingView.text = "\( getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0)"
                self.starsView.rating = getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                
                self.starsView.text = "\(String(describing: getRatingAfterDelate?.rounded(toPlaces: 2)))"
                self.ratedOutofLabel.text = "Rated \(getRatingAfterDelate?.rounded(toPlaces: 1) ?? 0) out of 5"
            }
        } else {
            print("restaurantRatingsDataArray is not properly initialized or cast.")
        }
    }
    func updateAverageRatingCusines(with updatedRating: Int) {
        // Ensure this is on the main thread
        
        if let restaurantRatings = self.ItemRatingReviewDataArray as? [ItemRatingReviewData] {
            let count = restaurantRatings.filter { $0.Rating != nil }.count
            //  let id = selectedSignatureItem[0].Item.ItemID
            let cusineData = self.selectedCuisine.first?.ItemRatings.first?.rating
            let dishesData = previousItemRatingByLoginUser.first?.Rating
            let commonTotal = (cusineData ?? 0) + (dishesData ?? 0)
            
            let totalRating = restaurantRatings.reduce(0) { $0 + ($1.Rating ?? 0) } - (commonTotal )
            let plusValue = totalRating + updatedRating
            let averageRating: Double = count > 0 ? Double(plusValue) / Double(count) : 0
            
            self.getRatingAfterDelate = averageRating.rounded(toPlaces: 1)
            
            // Debugging prints
            print("Updated Rating: \(updatedRating)")
            print("Average Rating: \(self.getRatingAfterDelate ?? 0.0)")
            
            // Ensure UI components are not nil
            if let ratingView = self.ratingView, let starsView = self.starsView, let ratedOutofLabel = self.ratedOutofLabel {
                ratingView.rating = self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                ratingView.text = "\(self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0)"
                starsView.rating = self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                starsView.text = "\(self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0)"
                ratedOutofLabel.text = "Rated \(self.getRatingAfterDelate?.rounded(toPlaces: 1) ?? 0) out of 5"
            } else {
                print("UI components are not properly initialized.")
            }
        } else {
            print("ItemRatingReviewDataArray is not properly initialized or cast.")
        }
        
    }
    func updateAverageRatingItem(with updatedRating: Int) {
        // Ensure this is on the main thread
        DispatchQueue.main.async {
            if let restaurantRatings = self.ItemRatingReviewDataArray as? [ItemRatingReviewData] {
                let count = restaurantRatings.filter { $0.Rating != nil }.count
                let cusineData = self.selectedCuisine.first?.ItemRatings.first?.rating
                let totalRating = restaurantRatings.reduce(0) { $0 + ($1.Rating ?? 0) } - (cusineData ?? 0)
                let plusValue = totalRating + updatedRating
                let averageRating: Double = count > 0 ? Double(plusValue) / Double(count) : 0
                
                self.getRatingAfterDelate = averageRating.rounded(toPlaces: 1)
                
                // Debugging prints
                print("Updated Rating: \(updatedRating)")
                print("Average Rating: \(self.getRatingAfterDelate ?? 0.0)")
                
                // Ensure UI components are not nil
                if let ratingView = self.ratingView, let starsView = self.starsView, let ratedOutofLabel = self.ratedOutofLabel {
                    ratingView.rating = self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                    ratingView.text = "\(self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0)"
                    starsView.rating = self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0.0
                    starsView.text = "\(self.getRatingAfterDelate?.rounded(toPlaces: 2) ?? 0)"
                    ratedOutofLabel.text = "Rated \(self.getRatingAfterDelate?.rounded(toPlaces: 1) ?? 0) out of 5"
                } else {
                    print("UI components are not properly initialized.")
                }
            } else {
                print("ItemRatingReviewDataArray is not properly initialized or cast.")
            }
        }
    }
    func fetchUpdatedRestaurantReview(UpdatedRestaurantRatingID: String, completion: @escaping () -> Void) {
        var updatedReviewData: userRatings?
        let apiUrlString = restaurantRatingURL + "?rowkey=\(UpdatedRestaurantRatingID)"
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        fetchJSONData(from: apiUrl) { [self] (result: Result<fetchRestaurantRatingApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                if let records = jsondata.record{
                    updatedReviewData = records
                    
                    if let IndexOfRatingInSelectedRestaurant = selectedRestaurantData[0].restaurantRatings.firstIndex(where: {$0.RestaurantRateId == UpdatedRestaurantRatingID}){
                        selectedRestaurantData[0].restaurantRatings[IndexOfRatingInSelectedRestaurant] = updatedReviewData!
                    }else{
                        selectedRestaurantData[0].restaurantRatings.append(updatedReviewData!)
                    }
                    
                    // Find the index of the item in the array
                    if let index = JsonDataArrays.restaurantCompleteDataArray.firstIndex(where: { $0.restaurant.RestaurantID == selectedRestaurantData[0].restaurant.RestaurantID }) {
                        // Make sure ItemRatings property is accessible
                        var updatedRestauranrtCompleteData = JsonDataArrays.restaurantCompleteDataArray[index]
                        
                        // Update the ItemRatings array in the found item
                        updatedRestauranrtCompleteData.restaurantRatings = updatedRestauranrtCompleteData.restaurantRatings.map { restaurantRating in
                            var updatedRestntRating = restaurantRating
                            if restaurantRating.RestaurantRateId == UpdatedRestaurantRatingID {
                                // Update the properties of the ItemRating based on your logic
                                updatedRestntRating = updatedReviewData!
                            }
                            return updatedRestntRating
                        }
                        
                        
                        JsonDataArrays.restaurantCompleteDataArray[index] = updatedRestauranrtCompleteData
                        
                    }
                }
                completion()
            case .failure(let error):
                print("Error on fetchUpdatedRestaurantReview: \(error)")
            }
        }
    }
    
    func fetchWaiterDataForSelectedRestaurant(completion: @escaping () -> Void) {
        waiterModelForSearch.removeAll()
        
        // Filter the waiters based on the selected restaurant's ID
        waitersForSelectedRestaurant = JsonDataArrays.WaiterCompleteDataArray.filter { waiter in
            return waiter.waiter.restaurantID == self.selectedRestaurantData[0].restaurant.RestaurantID
        }
        
        // Update the model with the filtered waiters
        self.waiterModelForSearch = waitersForSelectedRestaurant
        
        // Check if there are no waiters and update the button title
        if waitersForSelectedRestaurant.isEmpty {
            waiterListButton.isHidden = true
        } else {
            //  self.waiterListButton.titleLabel?.font = UIFont(name: fontName, size: 8)
            //self.waiterListButton.setTitle("Waiters Available", for: .normal)
            
        }
        
        // Calculate the table view height and reload data
        self.calculateTableViewHeight()
        self.MenuTableView.reloadData()
        
        // Dismiss the progress HUD
        SVProgressHUD.dismiss()
        
        // Call the completion handler
        completion()
    }
    
    
    
    @IBAction func rateAndReviewAutoscrollBtnAction(_ sender: UIButton) {
        
        // let viewToScrollTo = rateThisPlaceView
        
        let offset = CGPoint(x: 0, y: rateThisPlaceView.frame.origin.y - scrollView.contentInset.top)
        
        scrollView.setContentOffset(offset, animated: true)
    }
    @IBAction func seeAllbuttonAction(_ sender: UIButton) {
        
        print("seeAllbuttonAction")
        
        let allReviews = storyboard?.instantiateViewController(identifier: "AllReviewsVC") as! AllReviewsVC
        if selectedFor == "restaurant"{
            allReviews.restaurantRatingsDataArray = self.restaurantRatingsDataArray
            allReviews.RestaurantRating = true
        }else{
            allReviews.RestaurantRating = false
            allReviews.ItemRatingReviewDataArray = self.ItemRatingReviewDataArray
        }
        self.present(allReviews, animated: true)
    }
    
    
    
    func stopAutoScroll() {
        isScrolling = false
        scrollTimer?.invalidate()
        scrollTimer = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        leaveCommentTF.resignFirstResponder()
        return true
    }
}


extension RestaurantHomeVC:
    UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == MenuTableView{
            if selectedFor == "restaurant"{
                if !waiterModelForSearch.isEmpty{
                    return itemsGroupedByCategoryForSearch.count + 1
                }else{
                    return itemsGroupedByCategoryForSearch.count
                }
            }
            else{return 1}
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == MenuTableView {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
            
            let titleLabel = UILabel()
            titleLabel.applyLabelStyle(for: .headingBlack)
            titleLabel.numberOfLines = 1 // Adjust according to your layout
            
            let subtitleLabel = UILabel()
            subtitleLabel.applyLabelStyle(for: .headinglightGray)
            //  subtitleLabel.textColor = UIColor.gray
            subtitleLabel.numberOfLines = 1 // Adjust according to your layout
            
            headerView.addSubview(titleLabel)
            headerView.addSubview(subtitleLabel)
            
            if selectedFor == "restaurant" {
                if section < itemsGroupedByCategoryForSearch.count {
                    titleLabel.text = itemsGroupedByCategoryForSearch[section].CategoryTitle
                    subtitleLabel.text = "  (\(itemsGroupedByCategoryForSearch[section].item.count))"
                } else {
                    titleLabel.text = "Waiters"
                    subtitleLabel.text = "  (\(waiterModelForSearch.count))"
                }
            } else if selectedFor == "cuisines" {
                titleLabel.text = "Available  at"
                subtitleLabel.text = "  (\(filterRestaurantsForSearch.count.description))"
            } else {
                titleLabel.text = "Available  at"
                subtitleLabel.text = "  (\(filterRestaurantsForSearch.count.description))"
            }
            
            titleLabel.sizeToFit()
            subtitleLabel.sizeToFit()
            
            let totalWidth = titleLabel.frame.size.width + subtitleLabel.frame.size.width + 5 // Adjust spacing as needed
            let availableWidth = headerView.frame.size.width
            
            if totalWidth > availableWidth {
                // Calculate new width ratio for titleLabel based on its content
                let newTitleLabelWidth = titleLabel.frame.size.width * (availableWidth / totalWidth)
                
                titleLabel.frame = CGRect(x: 15, y: 0, width: newTitleLabelWidth, height: 22)
                subtitleLabel.frame = CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.size.width + 5, y: 0, width: availableWidth - newTitleLabelWidth - 20, height: 22)
            } else {
                titleLabel.frame = CGRect(x: 15, y: 0, width: titleLabel.frame.size.width, height: 22)
                subtitleLabel.frame = CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.size.width + 5, y: 0, width: subtitleLabel.frame.size.width, height: 22)
            }
            
            return headerView
            
        } else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == MenuTableView{
            return 30
        }else{
            return 0
        }
    }
    
    func calculateTableViewHeight() {
        let totalItemsCount = itemsGroupedByCategoryForSearch.reduce(0) { $0 + $1.item.count }
        let totalItemsAndWaiters = totalItemsCount + waiterModelForSearch.count
        
        var totalHeight: CGFloat = 0
        
        if selectedFor == "restaurant" {
            for section in 0..<itemsGroupedByCategoryForSearch.count {
                //                if itemsGroupedByCategoryForSearch[section].item.isEmpty {
                //                    totalHeight += 170 + 50 // Adjust the constants as needed
                //                } else {
                let categoryItemCount = itemsGroupedByCategoryForSearch[section].item.count
                totalHeight += CGFloat(categoryItemCount) * 170 + 50 // Adjust the constants as needed
                // }
            }
            
            //            if waiterModelForSearch.isEmpty {
            //                totalHeight += 40 + 150 // Adjust the constants as needed
            //            } else {
            totalHeight += CGFloat(waiterModelForSearch.count) * 170 + 50 // Adjust the constants as needed
            // }
        } else {
            totalHeight = CGFloat(filterRestaurantsForSearch.count) * 170 + 50 // Adjust the constants as needed
        }
        
        menuTableviewHeight.constant = totalHeight
        MenuTableView.reloadData()
        reviewTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == MenuTableView{
            
            if selectedFor == "restaurant" {
                
                if section < itemsGroupedByCategoryForSearch.count{
                    let categoryItemCount = itemsGroupedByCategoryForSearch[section].item.count
                    
                    return categoryItemCount
                    // }
                } else {
                    return waiterModelForSearch.count
                    
                }
            }
            else{
                menuTableviewHeight.constant = CGFloat((170 * filterRestaurantsForSearch.count) + 50)
                return filterRestaurantsForSearch.count
            }
        }else{
            
            if selectedFor == "restaurant"{
                let maxRowCount = min(3, restaurantRatingsDataArray.count)
                reviewTableHeightConstraint.constant = CGFloat(120 * maxRowCount)
                return maxRowCount
            }else{
                let maxCount = min(3, ItemRatingReviewDataArray.count)
                reviewTableHeightConstraint.constant = CGFloat(120 * maxCount)
                return maxCount
                
            }
        }
        
    }
    
    func fetchUserFavouriteItemsID(){
        
        fetchFavouriteItems{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.loginuserFavouriteItemArray = JsonDataArrays.FavouriteItemsIDArray
                self.MenuTableView.reloadData()
            }
        }
    }
    func fetchUserFavouriteRestaurantID(){
        fetchFavioureRestaurant {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.loginuserFavouriteRestaurantArray = JsonDataArrays.FavouriteRestaurantIDArray
                self.MenuTableView.reloadData()
                
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == MenuTableView{
            if selectedFor == "restaurant"{
                
                if indexPath.section < itemsGroupedByCategoryForSearch.count {
                    
                    let menuCell = MenuTableView.dequeueReusableCell(withIdentifier: "RestaurantMenuTVC", for: indexPath) as! RestaurantMenuTVC
                    menuCell.forRestaurant = false
                    
                    let item = itemsGroupedByCategoryForSearch[indexPath.section].item[indexPath.row]
                    if item.Item.ItemTitle != ""{
                        menuCell.configure(with: item)
                    }
                    
                    menuCell.reloadDataAfterFavActionClosure = { [weak self] in
                        //                           SVProgressHUD.show()
                        fetchFavouriteItems  {
                            self?.fetchUserFavouriteItemsID()
                            DispatchQueue.main.async {
                                
                                self?.MenuTableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                            
                        }
                    }
                    
                    
                    if !JsonDataArrays.FavouriteItemsIDArray.isEmpty{
                        if JsonDataArrays.FavouriteItemsIDArray.contains(where: { $0.itemID == item.Item.ItemID }){
                            menuCell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            menuCell.favoriteBtn.tintColor = .systemRed
                            menuCell.isFavorite = true
                        }else{
                            menuCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                            menuCell.isFavorite = false
                        }
                    }else{
                        menuCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        menuCell.isFavorite = false
                    }
                    
                    
                    SVProgressHUD.dismiss()
                    return menuCell
                    // }
                } else {
                    
                    let waiterCell = MenuTableView.dequeueReusableCell(withIdentifier: "WailterListTVC", for: indexPath) as! WailterListTVC
                    let waiter = waiterModelForSearch[indexPath.row]
                    waiterCell.configure(with: waiter)
                    SVProgressHUD.dismiss()
                    return waiterCell
                    //  }
                }
            }
            
            else if selectedFor == "cuisines"{
                
                if filterRestaurantsForSearch.isEmpty{
                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    emptyCell.textLabel?.text = "No Restaurants found"
                    emptyCell.textLabel?.textAlignment = .center
                    return emptyCell
                }else{
                    let menuCell = MenuTableView.dequeueReusableCell(withIdentifier: "RestaurantMenuTVC", for: indexPath)as! RestaurantMenuTVC
                    menuCell.forRestaurant = true
                    if indexPath.row < filterRestaurantsForSearch.count {
                        
                        let GetIndex = filterRestaurantsForSearch[indexPath.row]
                        
                        
                        
                        menuCell.reloadDataAfterFavActionClosure = { [weak self] in
                            //                           SVProgressHUD.show()
                            fetchFavioureRestaurant {
                                self?.fetchUserFavouriteRestaurantID()
                                DispatchQueue.main.async {
                                    
                                    self?.MenuTableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                                
                            }
                        }
                        
                        menuCell.restaurantData = GetIndex
                        
                        if !JsonDataArrays.FavouriteRestaurantIDArray.isEmpty {
                            if let restaurantID = GetIndex.restaurant.RestaurantID {
                                if JsonDataArrays.FavouriteRestaurantIDArray.contains(restaurantID) {
                                    menuCell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                    menuCell.isFavorite = true
                                } else {
                                    menuCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                                    menuCell.isFavorite = false
                                }
                            }
                        }else{
                            menuCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                            menuCell.isFavorite = false
                        }
                        
                        menuCell.setcellUI()
                        menuCell.RestuarantNameLabel.text = GetIndex.restaurant.RestaurantTitle
                        
                        menuCell.resturantDescriptnLabl.text = GetIndex.restaurant.RestaurantCategory
                        menuCell.estimatedTimeLabel.text = GetIndex.restaurant.RestaurantAddress
                        menuCell.RatingLabel.text = "\(GetIndex.restaurantAverageRating ?? 0.0) (\(GetIndex.restaurantRatings.count))"
                        if GetIndex.rstaurantOffers?.offerID ?? "" != ""{
                            menuCell.OfferTitlelabel.text = GetIndex.rstaurantOffers?.offerTitle
                            menuCell.OfferNameLabel.text = "\(GetIndex.rstaurantOffers?.discount ?? 0)"
                        }else{
                            menuCell.OfferTitlelabel.isHidden = true
                            menuCell.OfferNameLabel.isHidden = true
                        }
                        
                        if let image = GetIndex.restaurant.RestaurantImage{
                            loadImage(from: image ) { image  in
                                if let img = image {
                                    DispatchQueue.main.async {
                                        menuCell.ItemImgView.image = img
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                menuCell.ItemImgView.image = emptyImage
                            }
                        }
                    }
                    return menuCell
                }
            } else {
                if filterRestaurantsForSearch.isEmpty{
                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    emptyCell.textLabel?.text = "No Restaurants found"
                    emptyCell.textLabel?.textAlignment = .center
                    return emptyCell
                }else{
                    let menuCell = MenuTableView.dequeueReusableCell(withIdentifier: "RestaurantMenuTVC", for: indexPath)as! RestaurantMenuTVC
                    menuCell.forRestaurant = true
                    let restaurantsWithSignatureItems = filterRestaurantsForSearch[indexPath.row]
                    menuCell.configureRestaurant(with: restaurantsWithSignatureItems )
                    
                    
                    menuCell.reloadDataAfterFavActionClosure = { [weak self] in
                        //                           SVProgressHUD.show()
                        fetchFavioureRestaurant {
                            self?.fetchUserFavouriteRestaurantID()
                            DispatchQueue.main.async {
                                
                                self?.MenuTableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                            
                        }
                    }
                    
                    if !JsonDataArrays.FavouriteRestaurantIDArray.isEmpty {
                        if let restaurantID = restaurantsWithSignatureItems.restaurant.RestaurantID {
                            if JsonDataArrays.FavouriteRestaurantIDArray.contains(restaurantID) {
                                menuCell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                menuCell.isFavorite = true
                            } else {
                                menuCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                                menuCell.isFavorite = false
                            }
                        }
                    }else{
                        menuCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        menuCell.isFavorite = false
                    }
                    
                    return menuCell
                }
            }
        }else {
            
            
            if selectedFor == "restaurant" {
                if self.restaurantRatingsDataArray.isEmpty {
                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    emptyCell.textLabel?.text = "No Reviews"
                    emptyCell.textLabel?.textAlignment = .center
                    return emptyCell
                } else {
                    var sortedRatingsDataArray = self.restaurantRatingsDataArray
                    if let userReviewIndex = self.restaurantRatingsDataArray.firstIndex(where: { $0.UserID == loginUserID }) {
                        submitCommentButton.isEnabled = false
                        //                           ratingView.isUserInteractionEnabled = false
                        
                        //                           leaveCommentTF.isEnabled = false
                        // Move the user's review to the top
                        let userReview = sortedRatingsDataArray.remove(at: userReviewIndex)
                        sortedRatingsDataArray.insert(userReview, at: 0)
                    }
                    let review = sortedRatingsDataArray[indexPath.row]
                    let reviewCell = reviewTableView.dequeueReusableCell(withIdentifier: "ViewAllReviewsTVC") as! ViewAllReviewsTVC
                    reviewCell.configure(with: review, currentUserId: loginUserID!)
                    reviewCell.delegate = self
                    return reviewCell
                }
            }else{
                if self.ItemRatingReviewDataArray.isEmpty {
                    let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    emptyCell.textLabel?.text = "No Reviews"
                    emptyCell.textLabel?.textAlignment = .center
                    return emptyCell
                }else{
                    var sortedItemRating = ItemRatingReviewDataArray
                    if let findIndex = ItemRatingReviewDataArray.firstIndex(where: { $0.UserID == loginUserID }) {
                        submitCommentButton.isEnabled = false
                        ratingView.isUserInteractionEnabled = false
                        leaveCommentTF.isEnabled = false
                        let removeUserFromArray = sortedItemRating.remove(at: findIndex)
                        sortedItemRating.insert(removeUserFromArray, at: 0)
                    }
                    
                    let reviewCell = reviewTableView.dequeueReusableCell(withIdentifier: "ViewAllReviewsTVC")as! ViewAllReviewsTVC
                    reviewCell.delegate = self
                    let review = sortedItemRating[indexPath.row]
                    reviewCell.configureWithItem(with: review, currentUserId: loginUserID!)
                    return reviewCell
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == MenuTableView {
            return 170
        } else {
            if selectedFor == "restaurant" {
                return self.restaurantRatingsDataArray.isEmpty ? 140 : 100
            } else {
                return self.ItemRatingReviewDataArray.isEmpty ? 140 : 100
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == MenuTableView{
            switch selectedFor {
            case "restaurant": //menuItems
                if indexPath.section < itemsGroupedByCategoryForSearch.count{
                    //
                    if !itemsGroupedByCategoryForSearch[indexPath.section].item.isEmpty{
                        print("-> itemsGroupedByCategoryForSearch.count",indexPath.section ,itemsGroupedByCategoryForSearch.count)
                        let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
                        
                        
                        let dishes = itemsGroupedByCategoryForSearch[indexPath.section].item[indexPath.row]
                        let selectedFoodName = dishes.Item.ItemTitle
                        restarantHomeVC.selectedFor = "dishes"
                        restarantHomeVC.selectedSignatureItem = [dishes]
                        restarantHomeVC.modalPresentationStyle = .fullScreen
                        restarantHomeVC.modalTransitionStyle = .coverVertical
                        restarantHomeVC.restaurantName = selectedFoodName ?? ""
                        self.present(restarantHomeVC, animated: true, completion: nil)
                    } }
                else{
                    if !waiterModelForSearch.isEmpty{
                        let waiterCell = storyboard?.instantiateViewController(identifier: "WaiterDetailsVC") as! WaiterDetailsVC
                        let waiter = waiterModelForSearch[indexPath.row]
                        waiterCell.userDataArray = JsonDataArrays.userDataArray
                        waiterCell.waiterData = [waiter]
                        waiterCell.modalPresentationStyle = .fullScreen
                        waiterCell.modalTransitionStyle = .coverVertical
                        
                        self.present(waiterCell, animated: true, completion: nil)
                    }
                }
            case "cuisines": // available restaurants
                
                if !filterRestaurantsForSearch.isEmpty{
                    let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
                    let selectedFood = filterRestaurantsForSearch[indexPath.row]
                    restarantHomeVC.selectedFor = "restaurant"
                    
                    restarantHomeVC.modalPresentationStyle = .fullScreen
                    restarantHomeVC.modalTransitionStyle = .coverVertical
                    // restarantHomeVC.restaurantName = selectedFoodName
                    
                    
                    getRestarantImage.removeAll()
                    //                                        let selectedRestaurant = JsonDataArrays.restaurantCompleteDataArray[indexPath.row]
                    let selectedId = selectedCuisine[0].Item.RestaurantID
                    let getRestarantImages = self.restaurantImages.filter({ $0.RestaurantID == selectedId })
                    
                    getRestarantImage.append(contentsOf: getRestarantImages)
                    if getRestarantImage.isEmpty {
                        
                        let res = JsonDataArrays.restaurantCompleteDataArray.filter { $0.restaurant.RestaurantID == selectedId }
                        getImageArray = [res[0].restaurant.RestaurantImage ?? ""]
                        restarantHomeVC.getImageArray = self.getImageArray
                    }else {
                        
                        if let firstRestaurantImage = getRestarantImage.first {
                            let image1 = firstRestaurantImage.ImageOne
                            let image2 = firstRestaurantImage.ImageTwo
                            let image3 = firstRestaurantImage.ImageThree
                            getImageArray.removeAll()
                            getImageArray.append(image1)
                            getImageArray.append(image2)
                            getImageArray.append(image3)
                            restarantHomeVC.getImageArray = self.getImageArray
                        }
                        
                    }
                    
                    restarantHomeVC.selectedRestaurantData = [selectedFood]
                    self.present(restarantHomeVC, animated: true, completion: nil)
                }
            default: // available restaurants
                if !filterRestaurantsForSearch.isEmpty{
                    let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
                    let selectedFood = filterRestaurantsForSearch[indexPath.row]
                    restarantHomeVC.selectedFor = "restaurant"
                    
                    
                    getRestarantImage.removeAll()
                    //                                        let selectedRestaurant = JsonDataArrays.restaurantCompleteDataArray[indexPath.row]
                    let selectedId = selectedSignatureItem[0].Item.RestaurantID
                    let getRestarantImages = self.restaurantImages.filter({ $0.RestaurantID == selectedId })
                    
                    getRestarantImage.append(contentsOf: getRestarantImages)
                    if getRestarantImage.isEmpty {
                        
                        let res = JsonDataArrays.restaurantCompleteDataArray.filter { $0.restaurant.RestaurantID == selectedId }
                        
                        getImageArray = [res[0].restaurant.RestaurantImage ?? ""]
                        restarantHomeVC.getImageArray = self.getImageArray
                    }else {
                        
                        if let firstRestaurantImage = getRestarantImage.first {
                            let image1 = firstRestaurantImage.ImageOne
                            let image2 = firstRestaurantImage.ImageTwo
                            let image3 = firstRestaurantImage.ImageThree
                            getImageArray.removeAll()
                            getImageArray.append(image1)
                            getImageArray.append(image2)
                            getImageArray.append(image3)
                            restarantHomeVC.getImageArray = self.getImageArray
                        }
                        
                    }
                    
                    restarantHomeVC.modalPresentationStyle = .fullScreen
                    restarantHomeVC.modalTransitionStyle = .coverVertical
                    //     restarantHomeVC.restaurantName = selectedFoodName
                    
                    restarantHomeVC.selectedRestaurantData = [selectedFood]
                    self.present(restarantHomeVC, animated: true, completion: nil)}
            }
        }
        
        else{
            //review tableview
        }
    }
}


extension RestaurantHomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedFor == "restaurant" {
            return getImageArray.count
        }else if selectedFor == "cuisines" {
            return 1
            
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let introCell = introCollectionView.dequeueReusableCell(withReuseIdentifier: "RestuarantHomeIntroCVC", for: indexPath) as! RestuarantHomeIntroCVC
        
        if selectedFor == "restaurant" {
            let imageUrl = getImageArray[indexPath.item]
            // Assuming you have a function to load image asynchronously
            loadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    introCell.foodImage.image = image
                }
            }
            //   }
        } else if selectedFor == "cuisines" {
            if let firstItem = selectedCuisine.first {
                let imageUrl = firstItem.Item.itemImage
                
                loadImage(from: imageUrl!) { image in
                    DispatchQueue.main.async {
                        introCell.foodImage.image = image
                    }
                }
            } else {
                // Handle the case where `selectedCuisine` is empty
                print("No cuisine items selected.")
            }
        }
        
        else{
            // let img = getImageArray[indexPath.item]
            for item in selectedSignatureItem {
                let imageUrl = item.Item.itemImage
                
                loadImage(from: imageUrl!) { image in
                    DispatchQueue.main.async {
                        introCell.foodImage.image = image
                    }
                }
            }
            
        }
        return introCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedFor == "cuisines" {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }else   if selectedFor == "restaurant" {
            if getImageArray.count == 1 {
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            }else{
                
            }
        }else{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        // return self.introCollectionView.bounds.size
        let width = self.view.frame.size.width / 1.3
        let height = introCollectionView.bounds.height / 1.1
        return CGSize(width: width, height: height)
    }
    
}

extension RestaurantHomeVC  : commandOptionsProtocal {
    
    func deleteRestaurantRating(withId rateId: String,restaurantID:String) {
        guard let url = URL(string: restaurantRatingURL) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let requestBody: [String: Any] = [
            "partitionKey": "RestaurantRating",
            "rowKey": rateId
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
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        
                        self.fetchUserRestaurantRatingJsonData(restaurantID: restaurantID, completion: {
                            self.filterRestaurantRatingReview()
                        }
                                                               
                        )
                    }
                    
                    DispatchQueue.main.async {
                        if let restaurantRating = self.restaurantRatingsDataArray as? [RestaurantRatingData] {
                            // Calculate the total rating
                            
                            let idRating = self.restaurantRatingsDataArray.filter { $0.UserID == loginUserID }
                            let id = idRating.first?.Rating
                            // Calculate the count of ratings (excluding nil values)
                            let count = restaurantRating.filter { $0.Rating != nil }.count - 1
                            let totalRating = restaurantRating.reduce(0) { $0 + ($1.Rating ?? 0) }
                            let minusValue =   totalRating - (id ?? 0)
                            let averageRating: Double = count > 0 ? Double(minusValue ) / Double(count) : 0
                            
                            self.getRatingAfterDelate = Double(averageRating)
                            
                            self.getRatingAfterDelate = Double(averageRating.rounded(toPlaces: 2))
                            self.submitCommentButton.isEnabled = true
                        }
                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                        controller.modalPresentationStyle = .fullScreen
                        self.ReviewDelegate?.didPostReviewSuccessfully(for: .restaurant)
                        controller.message = "Restaurant ratings deleted successfully"
                        self.present(controller, animated: true)
                    }
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    
    func fetchUserRestaurantRatingJsonData(restaurantID: String, completion: @escaping () -> Void) {
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
                    
                    let allratings = records.filter { $0.RestaurantId == restaurantID }
                    
                    self.selectedRestaurantData[0].restaurantRatings = allratings
                    self.filterRestaurantRatingReview()
                    
                }
                
                print("Fetched and updated user rating JSON data.")
                completion()
                
            case .failure(let error):
                print("Error: \(error)")
                completion()
            }
        }
    }
    
    
    func deleteItemRating(withId rateId: String) {
        
        guard let url = URL(string: ItemRatingURL) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let requestBody: [String: Any] = [
            "partitionKey": "ItemRating",
            "RowKey": rateId
            
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
                print("Error: \(error)")
                
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        
                        if selectedFor == "cuisines"{
                            if let id = selectedCuisine[0].Item.ItemID{
                                fetchUserItemRatingJsonData(itemID: id ) {
                                    
                                }
                            }
                        }else{
                            if let id = selectedSignatureItem[0].Item.ItemID{
                                fetchUserItemRatingJsonData(itemID: id ) {
                                    
                                }
                            }
                        }
                    }
                    
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    
                }
                DispatchQueue.main.async {if let restaurantRating = self.ItemRatingReviewDataArray as? [ItemRatingReviewData] {
                    // Calculate the total rating
                    
                    let idRating = self.ItemRatingReviewDataArray.filter { $0.UserID == loginUserID }
                    let id = idRating.first?.Rating
                    // Calculate the count of ratings (excluding nil values)
                    let count = restaurantRating.filter { $0.Rating != nil }.count - 1
                    let totalRating = restaurantRating.reduce(0) { $0 + ($1.Rating ?? 0) }
                    let minusValue =   totalRating - (id ?? 0)
                    let averageRating: Double = count > 0 ? Double(minusValue ) / Double(count) : 0
                    
                    self.getRatingAfterDelate = Double(averageRating)
                    
                    self.getRatingAfterDelate = Double(averageRating.rounded(toPlaces: 2))
                    self.submitCommentButton.isEnabled = true
                }
                    let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                    controller.modalPresentationStyle = .fullScreen
                    
                    self.ReviewDelegate?.didPostReviewSuccessfully(for: .item)
                    controller.message = "Restaurant ratings Deleted successfully"
                    self.present(controller, animated: true)
                }
            }
        }.resume()
    }
    
    
    func fetchUserItemRatingJsonData(itemID: String, completion: @escaping () -> Void) {
        guard let url = URL(string: ItemRatingURL) else {
            print("Invalid URL")
            completion()
            return
        }
        
        fetchJSONData(from: url) { [self] (result: Result<fetchItemRatingsApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                JsonDataArrays.userRatingsDataArray.removeAll()
                // restaurantRatingArray = jsondata
                
                if let records = jsondata.records {
                    
                    let Itemrecords = records.filter { $0.userID == loginUserID }
                    
                    let allratings = records.filter { $0.itemID == itemID }
                    
                    if selectedFor == "cuisines"{
                        
                        self.selectedCuisine[0].ItemRatings = allratings
                        self.fetchItemRatingJsonData(Item: self.selectedCuisine[0])
                    }else{
                        selectedSignatureItem[0].ItemRatings = allratings
                        self.fetchItemRatingJsonData(Item: self.selectedSignatureItem[0])
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
    func showAlert(withTitle title: String, message: String, viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
            
        }
        //    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okAction)
        //  alertController.addAction(cancel)
        viewController.present(alertController, animated: true, completion: nil)
    }
    func showAlert2(withTitle title: String, message: String, viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            completion?()
            
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        viewController.present(alertController, animated: true, completion: nil)
    }
    func openOptions(cell: ViewAllReviewsTVC, options: commandOptions) {
        switch options {
        case .Delete:
            if selectedFor == "restaurant"{
                if let rateId = cell.restaurantRateID{
                    
                    handleDeleteAction(for: rateId, restaurantID: selectedRestaurantData[0].restaurant.RestaurantID ?? "",viewController: self)
                    self.userEnteredRating.rating = 0
                    self.userEnteredRating.isUserInteractionEnabled = true
                } else {
                    print("Rate ID or Partition Key ID not found")
                }
            }else{
                if let itemId = cell.itemID {
                    handleDeleteAction(for: itemId, restaurantID: "", viewController: self)
                }
                self.userEnteredRating.isUserInteractionEnabled = true
            }
        case .Edit:
            if selectedFor == "restaurant"{
                leaveCommentTF.text = previousRestaurantRatingByLoginUser.first?.Review
                let offset = CGPoint(x: 0, y: rateThisPlaceView.frame.origin.y - scrollView.contentInset.top)
                
                scrollView.setContentOffset(offset, animated: true)
                submitCommentButton.isEnabled = true
                self.userEnteredRating.isUserInteractionEnabled = true
            }else{
                leaveCommentTF.text = previousItemRatingByLoginUser.first?.Review
                
                let rating : Double = Double(previousItemRatingByLoginUser.first?.Rating ?? 0)
                ratingView.rating = rating
                let offset = CGPoint(x: 0, y: rateThisPlaceView.frame.origin.y - scrollView.contentInset.top)
                
                scrollView.setContentOffset(offset, animated: true)
                leaveCommentTF.isEnabled = true
                submitCommentButton.isEnabled = true
                self.userEnteredRating.isUserInteractionEnabled = true
            }
        }
    }
    
    func handleDeleteAction(for rateId: String,restaurantID :String ,viewController: UIViewController) {
        if selectedFor == "restaurant"{
            showAlert2(withTitle: "Confirm Delete", message: "Are you sure you want to delete this rating?", viewController: viewController) {
                self.deleteRestaurantRating(withId: rateId, restaurantID: restaurantID)
            }
        }else {
            showAlert2(withTitle: "Confirm Delete", message: "Are you sure you want to delete this rating?", viewController: viewController) {
                self.deleteItemRating(withId: rateId)
            }
        }
        
    }
}
extension RestaurantHomeVC {
    
    
    func fetchRestaurantImages(completion : @escaping () -> Void) {
        let urlString = "https://thetiptabapi.azurewebsites.net/api/RestaurantImages"
        
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
                
                completion()
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        
        task.resume()
    }
    
    func  setImagesInCollectionView(selectedFor:String){
        
        var selectedDataID = ""
        var selectedImage = ""
        
        switch selectedFor{
            
        case "restaurant" :
            fetchRestaurantImages{ [self] in
                getRestarantImage.removeAll()
                selectedDataID = selectedRestaurantData[0].restaurant.RestaurantID ?? ""
                
                let getRestarantImages = self.restaurantImages.filter({ $0.RestaurantID == selectedDataID })
                getRestarantImage.append(contentsOf: getRestarantImages)
                if getRestarantImage.isEmpty {
                    self.getImageArray = [selectedRestaurantData[0].restaurant.RestaurantImage ?? ""]
                    
                }else {
                    if let firstRestaurantImage = getRestarantImage.first {
                        let image1 = firstRestaurantImage.ImageOne
                        let image2 = firstRestaurantImage.ImageTwo
                        let image3 = firstRestaurantImage.ImageThree
                        getImageArray.removeAll()
                        getImageArray.append(image1)
                        getImageArray.append(image2)
                        getImageArray.append(image3)
                        //                restarantHomeVC.getImageArray = self.getImageArray
                        
                    }
                    
                }
            }
            
        case "cuisines" :
            self.getImageArray.append(selectedCuisine[0].Item.itemImage ?? "")
        default :
            self.getImageArray.append(selectedSignatureItem[0].Item.itemImage ?? "")
            
            
        }
        
        DispatchQueue.main.async{
            self.introCollectionView.reloadData()
        }
    }
}
