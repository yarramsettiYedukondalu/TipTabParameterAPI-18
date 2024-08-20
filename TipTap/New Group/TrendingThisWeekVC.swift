//
//  TrendingThisWeekVC.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//


import UIKit
import CoreLocation
import SVProgressHUD
 
class TrendingThisWeekVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{
    var selectedRestaurantData = [RestaurantCompleteData]()
    var noResultsView = alartView()
    var internetCheckTimer : Timer?
    var selectedFor : String = ""
  //  var restaurantModel = [Restaurant]()
    var RestaurantIDArray = [String]() //for store user's Favourite restaurant id's
    var restaurantImages = [RestaurantImage]()
    var getImageArray = [String]()
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var gridViewOutLet: UIButton!
    @IBOutlet weak var listViewOutlet: UIButton!
    var listView = false
    @IBOutlet weak var searchTF: UITextField! {
        didSet{
            searchTF.tintColor = .lightGray
            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
        }
    }
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    
    var filteredItems :[RestaurantCompleteData] = []

    
    var supports = supportFile()
    var Rnames : [String] = []
    
    var placeholderIndex = 0
    var placeholders = ["Search here Featured Restaurents", "Search here Your Favorite Dishes", "Search here For Signature Dishes"] // Add your desired placeholders here
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.becomeFirstResponder()
        showHUD()
        trendingCollectionView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.trendingCollectionView.isHidden = false
            self?.hideHUD()
            self?.trendingCollectionView.dataSource = self
            self?.trendingCollectionView.delegate = self
            
            self?.trendingCollectionView.reloadData() // Reload table view after dismissing SVProgressHUD
        }
       
        
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
               internetCheckTimer?.tolerance = 2.0
        self.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
        updatePlaceholder()
        
        //    Rnames = restaruntName
        setUI()
        noResultsView.setupNoResultsView(noResultsView: noResultsView, view: self.view)
        gridViewOutLet.layer.borderWidth = 2
        gridViewOutLet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
      
       
        for restaurant in JsonDataArrays.restaurantCompleteDataArray{
                filteredItems.append(restaurant)
            }
            headingLabel.text = "Restaurants"
    
       // supports.labelSizes(mylabel: headingLabel, mysize: 30, fontWeight: .bold, textColor: .black)
     
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.systemPink // Change to your desired color
        
        let customFlowLayout = TwoByTwoFlowLayout()
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 10)
        trendingCollectionView.collectionViewLayout = customFlowLayout
        fetchRestaurantImages()
        
    }
    private func showNoResultsView() {
          noResultsView.isHidden = false
        
          trendingCollectionView.isHidden = true
          
          // Configure noResultsView with an image and message
        noResultsView.getGif(image: noResultsView.imageView, imageURL: "man-620_256", speed: 13.0)
          noResultsView.label.text = "Please Search With Different Key Word!!!"
        
      }
      
      private func hideNoResultsView() {
          noResultsView.isHidden = true
          trendingCollectionView.isHidden = false
      }
   
    func updateFilteredData(searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredItems = JsonDataArrays.restaurantCompleteDataArray.filter {
                guard let restaurantTitle = $0.restaurant.RestaurantTitle else { return false }
                return restaurantTitle.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredItems = JsonDataArrays.restaurantCompleteDataArray
           
        }
        
        DispatchQueue.main.async {
            self.trendingCollectionView.reloadData()
            if self.filteredItems.isEmpty {
                self.showNoResultsView()
                self.filterBtn.isHidden = true
            } else {
                self.hideNoResultsView()
                self.filterBtn.isHidden = false
            }
        }
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
        
    @objc func checkInternet() {
           if !Reachability.isConnectedToNetwork() {
               internetCheckTimer?.invalidate()
               redirectToResponsePage()
           }
       }
       func redirectToResponsePage() {
           // Implement the logic to navigate to the response page
           let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as! InternetViewController
           controller.message = "No Internet Connection"
           self.present(controller, animated: true)
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
    func setUI(){
        //backButton.backButtonStyle()
        searchTF.applyCustomPlaceholderStyle(size: "large")
        headingLabel.applyLabelStyle(for: .titleBlack)
    }
    
    @IBAction func filterBtnAct(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "FilterVC") as! FilterVC
        controller.delegate = self
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
    }
    
    @IBAction func listView(_ sender: Any) {
      
        listView = true
        gridViewButtonLayout()
        animateViewModeChange()
        
        
    }
    @IBAction func gridView(_ sender: Any) {
       
        listView = false
        
        gridViewButtonLayout()
        animateViewModeChange()
    }
    func gridViewButtonLayout(){
        if listView{
            listViewOutlet.layer.borderWidth = 2
            gridViewOutLet.layer.borderWidth = 0
            listViewOutlet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
            
        }else {
            listViewOutlet.layer.borderWidth = 0
            gridViewOutLet.layer.borderWidth = 2
            gridViewOutLet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
        }
    }
    func animateViewModeChange() {
        UIView.transition(with: trendingCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            fetchFavioureRestaurant {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
                    self.trendingCollectionView.reloadData()

                }
            }
        }, completion: nil)
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
     
        updatePlaceholder()
    }
     
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        filterItems(with: currentText)
//        return true
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
            // Your code related to text field editing, if needed
        }
     
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentText = textField.text else {
                return true
            }
     
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            updateFilteredData(searchText: newText)
     
            return true
        }
     
    
