//
//  SignatureDishesDetailVC.swift
//  TipTap
//
//  Created by sriram on 27/11/23.
//

import UIKit
import SVProgressHUD

class SignatureDishesDetailVC: UIViewController  ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{
    var internetCheckTimer : Timer?
    var FavouriteItemsIDArray = [UserFavItemIDs]()
    var signatureDishModel : [ItemCompleteData] = []
    var filteredItems :[ItemCompleteData] = []
    var placeholderIndex = 0
    var placeholders = ["Search here Featured Restaurents", "Search here Your Favorite Dishes", "Search here For Signature Dishes"] // Add your desired placeholders here
    var timer: Timer?
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dishesCollectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var gridViewOutLet: UIButton!
    @IBOutlet weak var listViewOutlet: UIButton!
    var listView = false
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField! {
        didSet{
            searchTF.tintColor = .lightGray
            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHUD()
        dishesCollectionView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.dishesCollectionView.isHidden = false
            self?.hideHUD()
            self?.dishesCollectionView.dataSource = self
            self?.dishesCollectionView.delegate = self
            
            self?.dishesCollectionView.reloadData() // Reload table view after dismissing SVProgressHUD
        }
        
        
        
        
        
        
        
        
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
                internetCheckTimer?.tolerance = 2.0
        FavouriteItemsIDArray = JsonDataArrays.FavouriteItemsIDArray
         gridViewOutLet.layer.borderWidth = 2
        gridViewOutLet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
        
        headingLabel.text = "Dishes"
            
        setUI()
//        for signatureDish in signatureDishModel{
//            filteredItems.append(signatureDish)
//        }
        
        filteredItems = signatureDishModel
        let customFlowLayout = TwoByTwoFlowLayout()
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 10)
        dishesCollectionView.collectionViewLayout = customFlowLayout
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
        controller.FromItems = true
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
        UIView.transition(with: dishesCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
          fetchFavouriteItems {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.FavouriteItemsIDArray = JsonDataArrays.FavouriteItemsIDArray

                    self.dishesCollectionView.reloadData()
                }
            }

           
        }, completion: nil)
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
      //  dishesCollectionView.reloadData()
        updatePlaceholder()
    }
    
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
    
    func updateFilteredData(searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            // Unwrapped searchText is not nil and not empty
            filteredItems = signatureDishModel.filter {
                guard let itemTitle = $0.Item.ItemTitle else { return false } // Check if ItemTitle is nil
                return itemTitle.lowercased().contains(searchText.lowercased())
            }
        } else {
            // searchText is nil or empty
            filteredItems = signatureDishModel
        }
        
        // Update UI on the main thread
        DispatchQueue.main.async {
            self.dishesCollectionView.reloadData()
        }
    }
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if listView {
            let listCell = dishesCollectionView.dequeueReusableCell(withReuseIdentifier: "SignatureDishesListViewCVC", for: indexPath)as! SignatureDishesListViewCVC
            let dishes = filteredItems[indexPath.item]
            listCell.configureItem(dishes: dishes)

            
            if !FavouriteItemsIDArray.isEmpty{
                if FavouriteItemsIDArray.contains(where: { $0.itemID == dishes.Item.ItemID }){
                    listCell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    listCell.favoriteButton.tintColor = .systemRed
                    listCell.isFavorite = true
                }else{
                    listCell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    listCell.isFavorite = false
                }
            }
            
        listCell.reloadDishesCVAfterFavActionClosure = {
            fetchFavouriteItems{
                DispatchQueue.main.async {
                    self.FavouriteItemsIDArray = JsonDataArrays.FavouriteItemsIDArray
                    self.dishesCollectionView.reloadItems(at: [indexPath])
                }
            }
            }
            return listCell
        }
        else{
            let salesCell = dishesCollectionView.dequeueReusableCell(withReuseIdentifier: "SignatureDishesCVC", for: indexPath)as! SignatureDishesCVC
            let dishes = filteredItems[indexPath.item]
          //  let itemOffer = getItemOffer(item: dishes)
            salesCell.configure(with: dishes)
            
            if !FavouriteItemsIDArray.isEmpty{
                if FavouriteItemsIDArray.contains(where: { $0.itemID == dishes.Item.ItemID }){
                    salesCell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    salesCell.favoriteBtn.tintColor = .systemRed
                    salesCell.isFavorite = true
                }else{
                    salesCell.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    salesCell.isFavorite = false
                }
            }
            salesCell.reloadDishesCVAfterFavActionClosure = {
                fetchFavouriteItems{
                    DispatchQueue.main.async {
                        self.FavouriteItemsIDArray = JsonDataArrays.FavouriteItemsIDArray
                        self.dishesCollectionView.reloadItems(at: [indexPath])
                    }
                }
               
                
                }
            return salesCell
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
        let dishes = filteredItems[indexPath.item]
        let selectedFoodName = dishes.Item.ItemTitle
        restarantHomeVC.selectedFor = "dishes"
        restarantHomeVC.ItemID = dishes.Item.ItemID
        restarantHomeVC.selectedSignatureItem = [dishes]
        restarantHomeVC.modalPresentationStyle = .fullScreen
        restarantHomeVC.modalTransitionStyle = .coverVertical
        restarantHomeVC.restaurantName = selectedFoodName ?? ""
        self.present(restarantHomeVC, animated: true, completion: nil)
    }
    
    
    //MARK: cell for Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if listView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let cellWidth = (collectionView.bounds.width - 30)
                return CGSize(width: cellWidth, height: 170)
            } else {
                let cellWidth = (collectionView.bounds.width - 30)
                return CGSize(width: cellWidth, height: 160)
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

extension SignatureDishesDetailVC : filterOptionDelegate{
    
    
    func applyFilterInTerendigThisWeekVC(_ vc: FilterVC, option: String) {
        SVProgressHUD.show()
        self.applyFilter(option: option)
    }
 
   //Filter
   //2. Top rated
    func filterTopRatedItems() {
        
        // Flatten the filteredItems array and then sort it based on itemAverageRating
     //   let flattenedItems = filteredItems.flatMap { $0 }
        filteredItems =  filteredItems.sorted {
            guard let rating1 = $0.itemAverageRating, let rating2 = $1.itemAverageRating else {
                // Handle the case where either rating is nil
                return false
            }
            // Sort in descending order of itemAverageRating
            return rating1 > rating2
        }
        
        SVProgressHUD.dismiss()
        // After sorting, reload the collection view to reflect changes
        self.dishesCollectionView.reloadData()
    }
   //["Top Rated", "Nearest Me", "Most Popular"]
   
   func applyFilter(option:String){
       switch option{
       case "Top Rated" :
           self.filteredItems = signatureDishModel
           filterTopRatedItems()
           break
       
       case "Most Popular" :
           self.filteredItems = signatureDishModel
           fetchFavouriteItemsforFilter{item in
               // filter  'filteredItems'
                self.filterMostPopularItem(FavItemt : item)
           }
           break
       case "Favourite" :
           self.filteredItems = signatureDishModel
           FilterFavouriteItems()
           break
       default:
           break
           
           
       }
   }
    
    static var AllFavoriteItemsArray = [userFavouriteItem]()
    func fetchFavouriteItemsforFilter(completion: @escaping ([userFavouriteItem]) -> Void) {
       
        guard let url = URL(string: FavouriteItemURL) else {
            print("Invalid URL")
            return
        }
 
        fetchJSONData(from: url) { (result: Result<fetchuserFavouriteItemApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                SignatureDishesDetailVC.AllFavoriteItemsArray = jsondata.records ?? []
                
                completion(SignatureDishesDetailVC.AllFavoriteItemsArray)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
   
    func filterMostPopularItem(FavItemt: [userFavouriteItem]) {
        // Step 1: Count favorites for each restaurant
        var favoriteCounts = [String: Int]()
        for favorite in FavItemt {
            if let restaurantID = favorite.RestaurantID {
                favoriteCounts[restaurantID] = (favoriteCounts[restaurantID] ?? 0) + 1
            }
        }
 
        // Step 2: Sort restaurant details based on favorite counts
        let items = filteredItems.compactMap { $0 }
        let sortedRestaurantDetails = items.sorted { (detail1, detail2) -> Bool in
            guard let itemID1 = detail1.Item.ItemID,
                  let itemID2 = detail2.Item.ItemID else {
                // Handle the case where either itemID is nil
                return false
            }
 
            let count1 = favoriteCounts[itemID1] ?? 0
            let count2 = favoriteCounts[itemID2] ?? 0
            return count1 > count2 // Sort in descending order of favorites count
        }
 
        // Step 3: Retrieve top items
        let numberOfTopItems = min(filteredItems.count, sortedRestaurantDetails.count)
        let topItems = Array(sortedRestaurantDetails.prefix(numberOfTopItems))
 
        print(topItems)
 
        filteredItems = topItems
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.dishesCollectionView.reloadData()
        }
    }
    
    func FilterFavouriteItems(){
       filteredItems  = filteredItems.filter { item in
            // Check if any of the item IDs in FavouriteItemsIDArray match the Item's ID
            FavouriteItemsIDArray.contains { favItem in
                favItem.itemID == item.Item.ItemID // Assuming Item has an itemID property
            }
        }
        
      //  filteredItems = filteredItemsWithFavorites
        SVProgressHUD.dismiss()
        self.dishesCollectionView.reloadData()
    }
 
}