//func updateFilteredData(searchText: String?) {
//    if let searchText = searchText, !searchText.isEmpty {
//        // If searchText is not nil and not empty
//        filteredItems = JsonDataArrays.restaurantCompleteDataArray.filter {
//            guard let restaurantTitle = $0.restaurant.RestaurantTitle else { return false } // Check if RestaurantTitle is nil
//            return restaurantTitle.lowercased().contains(searchText.lowercased())
//        }
//    } else {
//        // If searchText is nil or empty, show all items
//        filteredItems = JsonDataArrays.restaurantCompleteDataArray
//    }
//
//    DispatchQueue.main.async {
//        self.trendingCollectionView.reloadData()
//    }
//}
    
    func updatePlaceholder() {
        searchTF.placeholder = placeholders[placeholderIndex]
          }
          func startTimer() {
              timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updatePlaceholderWithTimer), userInfo: nil, repeats: true)
          }
          @objc func updatePlaceholderWithTimer() {
              placeholderIndex = (placeholderIndex + 1) % placeholders.count
              updatePlaceholder()
          }
          override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)
              timer?.invalidate()
          }
}


extension TrendingThisWeekVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if listView {
            let activeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listview", for: indexPath) as! ListViewCollectionViewCell
            
            let restaurantFiltered = filteredItems[indexPath.item]
            activeCell.configure(restaurant: restaurantFiltered)
        
            
            if !RestaurantIDArray.isEmpty {
                if let restaurantID = restaurantFiltered.restaurant.RestaurantID {
                    if RestaurantIDArray.contains(restaurantID) {
                        activeCell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        activeCell.isFavorite = true
                    } else {
                        activeCell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        activeCell.isFavorite = false
                    }
                }
            }
            
            activeCell.reloadTrendingCVAfterFavActionClosure = {
                fetchFavioureRestaurant {
                    
                    DispatchQueue.main.async {
                        self.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
                        self.trendingCollectionView.reloadItems(at: [indexPath])
                    }
                }
                
            }

            return activeCell
        } else {
            let activeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrenWeekCollectionViewCell
            
            let restaurantFiltered = filteredItems[indexPath.item]
            
            activeCell.configure(restaurantFiltered: restaurantFiltered)
            if !RestaurantIDArray.isEmpty {
                if let restaurantID = restaurantFiltered.restaurant.RestaurantID {
                    if RestaurantIDArray.contains(restaurantID) {
                        activeCell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        activeCell.isFavorite = true
                    } else {
                        activeCell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                        activeCell.isFavorite = false
                    }
                }
            }
            activeCell.reloadTrendingCVAfterFavActionClosure = {
                fetchFavioureRestaurant {
                    
                    DispatchQueue.main.async {
                        self.RestaurantIDArray = JsonDataArrays.FavouriteRestaurantIDArray
                        self.trendingCollectionView.reloadItems(at: [indexPath])
                    }
                }
                
            }
            return activeCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trendingCollectionView{
            if !JsonDataArrays.restaurantCompleteDataArray.isEmpty{
                let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
               
                let selectedRestaurant = JsonDataArrays.restaurantCompleteDataArray[indexPath.row]
                let selectedId = selectedRestaurant.restaurant.RestaurantID
                if   let userID = loginUserID {
                    
                    getRestarantImage.removeAll()
                    
                    let commentedUser = selectedRestaurant.restaurantRatings.filter { $0.RestaurantId == selectedId && $0.UserId == userID }
                    
                    print("CommentedID--->", commentedUser)
                    if !commentedUser.isEmpty {
                     //   commandForChecking = true
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
    }
        //MARK: cell for Height
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            if listView {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let cellWidth = (collectionView.bounds.width - 30)
                    return CGSize(width: cellWidth, height: 170)
                } else {
                    let cellWidth = (collectionView.bounds.width - 30)
                    return CGSize(width: cellWidth, height: 140)
                }
            }else{
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let cellWidth = (collectionView.bounds.width - 30) / 2
                    return CGSize(width: cellWidth, height: 290)
                } else {
                    let cellWidth = (collectionView.bounds.width - 30) / 2
                    return CGSize(width: cellWidth, height: 285)
                }
            }
        }
    }



extension TrendingThisWeekVC : filterOptionDelegate{
   
   static var AllFavoriteRestauranArray = [userFavouriteRestaurant]()
  
   func applyFilterInTerendigThisWeekVC(_ vc: FilterVC, option: String) {
       SVProgressHUD.show()
               self.applyFilter(option: option)
   }
 
   //Filter
   //1. Nearest Me
   func distanceBetweenCoordinates(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
       let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
       let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
       return location1.distance(from: location2)
   }
 
   // Function to filter restaurants based on nearest to current location
   func filterNearestRestaurants(restaurants: [RestaurantCompleteData], currentLocation: CLLocationCoordinate2D) -> [RestaurantCompleteData] {
       // Sort the restaurants based on their distances from the current location
       let sortedRestaurants = restaurants.sorted(by: { (restaurant1, restaurant2) -> Bool in
           let loc1 = CLLocationCoordinate2D(latitude: restaurant1.restaurant.Latitude ?? 0.0, longitude: restaurant1.restaurant.Longitude ?? 0.0)
           let loc2 = CLLocationCoordinate2D(latitude: restaurant2.restaurant.Latitude ?? 0.0, longitude: restaurant2.restaurant.Longitude ?? 0.0)
 
           let distance1 = distanceBetweenCoordinates(from: loc1, to: currentLocation)
           let distance2 = distanceBetweenCoordinates(from: loc2, to: currentLocation)
           return distance1 < distance2
       })
       
       return sortedRestaurants
   }
   
   //2. Top rated
  
   func filterTopRateRestaurant() {
       
       filteredItems.sort {
           if let rating1 = $0.restaurantAverageRating, let rating2 = $1.restaurantAverageRating {
               return rating1 > rating2
           } else {
               
               return false
           }
       }
       SVProgressHUD.dismiss()
       self.trendingCollectionView.reloadData()
   
   }
   
   
   //["Top Rated", "Nearest Me", "Most Popular"]
   
   func applyFilter(option:String){
       switch option{
       case "Top Rated" :
           filteredItems = JsonDataArrays.restaurantCompleteDataArray
           filterTopRateRestaurant()
           break
       case "Nearest Me":
           filteredItems = JsonDataArrays.restaurantCompleteDataArray
           if let cLocation = currentLocation{
               let res = filterNearestRestaurants(restaurants: filteredItems, currentLocation: cLocation)
               
               self.filteredItems = res
               SVProgressHUD.dismiss()
               self.trendingCollectionView.reloadData()
           }
           break
       case "Most Popular" :
           filteredItems = JsonDataArrays.restaurantCompleteDataArray
            fetchAllFavioureRestaurant{res in
               // filter  'filteredItems'
                self.filterMostPopularRes(FavResturant: res)
           }
           break
           
       case "Favourite" :
           filteredItems = JsonDataArrays.restaurantCompleteDataArray
           FilterFavouriteItems()
           break
       default:
           break
       }
   }
  
   
   func fetchAllFavioureRestaurant(completion: @escaping ([userFavouriteRestaurant]) -> Void) {
    
      
       JsonDataArrays.UserFavoriteRestauranArray.removeAll()
       let url = FavRestaurantURL
       let apiUrl = URL(string: url)
 
       fetchJSONData(from: apiUrl!) { (result: Result<fetchuserFavouriteRestaurantApiResponse, APIError>) in
           switch result {
           case .success(let jsondata):
              
                   if let records = jsondata.records{
                       TrendingThisWeekVC.AllFavoriteRestauranArray = records
                       
                   }
                
              completion(TrendingThisWeekVC.AllFavoriteRestauranArray)
            
           case .failure(let error):
               print("Error: \(error)")
           }
       }
   }
   
   func filterMostPopularRes(FavResturant : [userFavouriteRestaurant]){
       
       // Step 1: Count favorites for each restaurant
       var favoriteCounts = [String: Int]()
       for favorite in FavResturant {
           if let restaurantID = favorite.RestaurantID {
               favoriteCounts[restaurantID] = (favoriteCounts[restaurantID] ?? 0) + 1
           }
       }
 
       // Step 2: Sort restaurant details based on favorite counts
       let sortedRestaurantDetails = filteredItems.sorted { (detail1: RestaurantCompleteData, detail2: RestaurantCompleteData) -> Bool in
           if let restaurantID1 = detail1.restaurant.RestaurantID,
              let restaurantID2 = detail2.restaurant.RestaurantID {
               let count1 = favoriteCounts[restaurantID1] ?? 0
               let count2 = favoriteCounts[restaurantID2] ?? 0
               return count1 > count2 // Sort in descending order of favorites count
           }
           // Handle the case where restaurantID is nil, you might want to decide how to sort in this case
           return false
       }
       
       // Step 3: Retrieve top restaurants
       let numberOfTopRestaurants = filteredItems.count // Change this to the number of top restaurants you want to retrieve
       let topRestaurants = Array(sortedRestaurantDetails.prefix(numberOfTopRestaurants))
 
       print(topRestaurants)
       
       filteredItems = topRestaurants
       DispatchQueue.main.async{
           SVProgressHUD.dismiss()
           self.trendingCollectionView.reloadData()
       }
       
   }
    
    func FilterFavouriteItems(){
        filteredItems =  filteredItems.filter { item in
            // Check if any of the item IDs in FavouriteItemsIDArray match the Item's ID
            RestaurantIDArray.contains {  id in
                id == item.restaurant.RestaurantID // Assuming Item has an itemID property
            }
        }
        
//        filteredItems = filteredItemsWithFavorites
        SVProgressHUD.dismiss()
        self.trendingCollectionView.reloadData()
    }
}
